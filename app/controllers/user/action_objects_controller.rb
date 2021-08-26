# frozen_string_literal: true

class User::ActionObjectsController < User::ApplicationController
  def index
    # TODO: this should be cached in redis
    @action_objects = ActionObject.all
    render 'user/action_objects/index_success.json.jbuilder'
  end
end
