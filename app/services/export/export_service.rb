# frozen_string_literal: true

require 'csv'

class Export::ExportService
  include CsvHelper

  def perform
    CSV.generate(encoding: Encoding::SJIS) do |csv|
      csv << header
      objects.each do |object|
        csv << attributes.map { |attr| sjis_safe(object.public_send(attr)&.to_s)&.encode(Encoding::SJIS, invalid: :replace, undef: :replace) }
      end
    end
  end

  private
    attr_reader :attributes, :objects, :header
end
