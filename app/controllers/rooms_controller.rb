class RoomsController < ApplicationController
    before_action :authorize_request
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

     # GET /rooms
     def index
        rooms = Room.all
        render json: articles, status: :ok
    end

    # GET /rooms/:id
    def show
        room = find_room
        render json: room, status: :ok
    end

    # POST /rooms (If logged in)
    def create
        current_user = @current_user
        if current_user && current_user.role == "admin"
            room = current_user.rooms.new(room_params)
            if room.save
                render json: room, status: :ok
            else
                render json: room.errors.full_messages, status: :unprocessable_entity
            end
        else
            render json: { error: 'You need to be logged in'}, status: :unauthorized
        end
    end

     # PATCH /rooms/:id  (If logged in)
     def update
        room = find_room
        current_user = @current_user
        if current_user && current_user.role == "admin"
            if room.update(room_params)
                render json: room, status: :accepted
            else
                render json: room.errors, status: :unprocessable_entity
            end
        else
            render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
        end
    end


   
# PATCH /rooms/:id/available
def available
    room = Room.find(params[:id])
    current_user = @current_user
  
    if current_user && current_user.role == "admin"
      if params[:available].to_s == "true"
        if room.update(available: true)
          render json: { message: 'Room now available' }
        else
          render json: { error: 'Unable to approve availability' }, status: :unprocessable_entity
        end
      elsif params[:available].to_s == "false"
        if room.update(available: false)  # Corrected from "booking" to "room"
          render json: { message: 'Room unavailable' }
        else
          render json: { error: 'Unable to deny availability' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid approval value' }, status: :unprocessable_entity
      end
    else
      render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
    end
  end
  

    # DELETE /articles/:id (Article owner or admin)
    def destroy
        current_user = @current_user
        room = find_room
        if current_user && current_user.role == "admin"
            room.destroy
            head :no_content
        else
            render json: { error: "You do not have permission to delete this article" }, status: :unauthorized
        end
    end

    private

        def find_room
            Room.find(params[:id])
        end

        def room_params
            params.require(:room).permit(:room_number, :room_type, :description, :price, :capacity)

    
        end

        def render_not_found_response
            render json: { error: "Room not found" }, status: :not_found
        end
        
        def render_unprocessable_entity_response(exception)
            render json: { error: exception.message }, status: :unprocessable_entity
        end

end
