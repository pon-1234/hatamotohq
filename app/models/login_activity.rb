# frozen_string_literal: true

# == Schema Information
#
# Table name: login_activities
#
#  id             :bigint           not null, primary key
#  city           :string(255)
#  context        :string(255)
#  country        :string(255)
#  failure_reason :string(255)
#  identity       :string(255)
#  ip             :string(255)
#  latitude       :float(24)
#  longitude      :float(24)
#  referrer       :text(65535)
#  region         :string(255)
#  scope          :string(255)
#  strategy       :string(255)
#  success        :boolean
#  user_agent     :text(65535)
#  user_type      :string(255)
#  created_at     :datetime
#  user_id        :bigint
#
# Indexes
#
#  index_login_activities_on_identity               (identity)
#  index_login_activities_on_ip                     (ip)
#  index_login_activities_on_user_type_and_user_id  (user_type,user_id)
#
class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true
end
