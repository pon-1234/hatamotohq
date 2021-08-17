class CreateActionObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :action_objects do |t|
      t.string :title
      t.text :description
      t.json :format
      t.string :type
      t.timestamps
    end
  end
end
