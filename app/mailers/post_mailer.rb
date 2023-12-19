class PostMailer < ApplicationMailer
    default from: 'WesternAmbience.com'
        
    def new_post_notification(params)
        @user_id =  params[:user_id]
        @user = User.find_by(id: @user_id)    
        @title =  params[:title]
        @body =  params[:body]
     
        @recipients = User.all
        emails = @recipients.collect(&:email).join(",")
    
        mail(to: emails, subject: @title)
      end
end
