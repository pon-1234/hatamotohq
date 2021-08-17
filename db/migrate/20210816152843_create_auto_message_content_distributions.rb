class CreateAutoMessageContentDistributions < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_message_content_distributions do |t|
      t.references :auto_message, foreign_key: true
      t.text :content
      t.string :message_type
      t.timestamps
    end
  end
end
