class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # if params[:query].present?
    #   @services = policy_scope(Service).joins(:user).global_search(params[:query])
    #   redirect_to services_path(@services) 
    # end
  end
end
