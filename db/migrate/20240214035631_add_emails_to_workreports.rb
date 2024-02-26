class AddEmailsToWorkreports < ActiveRecord::Migration[7.1]
  def change
     add_column :workreports, :emails, :text
  end
end
