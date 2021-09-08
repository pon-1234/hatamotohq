# frozen_string_literal: true

# == Schema Information
#
# Table name: line_accounts
#
#  id                        :bigint           not null, primary key
#  bot_initialized           :boolean          default(FALSE)
#  deleted_at                :datetime
#  display_name              :string(255)
#  invite_url                :string(255)
#  line_channel_access_token :string(255)
#  line_channel_secret       :string(255)
#  line_name                 :string(255)
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
  has_many :channels
  has_many :line_friends, dependent: :destroy
  has_many :folders, dependent: :destroy

  enum status: { active: 'active', inactive: 'inactive', disabled: 'disabled' }

  before_create do
    self.webhook_url = generate_webhook_url if self.webhook_url.nil?
  end

  after_create do
    create_default_folder
  end

  private
    def generate_webhook_url
      loop do
        uid = SecureRandom.alphanumeric(10)
        break uid unless LineAccount.where(webhook_url: uid).first
      end
    end

    def create_default_folder
      Folder.create(name: '未分類', line_account: self, type: :tag)
      Folder.create(name: '未分類', line_account: self, type: :auto_response)
      Folder.create(name: '未分類', line_account: self, type: :message_template)
      Folder.create(name: '未分類', line_account: self, type: :rich_menu)
      Folder.create(name: '未分類', line_account: self, type: :scenario)
      Folder.create(name: '未分類', line_account: self, type: :scenario_template)
      Folder.create(name: '未分類', line_account: self, type: :survey)
      Folder.create(name: '未分類', line_account: self, type: :survey_profile)
      Folder.create(name: '未分類', line_account: self, type: :flex_message)
    end
end
