class CreateRemindings < ActiveRecord::Migration[6.0]
  def change
    create_table :remindings do |t|
      t.references :channel, foreign_key: true
      t.references :reminder, foreign_key: true
      t.datetime :goal
      t.timestamps
    end
  end
end
