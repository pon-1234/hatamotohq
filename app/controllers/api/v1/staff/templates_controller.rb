# frozen_string_literal: true

class Api::V1::Staff::TemplatesController < Api::V1::Staff::ApplicationController
  # GET /api/v1/staff/templates
  def index
    @folders = Folder.accessible_by(current_ability).type_template_message
      .includes(:templates).references(:templates)
  end
end
