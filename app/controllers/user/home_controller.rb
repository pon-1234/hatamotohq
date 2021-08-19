class User::HomeController < User::ApplicationController
  def index
    @notices = []
  end
end
