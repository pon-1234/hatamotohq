# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_SENDER', 'noreply@yopaz.vn')

  #TODO
  # This mailer action is only temporary, it'll be replace soon
  def contact_to_client(line_friend, latest_reservation)
    @line_friend = line_friend
    @latest_reservation = latest_reservation
    mail_entries_hash = { to: line_friend.line_account.client.admin.email, subject: "Latest reservation of #{line_friend.display_name}" }
    mail_entries_hash[:cc] = line_friend.channel.assignee.email if line_friend.channel.assignee
    mail mail_entries_hash
  end
end
