# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id              :bigint           not null, primary key
#  line_friend_id  :bigint
#  room_id         :string(255)
#  room_name       :string(255)
#  stock           :integer
#  stock_from      :datetime
#  stock_to        :datetime
#  notifier_id     :string(255)
#  status          :string(255)      default("wait")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_reservations_on_line_account_id  (line_account_id)
#  index_reservations_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
class Reservation < ApplicationRecord
  belongs_to :line_account
  belongs_to :line_friend

  # Scopes
  enum status: { wait: 'wait', cancelled: 'cancelled', done: 'done' }

  def customer_name
    line_friend.name
  end

  def cancel
    self.status = :cancelled
    self.save
  end

  def mark_as_done
    self.status = :done
    self.save
  end

  def update_notifier_id_from_pms(inquiry_id)
    return unless inquiry_id && inquiry = ReservationInquiry.find_by_id(inquiry_id)
    api_result = Pms::CreateRoomNotifier.new(self.line_account.pms_api_key).perform(
      room_id.to_i,
      {
        listenOn: ['roomStock'],
        notifyTo: 'https://ca28-2a09-bac1-7ae0-50-00-246-43.ngrok.io/reservations/callback',
        stockFrom: I18n.l(inquiry.date_start, format: :hyphen),
        stockTo: I18n.l(inquiry.date_end, format: :hyphen)
      }
    )
    if api_result
      self.notifier_id = api_result
      self.stock = inquiry.num_room
      self.stock_from = inquiry.date_start
      self.stock_to = inquiry.date_end
      self.save!
    end
  end
end
