class DashboardsController < ApplicationController

    before_action :authenticate_user!

    def index
        @user = current_user
        @your_services = policy_scope(Service).where(user: current_user)
    end
end