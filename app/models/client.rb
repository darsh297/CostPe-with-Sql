class Client < ApplicationRecord
  has_many :projects
  belongs_to :company

  after_update :update_projects_status, if: :saved_change_to_is_active?

  def update_projects_status
    if !is_active
      projects.update_all(is_active: false)
    end
  end

  def soft_delete
    update_attribute(:is_active, false)
  end
end
