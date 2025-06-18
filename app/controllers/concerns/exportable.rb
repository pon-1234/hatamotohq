# frozen_string_literal: true

module Exportable
  extend ActiveSupport::Concern

  included do
    before_action :set_exportable_resources, only: [:export]
  end

  def export
    respond_to do |format|
      format.csv do
        send_data generate_csv(@resources), 
                  filename: export_filename,
                  type: 'text/csv; charset=utf-8'
      end
      
      format.xlsx do
        # Implement Excel export if needed
        redirect_back(fallback_location: root_path, alert: t('errors.format_not_supported'))
      end
    end
  rescue StandardError => e
    Rails.logger.error "Export failed: #{e.message}"
    redirect_back(fallback_location: root_path, alert: t('errors.export_failed'))
  end

  private

  def set_exportable_resources
    @resources = resource_scope
    apply_export_filters if respond_to?(:apply_export_filters, true)
  end

  def generate_csv(resources)
    CSV.generate(headers: true, encoding: 'UTF-8') do |csv|
      csv << csv_headers
      
      resources.find_each do |resource|
        csv << csv_row(resource)
      end
    end
  end

  def export_filename
    "#{resource_name.pluralize}_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv"
  end

  def resource_name
    resource_class.model_name.human.downcase
  end

  # Methods to be implemented in including controller
  def resource_scope
    raise NotImplementedError, "You must define resource_scope method"
  end

  def resource_class
    raise NotImplementedError, "You must define resource_class method"
  end

  def csv_headers
    raise NotImplementedError, "You must define csv_headers method"
  end

  def csv_row(resource)
    raise NotImplementedError, "You must define csv_row method"
  end
end