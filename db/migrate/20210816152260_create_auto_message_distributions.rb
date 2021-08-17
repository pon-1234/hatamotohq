class CreateAutoMessageDistributions < ActiveRecord::Migration[6.0]
  def change
    # TODO: Rename this table
    create_table :auto_message_distributions do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :title
      t.string :status
      t.string :keyword
      t.string :keyword_status
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
