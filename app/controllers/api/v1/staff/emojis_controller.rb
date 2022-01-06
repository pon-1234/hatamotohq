# frozen_string_literal: true

class Api::V1::Staff::EmojisController < Api::V1::Staff::ApplicationController
  # GET /api/v1/staff/emojis/:pack_id
  def show
    @emojis = Emoji.by_pack params[:pack_id]
  end
end
