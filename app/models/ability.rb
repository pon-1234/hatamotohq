# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Broadcast
    can [:manage], Broadcast, line_account: user.line_account
    can [:create], Broadcast

    # Scenario
    can [:manage], Scenario, line_account: user.line_account
    can [:create], Scenario

    # Auto Response
    can [:manage], AutoResponse, line_account: user.line_account
    can [:create], AutoResponse

    # Channel
    can [:read, :create, :update], Channel, line_account: user.line_account
    can :create_message, Channel, { line_account: user.line_account, locked: false }

    # RichMenu
    can [:manage], RichMenu, line_account: user.line_account
    can [:create], RichMenu

    # Media
    can [:manage], Media, line_account: user.line_account
    can [:create], Media

    # Friend
    can [:manage], LineFriend, line_account: user.line_account

    # Folder
    can [:manage], Folder, line_account: user.line_account
    can [:create], Folder

    # Tag
    can [:manage], Tag, folder: { line_account: user.line_account }
    can [:create], Tag
  end
end
