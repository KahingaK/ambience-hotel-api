class ApplicationController < ActionController::API
  before_action :authorize_request

  # /login method to provide authentication using JWT
  def authorize_request
    header = request.headers['Authorization']
    token = extract_token(header)

    if token
      decoded = decode_token(token)
      set_current_user(decoded)
    else
      # Handle case where there's no token or decoding fails
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def extract_token(header)
    header&.split(' ')&.last
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    nil
  end
  def set_current_user(decoded)
    if decoded.present? && decoded.is_a?(Array) && decoded[0].present? && decoded[0]['user_id'].present?
      @current_user_id = decoded[0]['user_id']
      @current_user = User.find(@current_user_id)
    else
      render json: { error: 'Please login to continue...' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    # Handle case where user is not found
    render json: { error: 'User not found' }, status: :unauthorized
  end
  
end
