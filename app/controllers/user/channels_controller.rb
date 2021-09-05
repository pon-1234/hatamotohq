# frozen_string_literal: true

class User::ChannelsController < User::ApplicationController
  def index
    @channels = Channel.all.page(params[:page])
    respond_to do |format|
      format.html
      format.json
    end
  end
end
