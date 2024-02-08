class PasswordResetController < ApplicationController
skip_before_action :authorize_request

   
    def create
        user = User.find_by(email: params[:email])
        if user
          password_reset = PasswordReset.create(user: user, reset_token: generate_reset_token, expires_at: 1.hour.from_now)
          UserMailer.with(password_reset: password_reset).password_reset_email.deliver_later
          render json: { message: 'Password reset instructions sent.' }, status: :ok
        else
          render json: { error: 'User not found.' }, status: :not_found
        end
      end

      def edit
        @reset_token = params[:reset_token]
      end  


    #   def update
    #     user = User.find_by(password_reset_token: params[:reset_token])
    #     if user && user.password_reset_token_valid?
    #       if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
    #         render json: { message: 'Password updated successfully.' }, status: :ok
    #       else
    #         render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    #       end
    #     else
    #       render json: { error: 'Invalid or expired reset token.' }, status: :unprocessable_entity
    #     end
    #   end
    
      private
    
      def generate_reset_token
        SecureRandom.urlsafe_base64
      end

end
