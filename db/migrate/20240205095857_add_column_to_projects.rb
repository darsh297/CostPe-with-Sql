class AddColumnToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :is_active, :boolean, default: true
    add_column :projects, :company_id, :integer
    add_reference :projects, :client, null: true, foreign_key: true

  end
end
