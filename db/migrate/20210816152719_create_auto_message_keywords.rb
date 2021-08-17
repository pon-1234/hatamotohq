class CreateAutoMessageKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_message_keywords do |t|
      t.references :line_account, foreign_key: true
      t.references :auto_message_id, foreign_key: true
      t.string :keyword
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
