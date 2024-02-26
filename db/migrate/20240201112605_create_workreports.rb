class CreateWorkreports < ActiveRecord::Migration[7.1]
  def change
    create_table :workreports do |t|
      t.date :date
      t.text :tasks
      t.integer :hours
      t.string :status

      t.timestamps
    end
  end
end
