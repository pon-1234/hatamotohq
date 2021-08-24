# frozen_string_literal: true

class User::EmojisController < User::ApplicationController
  def show
    @emojis = Emoji.by_pack(params[:pack_id])
    render 'user/emojis/show.json.jbuilder'
  end
end
