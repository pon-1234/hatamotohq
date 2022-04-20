# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_SENDER', 'noreply@yopaz.vn')

  def contact_to_client(from_crm_line_friend, latest_pms_reservation)
    @from_crm_line_friend = from_crm_line_friend
    @latest_reservation = latest_pms_reservation
    mail_entries_hash = { to: @from_crm_line_friend.line_account.client.admin.email, subject: '「Hotel Insight CRM」顧客対応をアサインされました。' }
    mail_entries_hash[:cc] = @from_crm_line_friend.channel.assignee.email if @from_crm_line_friend.channel.assignee
    mail mail_entries_hash
  end
end
