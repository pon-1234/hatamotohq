# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Broadcast
    can [:read, :update, :destroy, :delete_confirm, :search], Broadcast, line_account: user.line_account
    can [:create], Broadcast

    # Scenario
    can [:read, :update, :destroy, :delete_confirm, :search, :copy, :copy_confirm, :manual], Scenario, line_account: user.line_account
    can [:create], Scenario

    # Auto Response
    can [:manage], AutoResponse, line_account: user.line_account
    can [:create], AutoResponse

    # Channel
    can [:read], Channel, line_account: user.line_account

    # RichMenu
    can [:manage], RichMenu, line_account: user.line_account
    can [:create], RichMenu

    # Media
    can [:manage], Media, line_account: user.line_account
    can [:create], Media

    # Folder
    can [:read, :update, :destroy], Folder, line_account: user.line_account
    can [:create], Folder
    can [:read, :update, :destroy], Tag, folder: { line_account: user.line_account }
    can [:create], Tag
  end
end
