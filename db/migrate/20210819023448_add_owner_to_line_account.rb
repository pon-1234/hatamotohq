class AddOwnerToLineAccount < ActiveRecord::Migration[6.0]
  def change
    add_reference :line_accounts, :owner, foreign_key: { to_table: :users }, after: :id
  end
end
