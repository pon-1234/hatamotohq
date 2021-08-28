class AddPubsubTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pubsub_token, :string, after: :authentication_token, index: true
  end
end
