class AddColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    

    add_reference :users, :role, null: true, foreign_key: true
    add_reference :users, :company, null: true, foreign_key: true
    add_reference :users, :department, null: true, foreign_key: true
    add_reference :users, :designation, null: true, foreign_key: true




  end
end
