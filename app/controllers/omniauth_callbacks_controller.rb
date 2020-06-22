class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def stripe_connect
        auth_data = request.env["omniauth.auth"]
        @user = current_user
    
        if @user.persisted?
          @user.merchant_id = auth_data.uid
          @user.save
    
          if !@user.merchant_id.blank?
    
            # Update Payout Schedule
            account = Stripe::Account.retrieve(current_user.merchant_id)
            # account.payout_schedule.delay_days = 7
            # account.payout_schedule.interval = "daily"
    
            # account.payout_schedule.monthly_anchor = 15
            # account.payout_schedule.interval = "monthly"
    
            account.save
          
    
            logger.debug "#{account}"
          end
          
          sign_in_and_redirect @user, event: :authentication
          flash[:notice] = "Stripe Account Created and Connected" if is_navigational_format?
    
        else
          session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
          redirect_to dashboard_path
        end
      end
      def failure
        redirect_to root_path
      end
end