class CreateBroadcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcasts do |t|
      t.references :line_account, foreign_key: true
      t.json :conditions
      t.string :title
      t.string :date_start
      t.boolean :deliver_now, default: 1
      t.string :status
      t.string :type
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
