# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id           :bigint           not null, primary key
#  agency_id    :bigint
#  name         :string(255)
#  phone_number :string(255)
#  address      :string(255)
#  status       :string(255)      default("active")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_clients_on_agency_id  (agency_id)
#
# Foreign Keys
#
#  fk_rails_...  (agency_id => agencies.id)
#
class Client < ApplicationRecord
  belongs_to :agency
  has_many :users, dependent: :destroy
  has_one :line_account

  # Validations
  # validates :name, uniqueness: true

  enum status: { active: 'active', blocked: 'blocked' }

  def admin
    @admin ||= self.users.admin.first
  end

  def staffs
    @staffs ||= self.users.staff
  end

  def create_line_account
    line_account = LineAccount.new(client: self)
    line_account.save!
  end
end
