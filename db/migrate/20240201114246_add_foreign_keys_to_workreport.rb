class AddForeignKeysToWorkreport < ActiveRecord::Migration[7.1]
  def change
    add_reference :workreports, :user, null: false, foreign_key: true
    add_reference :workreports, :project, null: false, foreign_key: true
  end
end
