class CreateScenarioMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :scenario_messages do |t|
      t.references :scenario, foreign_key: true
      t.string :status, default: 'disable'
      t.string :name
      t.longtext :content
      t.string :message_type
      t.float :priority, default: 999
      t.string :delivery_timing
      t.string :time_designation, default: '00:00'
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
