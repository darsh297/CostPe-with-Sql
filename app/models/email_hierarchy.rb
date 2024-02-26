class EmailHierarchy < ApplicationRecord
  belongs_to :user

  validate :unique_user

  private

  def unique_user
    # Check if there is another EmailHierarchy record associated with the same user
    if EmailHierarchy.exists?(user_id: user_id)
      errors.add(:user_id, "has already been taken")
    end
  end
end
