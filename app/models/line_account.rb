# frozen_string_literal: true

# == Schema Information
#
# Table name: line_accounts
#
#  id              :bigint           not null, primary key
#  client_id       :bigint
#  line_user_id    :string(255)
#  line_name       :string(255)
#  display_name    :string(255)
#  channel_id      :string(255)
#  channel_secret  :string(255)
#  invite_url      :string(255)
#  webhook_url     :string(255)
#  liff_id         :string(255)
#  pms_api_key     :string(255)
#  note            :text(65535)
#  bot_initialized :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_line_accounts_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'securerandom'
class LineAccount < ApplicationRecord
  belongs_to :client
  has_many :channels
  has_many :line_friends, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :rich_menus, dependent: :destroy
  has_many :medias, dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :scenarios, dependent: :destroy

  # TODO: Add status column to line_accounts table if needed
  # enum status: { active: 'active', inactive: 'inactive', disabled: 'disabled' }

  before_create do
    self.webhook_url = generate_webhook_url if self.webhook_url.nil?
  end

  after_create do
    create_default_folder
  end

  def latest_messages
    Message.joins(:channel).references(:channel).where(channels: { line_account_id: self.id }).from_friend.limit(8)
  end

  def get_messages_quota
    return if self.channel_id.nil?
    insight = Insight.find_or_initialize_by(line_account: self, type: :monthly, date: Time.zone.today.beginning_of_month)
    quota = LineApi::GetQuota.new(self).perform
    insight.quota = quota
    insight.save
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
      Folder.create(name: '未分類', line_account: self, type: :template_message)
      Folder.create(name: '未分類', line_account: self, type: :rich_menu)
      Folder.create(name: '未分類', line_account: self, type: :scenario)
      Folder.create(name: '未分類', line_account: self, type: :reminder)
      Folder.create(name: '未分類', line_account: self, type: :survey)
      Folder.create(name: '未分類', line_account: self, type: :variable)
      Folder.create(name: '未分類', line_account: self, type: :flex_message)
      Folder.create(name: '未分類', line_account: self, type: :site)
      Folder.create(name: '未分類', line_account: self, type: :stream_route)
    end
end
