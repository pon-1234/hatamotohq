# frozen_string_literal: true

class User::MessagesController < User::ApplicationController
  def index
    # TODO fix me
    @messages = Message.all.page(params[:page])
    render 'user/messages/index_success.json.jbuilder'
  end
end
