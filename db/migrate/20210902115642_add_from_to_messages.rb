class AddFromToMessages < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :attr
    add_column :messages, :from, :string, length: 32
  end
end
