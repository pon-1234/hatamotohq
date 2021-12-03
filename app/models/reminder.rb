# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id              :bigint           not null, primary key
#  folder_id       :bigint
#  line_account_id :bigint
#  name            :string(255)
#  episodes_count  :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_reminders_on_folder_id        (folder_id)
#  index_reminders_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class Reminder < ApplicationRecord
  belongs_to :line_account
  belongs_to :folder
  has_many :episodes, dependent: :destroy
  has_many :remindings

  def destroyable?
    self.remindings.count == 0
  end

  def clone!
    new_reminder = self.dup
    new_reminder.name = self.name + '（コピー）'
    new_reminder.episodes_count = nil
    new_reminder.save!
    self.episodes&.each { |episode| episode.clone_to!(new_reminder.id) }
    new_reminder
  end
end
