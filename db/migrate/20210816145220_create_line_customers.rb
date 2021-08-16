class CreateLineCustomers < ActiveRecord::Migration[6.0]
  def change
    # TODO: Please rename this table to line_ofc_accounts
    create_table :line_customers do |t|
      t.string :line_picture_url
      t.string :line_user_id
      t.string :line_name
      t.string :display_name
      t.text :note
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
