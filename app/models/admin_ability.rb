# frozen_string_literal: true

class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    can :manage, Announcement
    can :manage, User

    return unless admin.superadmin?
    can :manage, :all
  end
end
