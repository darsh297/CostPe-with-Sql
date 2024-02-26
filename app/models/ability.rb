# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role.role_name == "Root"
      can :manage, :all
    elsif user.role.role_name == "Company Admin"
      can :manage, :all
      cannot :create, User, role_id: [1, 2]
      cannot :create, Workreport, user: { company_id: !user.company_id }
    elsif user.role.role_name == "HR"
      can :manage, :all
      cannot :create, User, role_id: [1, 2,3]

      elsif user.role.role_name == "Project Manager"
      can :manage, :all
      cannot :create, User, role_id: [1, 2,3,4]

    elsif user.role.role_name == "Project Leader" || user.role.role_name == "Employee"
      # can :manage , Workreport
      can :show , Holiday
      cannot :update , Holiday
      can :show, User, id: user.id
      can :create, Workreport, user_id: user.id
      can :update, User, id: user.id
  end
end
end
