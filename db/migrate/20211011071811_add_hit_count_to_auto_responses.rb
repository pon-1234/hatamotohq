# frozen_string_literal: true

class AddHitCountToAutoResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :auto_responses, :hit_count, :integer, default: 0
  end
end
