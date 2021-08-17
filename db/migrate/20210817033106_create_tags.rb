class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :type, default: 'original'
      t.string :name
      t.string :description
      t.string :slug
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
