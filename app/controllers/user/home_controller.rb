# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  def index
    @notices = []
  end
end
