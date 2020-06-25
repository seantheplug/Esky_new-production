class SavelistsController < ApplicationController
    # def index
    #     @reviews = Review.all
    # end
    def show
        @services_in_savelist = current_user.savelist.services
        authorize @services_in_savelist
    end
end