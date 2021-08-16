class CreateLineAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :line_accounts do |t|

      t.timestamps
    end
  end
end
