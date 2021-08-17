class CreateScenarios < ActiveRecord::Migration[6.0]
  def change
    create_table :scenarios do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :type, default: 'normal'
      t.string :title
      t.string :content
      t.string :status, default: 'disable'
      t.string :delivery_timing_type, default: 'now'
      t.string :time_base_type, default: 'none'
      t.longtext :action
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
