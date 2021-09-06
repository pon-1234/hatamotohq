# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string(255)
#  authentication_token   :string(255)
#  company_name           :string(255)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  note                   :text(65535)
#  phone_number           :string(255)
#  pubsub_token           :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  status                 :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  before_create :execute_before_create
  after_create :execute_after_create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  include Avatarable

  has_one :line_account, class_name: 'LineAccount', foreign_key: 'owner_id', dependent: :destroy

  # Validations
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :phone_number, numericality: true, length: 10..11, allow_nil: true
  validates :address, length: { maximum: 255 }, allow_nil: true
  validates :company_name, length: { maximum: 255 }, allow_nil: true
  validates :note, length: { maximum: 2000 }, allow_nil: true

  # Scope
  enum status: { actived: 'actived', blocked: 'blocked' }

  def push_event_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url
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

  def execute_after_create
    create_line_account
  end

  def display_name
    name
  end

  private
    def generate_authentication_token
      loop do
        token = Devise.friendly_token(64)
        break token unless User.where(authentication_token: token).first
      end
    end

    def create_line_account
      line_account = LineAccount.new(owner: self)
      line_account.save!
    end

    def generate_pubsub_token
      loop do
        self.pubsub_token = SecureRandom.base64(32)
        break unless User.where(pubsub_token: self.pubsub_token).exists?
      end
    end
end
