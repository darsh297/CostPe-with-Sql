class AddEmailsToWorkreports < ActiveRecord::Migration[7.1]
  def change
     add_column :workreports, :is_active, :boolean , default: true
  end
end
