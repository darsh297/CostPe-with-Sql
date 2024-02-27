namespace :workreports do
  desc 'Send reminders to users who forgot to submit work reports'
  task send_reminders: :environment do
    users = WorkreportsController.users_with_pending_reports


    users.each do |user|

      ReminderMailer.reminder_email(user).deliver_now

    end

    
  end
end
