# frozen_string_literal: true

module User::TemplatesHelper
  def build_template(params)
    template = Template.new(params)
    template.line_account = Current.user.line_account
    template
  end
end
