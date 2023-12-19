class PostMailer < ApplicationMailer
    default from: 'WesternAmbience.com'
        
    def new_post_notification(params)
        @user_id =  params[:user_id]
        @user = User.find_by(id: @user_id)    
        @title =  params[:title]
        @body =  params[:body]

     
        @recipients = User.all
        @recipients.each do |username|
            # Send mail to each admin user
            @username = username
    
        mail(to: @username.email, subject: @title)
      end
end
