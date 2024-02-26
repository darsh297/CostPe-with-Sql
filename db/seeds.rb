# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


role_names = ['Root', 'Company Admin', 'HR' , 'Project Manager', 'Project Leader','Employee']
role_names.each do |role_name|
  Role.find_or_create_by!(role_name: role_name)
end

  companies = ['Thinkbiz', 'Vebuin']
  companies.each do |company_name|
    Company.find_or_create_by!(company_name: company_name)
  end

  departments = ['ROR', 'Python','.Net' ,'Bi' , 'Aws','Hr' , 'Accounts' , 'Admin']
  departments.each do |department_name|
    Department.find_or_create_by!(department_name: department_name)
  end

  designations = ['Project Manager', 'Project Leader', 'Team Leader' , 'Senior Developer' , 'Junior Developer' , 'Intern']
  designations.each do |designation_name|
    Designation.find_or_create_by!(name: designation_name)
  end



  user = User.find_or_create_by(email: 'root@gmail.com') do |u|
    u.password = '123456'
    u.role_id = Role.find_by(role_name: 'Root').id
  end





if user.role_id == Role.find_by(role_name: 'Root').id
  user.company_id = nil
  user.department_id = nil
  user.designation_id = nil
end


# Save the user with skipping the company_id validation for Super Admin users
user.save(validate: false)
