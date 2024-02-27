namespace :checkouts do
   desc 'Send reminders to users who forgot to checkout for today'
    task checkout_reminders: :environment do
       checkout = CheckInsController.users_without_checkout

    checkout.each do |a|
      CheckoutMailer.checkout_email (a).deliver_now
    end

  end
end
