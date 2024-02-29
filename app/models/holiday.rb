class Holiday < ApplicationRecord
  validates :holiday_date, presence: true
  # validate :date_cannot_be_in_the_past , presence: true
  belongs_to :company

  private

  def date_cannot_be_in_the_past
    if holiday_date.present? && holiday_date < Date.today
      errors.add(:holiday_date, "can't be in the past")
    end
  end
end
