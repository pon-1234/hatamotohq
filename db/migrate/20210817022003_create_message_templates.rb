class CreateMessageTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :message_templates do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :title
      t.longtext :content
      t.string :message_type
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
