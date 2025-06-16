# frozen_string_literal: true

# == Schema Information
#
# Table name: broadcasts
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  conditions      :json
#  title           :string
#  deliver_now     :boolean          default(TRUE)
#  status          :string
#  type            :string
#  schedule_at     :datetime
#  deliver_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#  logs            :text
#
# Indexes
#
#  index_broadcasts_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
FactoryBot.define do
  factory :broadcast do
  end
end
