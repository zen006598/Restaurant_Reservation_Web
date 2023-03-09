# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.owner?
      can :manage, Restaurant
      can :manage, User
    elsif user.manager?
      can :show, Restaurant
    else
      can :show, Restaurant
    end
  end
end
