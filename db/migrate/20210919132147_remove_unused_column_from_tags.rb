class RemoveUnusedColumnFromTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :tags, :type
    remove_column :tags, :description
    remove_column :tags, :slug
  end
end
