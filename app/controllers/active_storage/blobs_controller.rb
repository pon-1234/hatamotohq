# frozen_string_literal: true

class ActiveStorage::BlobsController < ActiveStorage::BaseController
  include ActiveStorage::SetBlob

  def show
    expires_in 1.year, public: true
    redirect_to @blob.service_url(disposition: params[:disposition])
  end
end
