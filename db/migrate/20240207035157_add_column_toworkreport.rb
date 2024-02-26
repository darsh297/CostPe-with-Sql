class AddColumnToworkreport < ActiveRecord::Migration[7.1]
  def change
    add_column :workreports, :created_by, :int
  end
end
