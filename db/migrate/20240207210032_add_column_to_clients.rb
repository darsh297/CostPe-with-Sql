class AddColumnToClients < ActiveRecord::Migration[7.1]
  def change
    add_reference :clients, :user, null: true, foreign_key: true
    add_column :clients, :company_id, :integer

  end
end
