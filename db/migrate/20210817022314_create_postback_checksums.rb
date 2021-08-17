class CreatePostbackChecksums < ActiveRecord::Migration[6.0]
  def change
    create_table :postback_checksums do |t|
      t.string :hash
      t.string :data
      t.timestamps
    end
  end
end
