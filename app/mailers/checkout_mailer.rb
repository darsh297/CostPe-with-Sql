class CheckoutMailer < ApplicationMailer
  default from: 'support@costpe.com'

  def checkout_email(user)
    @user = user
    mail(to: @user, cc: 'hr@costpe.com', subject: 'Reminder: Checkout On CostPe')
  end
end
