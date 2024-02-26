class CreateHolidays < ActiveRecord::Migration[7.1]
  def change
    create_table :holidays do |t|
      t.string :name
      t.date :holiday_date
      t.integer :created_by
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
