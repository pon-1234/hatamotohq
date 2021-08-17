class CreateFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :folders do |t|
      t.references :line_account, foreign_key: true
      t.string :name
      t.string :type
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
