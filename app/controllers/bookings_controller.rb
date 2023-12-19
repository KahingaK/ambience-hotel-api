class BookingsController < ApplicationController
    before_action :authorize_request
    # Handle ActiveRecord Not Found exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    # Handle ActiveRecord Unprocessable Entity - raised when a record fails to save or validate in the database.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  # GET /bookings
    def index
        bookings = Booking.all.order(id: :desc)
        render json: bookings.to_json(include: [:user, :payment]), status: :ok
    end
    #GET /activebookings
    def active_bookings
      start_of_week = Date.today.beginning_of_week
      end_of_week = Date.today.end_of_week
      today = Date.today
      active_bookings = Booking.where('end_date > ? AND start_date >= ? AND start_date <= ?', today, start_of_week, end_of_week) 
      render json: active_bookings.to_json(include:  [:user, :payment]), status: :ok
    end

# POST /bookings (If logged in)
    # POST /bookings (If logged in)
def create
  current_user = @current_user
  if current_user 
    if current_user && current_user.role == "guest"
    # Find the room based on room_type
      room = Room.find_by(room_type: params[:room_type], available: true)

                if room
                  # Create a booking with the found room_id
                  booking = current_user.bookings.new(booking_params.merge(room_id: room.id))

                            if booking.save
                              room.update(available: false)
                              UserMailer.with(user: current_user, booking: booking).booking_received.deliver_later
                              UserMailer.with(booking: booking).admin_notification.deliver_later        
                              
                              render json: booking, status: :ok
                            else
                              render json: booking.errors.full_messages, status: :unprocessable_entity
                            end
                else
                  render json: { error: 'Room not found for the given room_type' }, status: :not_found
                end
    else
      booking = Booking.new(booking_params)
            if booking.save
              UserMailer.with(booking: booking).admin_notification.deliver_later   
              render json: {message: "Booking Created" ,booking: booking}, status: :ok
            else
                render json: booking.errors.full_messages, status: :unprocessable_entity
            end
    end
  else
    render json: { error: 'You need to be logged in to book' }, status: :unauthorized
  end
end

# POST /user/message

def personal_mail  
  user_email = params[:email]
  title = params[:title]
  message = params[:message]
  UserMailer.send_personalized_email(email: user_email, title: title, message: message).deliver_later
  render json: { title: title, message: message }
end


 # PUT /bookings/:id  (If logged in)
    def update
        booking = find_booking
        current_user = @current_user
        if current_user && current_user.role == "admin"
            if booking.update(booking_params)
                render json: booking, status: :accepted
            else
                render json: booking.errors, status: :unprocessable_entity
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
      if booking.approved == false
        if booking.update(approved: true)
          render json: { message: 'Booking approved' }
        else
          render json: { error: 'Unable to approve booking' }, status: :unprocessable_entity
        end
      elsif booking.approved == true
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
        params.require(:booking).permit(:start_date, :end_date, :room_id,  :user_id, :notes)
    end

    def render_not_found_response
        render json: { error: "Booking not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
    end


end
