class ReviewsController < ApplicationController
    # def index
    #     @reviews = Review.all
    # end

    # def show
    #     @review = Review.find(params[:id])
    # end

    def new
        @service = Service.find(params[:service_id])
        @review = Review.new
        authorize @review
    end

    def create
        @review = Review.new(review_params)
        authorize @review
        @review.service_id = params[:service_id]
        @review.user = current_user
        @service = Service.find(params[:service_id])
        if @service.review_ids.empty?
            @service.rating = @review.stars
            @service.save
        else
            number_of_reviews = @service.review_ids.length
            @service.rating = ((@service.rating*number_of_reviews) + @review.stars)/(number_of_reviews+1)
            @service.save
        end
        if @review.save
            redirect_to service_path(@review.service)
        else
            render :new
        end
    end

    # def edit
    #     @review = Review.find(params[:id])    # gives existing Instance to the form
    # end

    # def update
    #     @review = Review.find(params[:id])
    #     @review.update(review_params)
    #     if @review.update(review_params)
    #         redirect_to review_path(@review)
    #     else
    #         render :edit
    #     end
    # end

    # def destroy
    #     @review = Review.find(params[:id])
    #     @review.destroy
    #     redirect_to reviews_path
    # end

   
 private

    def set_review
        @review = Review.find(params[:id])
    end

    def review_params    # specify strong parameters
        params.require(:review).permit(:stars, :description)
    end
end
