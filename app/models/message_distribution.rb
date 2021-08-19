# frozen_string_literal: true

# == Schema Information
#
# Table name: message_distributions
#
#  id              :bigint           not null, primary key
#  conditions      :text(65535)
#  date_start      :string(255)
#  deleted_at      :datetime
#  deliver_now     :boolean          default(TRUE)
#  status          :string(255)
#  title           :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_message_distributions_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class MessageDistribution < ApplicationRecord
end
