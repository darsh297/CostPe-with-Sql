class ReminderMailer < ApplicationMailer
  default from: 'support@costpe.com'
  def reminder_email(user)
    @user = user
    mail(to: @user, subject: 'Reminder: Submit Your Work Report')
  end
end
