class PostMailer < ApplicationMailer
    default from: 'WesternAmbience.com'
          
    def new_post_notification(params)
      @user_id = params[:user_id]
      @user = User.find_by(id: @user_id)
      @title = params[:title]
      @body = params[:body]

      @image_url = params[:image_url]
  
      recipients = User.all
       recipient_emails = recipients.pluck(:email)
        mail(bcc: recipient_emails, subject: @title)
    end

  end