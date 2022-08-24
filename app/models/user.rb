# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  client_id              :bigint
#  email                  :string(255)      default(""), not null
#  role                   :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  company_name           :string(255)
#  phone_number           :string(255)
#  address                :string(255)
#  note                   :text(65535)
#  status                 :string(255)      default("active")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  pubsub_token           :string(255)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_client_id             (client_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class User < ApplicationRecord
  belongs_to :client
  has_many :assigned_channels, foreign_key: 'assignee_id', class_name: 'Channel', dependent: :nullify
  has_many :allowlisted_jwts, dependent: :destroy
  alias_attribute :channels, :assigned_channels
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  include UserRole
  include Avatarable

  # Validations
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :phone_number, numericality: true, length: 10..11, allow_nil: true
  validates :address, length: { maximum: 255 }, allow_nil: true
  validates :company_name, length: { maximum: 255 }, allow_nil: true
  validates :note, length: { maximum: 2000 }, allow_nil: true
  validates :email, uniqueness: true

  before_create :execute_before_create

  # Scope
  enum status: { active: 'active', blocked: 'blocked' }

  def push_event_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url,
      type: 'user'
    }
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def execute_before_create
    ensure_authentication_token
    generate_pubsub_token
  end

  def line_account
    self.client.line_account
  end

  def display_name
    name
  end

  def available_access_token?(json_token_indentifier)
    self.allowlisted_jwts.exists? jti: json_token_indentifier
  end

  def active_for_authentication?
    super and self.active? and self.client.active?
  end

  def inactive_message
    "ユーザーはブロック中ですので、ログインできませんでした。"
  end

  # make access_token unavailable after logout
  def revocate_access_token(json_token_indentifier)
    raise Common::AlreadyLogedOut.new unless self.allowlisted_jwts.exists?(jti: json_token_indentifier)
    self.allowlisted_jwts.find_by_jti(json_token_indentifier)&.destroy
  end

  private
    def generate_authentication_token
      loop do
        token = Devise.friendly_token(64)
        break token unless User.where(authentication_token: token).first
      end
    end

    def generate_pubsub_token
      loop do
        self.pubsub_token = SecureRandom.base64(32)
        break unless User.where(pubsub_token: self.pubsub_token).exists?
      end
    end
end
