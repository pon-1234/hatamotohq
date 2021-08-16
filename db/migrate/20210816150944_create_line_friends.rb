class CreateLineFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :line_friends do |t|
      t.references :line_account, foreign_key: true
      t.references :line_customer, foreign_key: true
      t.date :birthday
      t.string :area
      t.string :gender
      t.string :prefecture
      t.string :status
      t.string :status_from_bot, default: 'active'
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
