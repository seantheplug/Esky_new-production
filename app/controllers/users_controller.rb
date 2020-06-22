class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:show]

    def show
        @user = User.find(params[:id])
        @reviews = @user.reviews
        @services = @user.services
        authorize @user
        authorize @reviews
        authorize @services
      end
    
      def edit
        @user = current_user
        authorize @user
      end
    
      def update
        @user = current_user
        authorize @user
        if @user.update(set_user_params)
          redirect_to user_path(@user)
        else
          render :edit
        end
      end
    
      def payment
        @user = current_user
        authorize @user
      end
    
      def payout
        @user = current_user
        authorize @user
        if !@user.merchant_id.blank?
          account = Stripe::Account.retrieve(current_user.merchant_id)
          @login_link = account.login_links.create()
        end
      end
    
      def add_card
        @user = current_user
        authorize @user
        if current_user.stripe_id.blank?
          customer = Stripe::Customer.create(
            email: current_user.email
          )
          current_user.stripe_id = customer.id
          current_user.save
        else
          customer = Stripe::Customer.retrieve(current_user.stripe_id)
        end
        # Add Credit Card to Stripe
        month, year = params[:expiry].split(/\/ /)
        new_token = Stripe::Token.create(:card => {
          :number => params[:number],
          :exp_month => month.to_i,
          :exp_year => year,
          :cvc => params[:cvv]
        })
        customer.sources.create(source: new_token.id)
    
        flash[:notice] = "Your card is saved."
        redirect_to payment_method_path
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to payment_method_path
      end


      private
        
      def set_user_params
        params.require(:user).permit(:avatar)
      end
end
