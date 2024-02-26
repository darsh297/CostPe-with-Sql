class AddCheckInCheckOutToCheckIns < ActiveRecord::Migration[7.1]
  def change
   create_table :check_ins do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :check_in_time
      t.datetime :check_out_time
      t.timestamps
   end
  end
end
