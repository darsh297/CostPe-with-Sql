namespace :checkouts do
  desc 'Send reminders to users who forgot to checkout for today'
  task checkout_reminders: :environment do
    users_without_checkout = CheckInsController.users_without_checkout

    users_without_checkout.each do |email|
      CheckoutMailer.checkout_email(email).deliver_now
    end
  end
end
