class Holiday < ApplicationRecord
  validates :date_cannot_be_in_the_past, presence: true
  belongs_to :company


  private

  def date_cannot_be_in_the_past
    errors.add(:holiday_date, "can't be in the past") if holiday_date.present? && holiday_date < Date.today
  end
end
