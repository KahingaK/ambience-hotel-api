class BookingsController < ApplicationController
    before_action :authorize_request
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  # GET /bookings
    def index
        articles = Booking.all
        render json: bookings, status: :ok
    end

# POST /bookings (If logged in)
    # POST /bookings (If logged in)
def create
  current_user = @current_user
  if current_user
    # Find the room based on room_type
    room = Room.find_by(room_type: params[:room_type])

    if room
      # Create a booking with the found room_id
      booking = current_user.bookings.new(booking_params.merge(room_id: room.id))

      if booking.save
        render json: booking, status: :ok
      else
        render json: booking.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { error: 'Room not found for the given room_type' }, status: :not_found
    end
  else
    render json: { error: 'You need to be logged in to book' }, status: :unauthorized
  end
end


 # PATCH /bookings/:id  (If logged in)
    def update
        booking = find_booking
        current_user = @current_user
        if current_user && current_user.role == "admin"
            if booking.update(params.permit[:notes])
                render json: article, status: :accepted
            else
                render json: article.errors, status: :unprocessable_entity
            end
        else
            render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
        end
    end

   # PATCH /bookings/:id/approve
def approve
    booking = Booking.find(params[:id])
    current_user = @current_user
  
    if current_user && current_user.role == "admin"
      if params[:approved].to_s == "true"
        if booking.update(approved: true)
          render json: { message: 'Booking approved' }
        else
          render json: { error: 'Unable to approve booking' }, status: :unprocessable_entity
        end
      elsif params[:approved].to_s == "false"
        if booking.update(approved: false)
          render json: { message: 'Booking denied' }
        else
          render json: { error: 'Unable to deny booking' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid approval value' }, status: :unprocessable_entity
      end
    else
      render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
    end
  end
 

# DELETE /booking/:id (admin)
    def destroy
        current_user = @current_user
        booking = find_booking
        if current_user && current_user.role == "admin"
            booking.destroy
            head :no_content
        else
            render json: { error: "Access denied" }, status: :unauthorized
        end
    end

private

    def find_booking
        Booking.find(params[:id])
    end

    def booking_params
        params.require(:booking).permit(:start_date, :end_date, :user_id, :notes)
    end

    def render_not_found_response
        render json: { error: "Booking not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
    end


end
