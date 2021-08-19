# frozen_string_literal: true

# == Schema Information
#
# Table name: channel_participants
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  channel_id      :bigint
#  line_account_id :bigint
#
# Indexes
#
#  index_channel_participants_on_channel_id       (channel_id)
#  index_channel_participants_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class ChannelParticipant < ApplicationRecord
end
