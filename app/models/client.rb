class Client < ApplicationRecord
  has_many :projects


   def soft_delete
    update_attribute(:is_active, false)
  end
end
