# frozen_string_literal: true

class AddProviderToMediaTable < ActiveRecord::Migration[6.0]
  def change
    add_column :media, :provider, :string, after: :type, default: 'system'
  end
end
