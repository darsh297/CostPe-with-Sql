class AddColumnToworkreports < ActiveRecord::Migration[7.1]
  def change
    add_column :workreports, :minutes, :integer

  end
end
