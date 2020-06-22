class ServicesController < ApplicationController
    require 'will_paginate'
    require 'will_paginate/active_record'
    before_action :set_service, only: [:show, :edit, :update, :destroy]
    def index
        @services = Service.all
        @services = policy_scope(Service)
        if params[:query].present?
          @services = policy_scope(Service).joins(:user).global_search(params[:query])
        end

        if params[:tag]
          @filter = params[:tag]["service_type"].reject { |c| c.empty? }
          @filter.push(params[:tag]["country"]).reject(&:blank?)
          @filter.delete("")
          @services = @filter.empty? ? Service.all : Service.tagged_with(@filter, :any => true)
          if params[:tag]["budget_min"].present?
            @services = @services.where("rate >= ? AND rate <= ?", params[:tag]["budget_min"].to_i, params[:tag]["budget_max"].to_i)
          end
        end

        # if user_signed_in?
        #   @user = current_user
        #   @your_services = current_user.services
        #   @services_from_others = @services.where.not(user: current_user).paginate(page: params[:page], per_page: 7)
        # else
          @services = @services.paginate(page: params[:page], per_page: 9)
        # end
    end

    def show
        @service = Service.find(params[:id])

        #get the related attributes
        current_service_type = @service.service_type[0].name
        current_service_country =  @service.country[0].name

        # get the related services
        @filter = [ current_service_type ]
        @filter.push(current_service_country).reject(&:blank?)
        @related_services = Service.tagged_with(@filter, :any => true)
        @related_services = @related_services.where.not(id: params[:id])


        @service_provider = @service.user
        @booking = Booking.new
        # authorize @booking
        authorize @service
        @service_geo = Service.geocoded
        @services_taken = []
        if user_signed_in?
          current_user.bookings.each do |booking|
            @services_taken << booking.service.name
          end
        end
        @marker =
          [{
            lat: @service.latitude,
            lng: @service.longitude,
            infoWindow: render_to_string(partial: "info_window", locals: { service: @service }),
            image_url: helpers.asset_url('marker.png')
          }]
        @review = Review.new
        authorize @review
    end

    def new
        @service = Service.new
        authorize @service # this goes here because it needs to seed the service
        @service_geo = Service.geocoded
    end

    def create
        @service = Service.new(service_params)    # uses strong parameters
        authorize @service 
        @service.user = current_user
        if @service.save
            redirect_to service_path(@service)    # redirect to page displaying the model
        else
            render :new
        end
    end

    def edit
        authorize @service 
    end

    def update
        authorize @service 
        if @service.update(service_params)
            redirect_to service_path(@service)
        else
            render :edit
        end
    end

    def destroy
        authorize @service 
        @service.destroy
        redirect_to services_path
    end

   
 private
    def set_service
        @service = Service.find(params[:id])
    end

    def service_params    # specify strong parameters
        params.require(:service).permit(:name, :description, :location, :rate, :photo,  :service_type_list, :country_list )
    end

end
