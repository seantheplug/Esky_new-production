class CalendarsController < ApplicationController
    before_action :authenticate_user!

    def index
        @user = current_user
        @your_services = policy_scope(Service).where(user: current_user)
        # policy_scope(Service).where(user: current_user)

        params[:date] ||= Date.current #if the date params is nill assgined the follwing
        params[:service_id] ||= @your_services[0] ? @your_services[0].id : nil 
        
        if params[:q].present?
            params[:date] = params[:q][:date]
            params[:service_id] = params[:q][:service_id]
        end


        if params[:service_id]
            @service = Service.find(params[:service_id])
            date = Date.current

            first_of_month = (date - 1.months).beginning_of_month
            end_of_month = (date - 1.months).end_of_month


            @events = @service.bookings.joins(:user)
                                .select('bookings.*', 'users.*')
                                .where('status <>?', 'cancel')
                                # .where(:date => first_of_month..end_of_month)
            @events.each{ |e| e.image = e.user.avatar.key }
        else
            @service = nil
            @events = []
        end
    end
end