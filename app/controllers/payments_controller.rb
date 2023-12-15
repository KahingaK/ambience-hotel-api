class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show update destroy ]
 

  # GET /payments
  def index
    @payments = Payment.all

    render json: @payments
  end

  # GET /payments/1
  def show
    render json: @payment
  end



  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  def stkpush
    phone_number = params[:phone_number]
    amount = params[:amount]
    user_id =params[:user_id]
    booking_id = params[:booking_id]
    validated_phone_number = valid_mpesa_number?(phone_number)
    unless validated_phone_number
      render json: { error: 'Invalid phone number format' }, status: :unprocessable_entity
      return
    end

    url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
    timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
    'BusinessShortCode': business_short_code,
    'Password': password,
    'Timestamp': timestamp,
    'TransactionType': "CustomerPayBillOnline",
    'Amount': amount,
    'PartyA': validated_phone_number,
    'PartyB': business_short_code,
    'PhoneNumber':  validated_phone_number,
    'CallBackURL': "#{ENV["CALLBACK_URL"]}/mpesa_callback",
    'AccountReference': 'Codearn',
    'TransactionDesc': "Payment for Codearn premium"
    }.to_json

    headers = {
    Content_type: 'application/json',
    Authorization: "Bearer #{get_access_token}"
    }

    response = RestClient::Request.new({
    method: :post,
    url: url,
    payload: payload,
    headers: headers
    }).execute do |response, request|
    case response.code
    when 500
    [ :error, JSON.parse(response.to_str) ]
    when 400
    [ :error, JSON.parse(response.to_str) ]
    when 200
    response_data = JSON.parse(response.to_str)
    checkout_request_id = response_data['CheckoutRequestID'] # Use square brackets for hash notation
    puts checkout_request_id
    
    payment = Payment.find_by(booking_id: booking_id)
    if payment
      # Modify the TransactionCode attribute
      payment.update(checkout: checkout_request_id)

      [ :success, JSON.parse(response.to_str) ]
    else
      payment = Payment.create(phone_number:  validated_phone_number, amount: amount, user_id: user_id, booking_id: booking_id, checkout: checkout_request_id )

      [ :success, JSON.parse(response.to_str) ]
    end
    
    
    else
    fail "Invalid response #{response.to_str} received."
    end
    end
    render json: response
end

def stkquery
  url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
  timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
  business_short_code = ENV["MPESA_SHORTCODE"]
  password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
  payload = {
  'BusinessShortCode': business_short_code,
  'Password': password,
  'Timestamp': timestamp,
  'CheckoutRequestID': params[:checkoutRequestID]
  }.to_json

  headers = {
  Content_type: 'application/json',
  Authorization: "Bearer #{ get_access_token }"
  }

  response = RestClient::Request.new({
  method: :post,
  url: url,
  payload: payload,
  headers: headers
  }).execute do |response, request|
  case response.code
  when 500
  [ :error, JSON.parse(response.to_str) ]
  when 400
  [ :error, JSON.parse(response.to_str) ]
  when 200
  [ :success, JSON.parse(response.to_str) ]
  else
  fail "Invalid response #{response.to_str} received."
  end
  end
  render json: response
end

def callback
  # Handle the callback response here
  # This is where you can access the details sent back by M-PESA
  if params[:Body] && params[:Body][:stkCallback]
    callback_data = params[:Body][:stkCallback]
    # Access the relevant information from callback_data
    checkout_request_id = callback_data[:CheckoutRequestID]
    result_code = callback_data[:ResultCode]
    result_desc = callback_data[:ResultDesc]

    callback_metadata = callback_data[:Body][:stkCallback][:CallbackMetadata]
     items = callback_metadata[:Item]
     mpesa_receipt_number_item = items.find { |item| item[:Name] == "MpesaReceiptNumber" }
     mpesa_receipt_number_value = mpesa_receipt_number_item[:Value]

    
    if result_code.to_i.zero?
      # Payment was successful
      payment = Payment.find_by(checkout: checkout_request_id)
      if payment
        # Modify the TransactionCode attribute
        payment.update(transaction_code: mpesa_receipt_number_value)

        render json: { message: 'Payment successful', result_desc: result_desc, payment: payment }, status: :ok
      else
        render json: { error: 'Payment not found' }, status: :not_found
      end
      render json: {message: 'Payment successful', result_desc: result_desc }, status: :ok
    else
      # Payment was canceled or failed
      render json: { message: 'Payment canceled or failed', result_desc: result_desc  }, status: :unprocessable_entity
    end
  else
    render json: { error: 'Invalid callback data' }
  end
end
  

  private
   
  def handle_success_response(result_code)

  end

    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.permit(:phone_number, :amount, :user_id, :booking_id)
    end

     # POST /payments
     def create
      @payment = Payment.new(payment_params)
  
      
    end
    
    #mpesa methods
    def valid_mpesa_number?(number)
      # Remove leading plus sign if present
      number = number.gsub(/\A\+/, '')
    
      # If the number starts with "0", drop it
      number = "254#{number[1..-1]}" if number.start_with?('0')
    
      # Check if the number is in the format "254" followed by exactly 9 digits
      valid_format = (number.length == 12) && (number.start_with?('254'))
    
      valid_format ? number : nil
    end
  


    def generate_access_token_request
      url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
      consumer_key = ENV['MPESA_CONSUMER_KEY']
      consumer_secret = ENV['MPESA_CONSUMER_SECRET']
      userpass = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")
      
      headers = {
        Authorization: "Basic #{userpass}"
      }
    
      begin
        response = RestClient::Request.execute(
          url: url,
          method: :get,
          headers: headers
        )
    
        # Return the response or handle it as needed
        return response
      rescue RestClient::ExceptionWithResponse => e
        # Handle any RestClient exceptions here
        puts "Error: #{e.response}"
        return nil
      end
    end


    def get_access_token
        res = generate_access_token_request()
        if res.code != 200
        r = generate_access_token_request()
        if r.code != 200
        raise MpesaError('Unable to generate access token')
        end
        res = r
        end
        body = JSON.parse(res, { symbolize_names: true })
        token = body[:access_token]
        AccessToken.destroy_all()
        AccessToken.create!(token: token)
        token
    end
end
