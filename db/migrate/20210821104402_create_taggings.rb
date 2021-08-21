class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true
      t.references :tag, foreign_key: true
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
