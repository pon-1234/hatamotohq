class CreateLineSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :line_settings do |t|
      t.references :line_account, foreign_key: true
      t.string :client_id
      t.string :channel_access_token
      t.string :channel_secret
      t.string :invite_url
      t.string :webhook_url
      t.string :liff_id
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
