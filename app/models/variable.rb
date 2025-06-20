# frozen_string_literal: true

# == Schema Information
#
# Table name: variables
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  folder_id       :bigint
#  name            :string
#  type            :string
#  default         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  friends_count   :integer          default(0)
#
# Indexes
#
#  index_variables_on_folder_id        (folder_id)
#  index_variables_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Variable < ApplicationRecord
  belongs_to :folder
  belongs_to :line_account
  has_many :friend_variables
  include VariableType

  def destroyable?
    self.friend_variables.length == 0
  end

  def clone!
    new_varaible = self.dup
    new_varaible.name = new_varaible.name + '（コビー）'
    new_varaible.save!
    new_varaible
  end

  def default_value(friend)
    return self.default if self.default.blank?
    bind_data(friend)
  end

  def refresh_friends_count
    self.friends_count = self.friend_variables.pluck(:line_friend_id).uniq.count
    self.save
  end

  private
    def bind_data(friend)
      self.default&.gsub(/{name}/, friend.display_name)
    end
end
