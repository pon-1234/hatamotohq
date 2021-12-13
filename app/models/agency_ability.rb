# frozen_string_literal: true

class AgencyAbility
  include CanCan::Ability

  def initialize(admin)
    can :manage, User
  end
end
