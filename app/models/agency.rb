# frozen_string_literal: true

# == Schema Information
#
# Table name: agencies
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  address                :string
#  phone_number           :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_agencies_on_email                 (email) UNIQUE
#  index_agencies_on_reset_password_token  (reset_password_token) UNIQUE
#
class Agency < ApplicationRecord
  has_many :clients, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :email, uniqueness: true
end
