class UserMailer < ApplicationMailer
    default from: 'WesternAmbience.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://WesternAmbienceBliss.com/login'
    mail(to: @user.email, subject: 'Welcome to Our Awesome Site')
  end

  def welcome_booking_email
    @user = params[:user]
    @url  = 'http://WesternAmbienceBliss.com/login'
    mail(to: @user.email, subject: 'Welcome to Our Awesome Site')
  end

  def password_reset_email
    @password_reset = params[:password_reset]
    @user = @password_reset.user
    @reset_token = @password_reset.reset_token
    @reset_url = edit_password_reset_url(reset_token: @reset_token)
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end


  def booking_received
    @user = params[:user]
    @mail = "westernambiencehotel@gmail.com"
    @booking =  params[:booking]
    mail(to: @user.email, subject: 'Booking received!')
  end

  def admin_notification    
    filtered_users = User.select {|user| user.role == "admin"}
    @booking = params[:booking]
    admin_emails = filtered_users.map { |user| user.email }
    filtered_users.each do |user|
      # Send mail to each admin user
      @user = user
      mail(to: @user.email, bcc: admin_emails, subject: 'New Booking')
    end


  end

  
  def send_personalized_email(params)
    @user_email =  params[:email]
    @user = User.find_by(email: @user_email)    
    @title =  params[:title]
    @message =  params[:message]
    mail(to: @user.email, subject: @title)
  end


end
