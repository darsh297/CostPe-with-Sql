class CheckoutMailer < ApplicationMailer
   default from: 'support@costpe.com'
     def checkout_email(user)
      @user = user
      mail(to: @user, subject: 'Reminder: Submit Your Work Report')
  end
end
