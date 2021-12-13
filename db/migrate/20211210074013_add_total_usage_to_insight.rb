# frozen_string_literal: true

class AddTotalUsageToInsight < ActiveRecord::Migration[6.0]
  def change
    add_column :insights, :quota, :integer, after: :date, default: 0
    add_column :insights, :total_usage, :integer, after: :quota, default: 0
  end
end
