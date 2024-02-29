class Workreport < ApplicationRecord
  has_many :projects
  belongs_to :user

  validates :user_id, presence: true, unless: :user_with_role_six?
  # validate :one_report_per_user, on: :create , presence: true
  validates :date, presence: true


  def active_users
    where(isactive: true)
  end

  def soft_delete
    update_attribute(:is_active, false)
  end


  private

  def user_with_role_six?
    user&.role.role_name == "Employee"
  end

  def one_report_per_user
    if user_id.present? && date.present?
      existing_report = Workreport.find_by(user_id: user_id, date: date)
      errors.add(:base, "A report for this user on this date already exists") if existing_report.present?
    end
  end
end
