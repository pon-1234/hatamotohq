class CreateBroadcastMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcast_messages do |t|
      t.references :broadcast, foreign_key: true
      t.longtext :content
      t.string :message_type
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
