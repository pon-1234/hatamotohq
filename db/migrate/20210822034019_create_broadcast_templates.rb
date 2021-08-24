# frozen_string_literal: true

class CreateBroadcastTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcast_templates do |t|
      t.references :line_account, foreign_key: true
      t.timestamps
    end
  end
end
