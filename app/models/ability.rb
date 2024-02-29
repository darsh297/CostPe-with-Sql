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
      can :allworkreports, Workreport, user_id: EmailHierarchy.where("to_ids LIKE ? OR cc_ids LIKE ?", "%#{user.id}%", "%#{user.id}%").pluck(:user_id).uniq
      cannot  [:update , :create , :destroy ,:read ]  , Client
      cannot  [:update , :create , :destroy ,:read ] ,Project
      cannot [:update , :create , :destroy ] , Holiday

    elsif user.role.role_name == "Project Leader"
      # can :show , Holiday
      cannot [:create, :update , :show ], Client
      # cannot :create, :update , :show , Project
      can [:read ] , Holiday
      can [:create , :read ,:update] , Workreport
      cannot [:update , :create , :destroy ] , Holiday
      can :allworkreports, Workreport, user_id: EmailHierarchy.where("to_ids LIKE ? OR cc_ids LIKE ?", "%#{user.id}%", "%#{user.id}%").pluck(:user_id).uniq
      # can :show, User, id: user.id
      # can [:create ,  :read, :update, :destroy], Workreport
      # can :update, User, id: user.id
      # can :manage, :all
     can [:update ,:read], User, id: user.id

    elsif user.role.role_name == "Employee"
      can :show , Holiday
      cannot :create, :update , :show , Client
      cannot :create, :update , :show , Project
      can [:read ] , Holiday
      cannot [:update , :create , :destroy ] , Holiday
      can :show, User, id: user.id
      can [:create, :edit, :show, :update, :destroy], Workreport, id: user.id
      can [:read], Workreport
      can [:edit] , Workreport
      can [:update] , Workreport
      can [:update], User, id: user.id

  end
end
end
