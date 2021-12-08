# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id           :bigint           not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  address      :string(255)
#  status       :string(255)      default("active")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Client < ApplicationRecord
  has_many :users, dependent: :destroy
  has_one :line_account

  # Validations
  # validates :name, uniqueness: true

  enum status: { active: 'active', blocked: 'blocked' }

  def admin
    self.users.first
  end

  def create_line_account
    line_account = LineAccount.new(client: self)
    line_account.save!
  end
end
