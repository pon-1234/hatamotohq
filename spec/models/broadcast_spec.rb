# == Schema Information
#
# Table name: broadcasts
#
#  id              :bigint           not null, primary key
#  conditions      :json
#  date_start      :string(255)
#  deleted_at      :datetime
#  deliver_at      :datetime
#  deliver_now     :boolean          default(TRUE)
#  schedule_at     :datetime
#  status          :string(255)
#  title           :string(255)
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_broadcasts_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
require 'rails_helper'

RSpec.describe Broadcast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
