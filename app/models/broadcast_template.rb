# == Schema Information
#
# Table name: broadcast_templates
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_broadcast_templates_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class BroadcastTemplate < ApplicationRecord
end
