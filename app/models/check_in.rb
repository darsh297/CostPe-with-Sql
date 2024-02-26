class CheckIn < ApplicationRecord
  belongs_to :user

  validate :one_checkin_and_checkout_per_day, on: :create

  private

  def one_checkin_and_checkout_per_day
    existing_checkin = user.check_ins.where('DATE(check_in_time) = ?', Date.today).exists?
    if existing_checkin
      errors.add(:base, "You have already checked in today")
    end

    existing_checkout = user.check_ins.where('DATE(check_out_time) = ?', Date.today).exists?
    if existing_checkout
      errors.add(:base, "You have already checked out today")
    end
  end
end
