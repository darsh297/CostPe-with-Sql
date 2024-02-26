class Project < ApplicationRecord
  has_many :workreports
  has_many :users
  belongs_to :client


  def soft_delete
    update_attribute(:is_active, false)
  end

end
