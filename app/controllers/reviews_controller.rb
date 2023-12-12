class ReviewsController < ApplicationController
    before_action :authorize_request
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    skip_before_action :authorize_request, only: [:index] 

    def index
        reviews = Review.order(created_at: :desc).all
        render json: reviews.to_json(include: :user), status: :ok
        
    end

    # POST /reviews (If logged in)
    def create
        current_user = @current_user
        if current_user 

            review = Review.new(params.permit( :content))
            review.user_id = current_user.id 
            if review.save
                render json: {message: "Review Created" ,review: review.to_json(include: :user)}, status: :ok
            else
                render json: review.errors.full_messages, status: :unprocessable_entity
            end
        else
            render json: { error: 'You need to be logged in'}, status: :unauthorized
        end
    end

    def destroy
        review = find_review
        current_user = @current_user
        if current_user && (current_user.role == "admin" || review.user_id == current_user.id)
            review.destroy
            render json: {message: "Deleted"}
            head :no_content
        else
            render json: { error: "You do not have permission to delete this review" }, status: :unauthorized
        end

    end

    private

    def find_review
        Review.find(params[:id])
        
    end
end
