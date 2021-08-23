class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.references :line_account, foreign_key: true
      t.string :alias
      t.string :type
      t.timestamps
    end
  end
end
