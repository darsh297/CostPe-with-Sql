class CreateDesignations < ActiveRecord::Migration[7.1]
  def change
    create_table :designations do |t|
      t.string :name

      t.timestamps
    end
  end
end
