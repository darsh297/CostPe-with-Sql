  class CreateEmailHierarchies < ActiveRecord::Migration[7.1]
    def change
      create_table :email_hierarchies do |t|
        t.references :user, null: false, foreign_key: true
        t.string :to_ids
        t.string :cc_ids

        t.timestamps
      end
    end
  end
