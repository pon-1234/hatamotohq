# frozen_string_literal: true

require 'mini_magick'

class MediasController < ApplicationController
  before_action :find_media
  # GET /medias/:id/content/:size
  def variant
    size = params[:size] || '1040'
    image = MiniMagick::Image.open(@media.url)
    image.resize size + 'x' + size
    send_file(image.path, filename: "#{size}", type: 'image/jpeg', disposition: 'inline')
  end

  private
    def find_media
      @media = Media.find(params[:id])
    end
end
