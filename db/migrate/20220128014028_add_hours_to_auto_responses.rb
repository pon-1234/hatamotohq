# frozen_string_literal: true

class AddHoursToAutoResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :auto_responses, :biz_hours, :json, after: :status
  end
end
