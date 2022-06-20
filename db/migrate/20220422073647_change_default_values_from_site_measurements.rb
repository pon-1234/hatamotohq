# frozen_string_literal: true

class ChangeDefaultValuesFromSiteMeasurements < ActiveRecord::Migration[6.0]
  def change
    change_column_default :site_measurements, :sending_count, from: nil, to: 0
    change_column_default :site_measurements, :click_count, from: nil, to: 0
    change_column_default :site_measurements, :receiver_count, from: nil, to: 0
    change_column_default :site_measurements, :visitor_count, from: nil, to: 0
  end
end
