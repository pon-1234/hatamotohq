# frozen_string_literal: true

class Export::ExportLineFriendService < Export::ExportService
  CSV_ATTRIBUTE = %w(id line_user_id line_name).freeze

  def initialize(objects)
    @attributes = CSV_ATTRIBUTE
    @objects = objects
    @header = CSV_ATTRIBUTE.map { |attr| I18n.t("header_csv.line_friend.#{attr}") }
  end
end
