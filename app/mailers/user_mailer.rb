class UserMailer < ApplicationMailer
    default from: 'WesternAmbience.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://WesternAmbienceBliss.com/login'
    mail(to: @user.email, subject: 'Welcome to Our Awesome Site')
  end

  def booking_received
    @user = params[:user]
    @mail = "westernambiencehotel@gmail.com"
    @booking =  params[:booking]
    mail(to: @user.email, subject: 'Booking received!')
  end

  def admin_notification    
    @filtered_users = User.select {|user| user.role == "admin"}
    @booking = params[:booking]

    @filtered_users.each do |user|
      # Send mail to each admin user
      @user = user
      mail(to: @user.email, subject: 'New Booking')
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
