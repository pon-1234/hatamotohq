class CreateMessageContentDistributions < ActiveRecord::Migration[6.0]
  def change
    create_table :message_content_distributions do |t|
      t.references :message_distribution, foreign_key: true
      t.longtext :content
      t.string :message_type
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
