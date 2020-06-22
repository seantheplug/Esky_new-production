class BookingsController < ApplicationController
    before_action :set_booking, only: [:show, :edit, :update, :destroy]
    skip_after_action :verify_authorized, only: [:create]
    def index
        if params[:query].present?
            @bookings = policy_scope(Booking).joins(:service).joins(:user).global_search(params[:query])
            # .where(sql_query, query: "%#{params[:query]}%")
          else
      
            @bookings = policy_scope(Booking)
          end
          # below is all associated bookings
          @userbookings = @bookings.where(user: current_user)
          @provider_pending = current_user.bookings_as_providers.where(status: "pending")
          @provider_confirmed = current_user.bookings_as_providers.where(status: "confirmed")
    end

    def show
        authorize @booking
        @service = Service.find(@booking.service_id)
        authorize @service
        @service_geo = Service.geocoded
        @marker =
          [{
            lat: @service.latitude,
            lng: @service.longitude,
            infoWindow: render_to_string(partial: "info_window", locals: { service: @service }),
            image_url: helpers.asset_url('marker.png')
          }]
    end

    def new
        @booking = Booking.new
        @service = Service.find(params[:service_id])
        authorize @service
    end

    def create
        if current_user.stripe_id.blank?
            flash[:alert] = "Please update your payment method"
            return redirect_to payment_method_path
        end
        @booking = Booking.new(booking_params)
        @booking.personalize_description = params["booking"]["personalize_description"]    # uses strong parameters
        authorize @booking

        @booking.service_id = params[:service_id]
        @booking.user = current_user
        @booking.cost = @booking.service.rate
        if Booking.where(date: @booking.date).empty?
            if @booking.save
                flash[:alert] = "You will only be charged when the booking is confirmed by the service provider"
                redirect_to booking_path(@booking)    # redirect to page displaying the model
            else
                redirect_to service_path(@booking.service)
            end
        else
            respond_to do |format|
                format.html { redirect_to service_path(@booking.service), alert: "This timeslot is already booked, Please select other time"}
            end
        end
    end

    def edit
        # gives existing Instance to the form
    end

    def update
        authorize @booking
        if booking_params["status"] == "confirmed"
            if current_user.merchant_id.blank?
                flash[:alert] = "Please connect your stripe account to receive the payment from the client"
                return redirect_to payout_method_path
            end
            charge(@booking.service, @booking)
        end
        @booking.update(booking_params)
        if @booking.update(booking_params)
            redirect_to booking_path(@booking)
        else
            render :edit
        end
    end

    def destroy
        authorize @booking
        @booking.destroy
        redirect_to bookings_path
    end

   
 private
    def charge(service, booking)
        if !booking.user.stripe_id.blank?
        customer = Stripe::Customer.retrieve(booking.user.stripe_id)
        # charge = Stripe::PaymentIntent.create({
        #     payment_method_types: ['card'],
        #     amount: booking.cost,
        #     currency: 'jpy',
            
        #     application_fee_amount: booking.cost*0.1,
        #     :description => service.name,
        #     transfer_data: {
        #         destination: "{{#{service.user.merchant_id}}}",
        #     },
        #     })
            charge = Stripe::Charge.create(
                :customer => customer.id,
                :amount => booking.cost,
                :description => service.name,
                :currency => "jpy",
                application_fee_amount: (booking.cost * 0.2).round,
                :destination => {
                #   :amount => (booking.cost * 0.8).round, # 80% of the total amount goes to the Host
                  :account => service.user.merchant_id # Host's Stripe customer ID
                })
            logger.debug"#{charge}"
        if charge
            ReservationMailer.send_email_to_customer(booking.user, booking.service).deliver_later
            booking.status = "confirmed"
            flash[:notice] = "Reservation created successfully!"
        else
            booking.status = "cancel"
            flash[:alert] = "cannot charge with this payment method"
        end
    end
    rescue Stripe::CardError => e
        booking.status = "cancel"
        flash[:alert] = e.message
    end
    def set_booking
        @booking = @booking = Booking.find(params[:id])
    end

    def booking_params    # specify strong parameters
        params.require(:booking).permit(:date, :cost, :status)
    end
end
