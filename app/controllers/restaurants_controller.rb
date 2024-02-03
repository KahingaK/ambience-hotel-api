class RestaurantsController < ApplicationController
  before_action :authorize_request
  before_action :set_restaurant, only: %i[ show update destroy ]
  skip_before_action :authorize_request, only: [:index] 


  # GET /restaurants
  def index
    latest_menu = Restaurant.last
    render json: latest_menu
  end


  # POST /restaurants
  def create
    current_user = @current_user
    if current_user.role == "admin"

        restaurant = Restaurant.new(restaurant_params)

        restaurant.image.attach(restaurant_params[:image]) unless restaurant_params[:image].nil?
        if restaurant.save
            render json:  {message: 'Menu updated'}, status: :ok
        else
            render json: restaurant.errors.full_messages, status: :unprocessable_entity
        end
    else
        render json: { error: 'Unauthorized'}, status: :unauthorized
    end
end

  # PATCH/PUT /restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:menu, :image)
    end
end
