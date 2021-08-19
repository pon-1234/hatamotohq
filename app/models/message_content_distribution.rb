# frozen_string_literal: true

# == Schema Information
#
# Table name: message_content_distributions
#
#  id                      :bigint           not null, primary key
#  content                 :text(4294967295)
#  deleted_at              :datetime
#  message_type            :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  message_distribution_id :bigint
#
# Indexes
#
#  index_message_content_distributions_on_message_distribution_id  (message_distribution_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_distribution_id => message_distributions.id)
#
class MessageContentDistribution < ApplicationRecord
end
