# frozen_string_literal: true

class AddHoursToAutoResponses < ActiveRecord::Migration[6.0]
  def up
    add_column :auto_responses, :biz_hours, :json, after: :status
    AutoResponse.find_in_batches do |auto_responses|
      auto_responses.each do |auto_response|
        auto_response.biz_hours = {
          enabled: false,
          weekdays: [],
          is_all_day: false,
          time: {
            start: '00:00',
            end: '23:59'
          }
        }
        auto_response.save!
      end
    end
  end

  def down
    remove_column :auto_responses, :biz_hours
  end
end
