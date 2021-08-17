class CreateAutoMessageKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_message_keywords do |t|
      t.references :line_account, foreign_key: true
      t.references :auto_message_distribution, foreign_key: true, index: { name: :auto_msg_keyword_auto_msg_distribution_ref_index }
      t.string :keyword
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
