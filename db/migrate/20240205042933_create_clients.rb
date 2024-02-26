class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :client_name
      t.boolean :is_active , default: true

      t.timestamps
    end
  end
end
