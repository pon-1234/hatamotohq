# frozen_string_literal: true

module Current
  thread_mattr_accessor :user

  def user=(user)
    super
  end

  def self.reset
    Current.user = nil
  end
end
