class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :f_name, :string
    add_column :users, :l_name, :string
    add_column :users, :dateofBirth, :date
    add_column :users, :accountnumber, :integer
    add_column :users, :ifsc, :string
    add_column :users, :mobileNumber, :string
    add_column :users, :joiningDate, :date
    add_column :users, :isactive, :boolean, default: true
  end
end
