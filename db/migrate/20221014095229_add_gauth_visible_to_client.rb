class AddGauthVisibleToClient < ActiveRecord::Migration[6.0]
  # DOTS_HOME_MAIL_SUFFIX = '@dot-homes.jp'
  DOTS_HOME_MAIL_SUFFIX = '@yopaz.vn'

  def up
    add_column :clients, :gauth_visible, :boolean, default: false, after: :status
    # Migrate existing data
    Client.all.each do |client|
      if client.admin.email.end_with? DOTS_HOME_MAIL_SUFFIX
        client.gauth_visible = true
        client.save
      end
    end
  end

  def down
    remove_column :clients, :gauth_visible
  end
end
