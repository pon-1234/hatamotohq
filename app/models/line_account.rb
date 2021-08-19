# frozen_string_literal: true

# == Schema Information
#
# Table name: line_accounts
#
#  id                        :bigint           not null, primary key
#  deleted_at                :datetime
#  display_name              :string(255)
#  invite_url                :string(255)
#  line_channel_access_token :string(255)
#  line_channel_secret       :string(255)
#  line_name                 :string(255)
#  line_picture_url          :string(255)
#  note                      :text(65535)
#  status                    :string(255)      default("inactive")
#  webhook_url               :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  liff_id                   :string(255)
#  line_channel_id           :string(255)
#  line_user_id              :string(255)
#  owner_id                  :bigint
#
# Indexes
#
#  index_line_accounts_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
require 'securerandom'
class LineAccount < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  before_create do
    self.webhook_url = generate_webhook_url
  end

  private
    def generate_webhook_url
      loop do
        uid = SecureRandom.alphanumeric(10)
        break uid unless LineAccount.where(webhook_url: uid).first
      end
    end
end
