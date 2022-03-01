# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @friend_line_id = params[:friend_line_id]
  end

  def create
    ReservationContactJob.perform_later contact_params, params[:contact][:friend_line_id]
    redirect_to contact_result_path
  end

  def result; end

  private
    def contact_params
      hashed_params = params.require(:contact).permit(:name, :phone_number).to_h
      # rename phone_number key to phoneNumberPrimary
      hashed_params[:phoneNumberPrimary] = hashed_params.delete :phone_number
      hashed_params
    end
end
