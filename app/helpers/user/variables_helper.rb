# frozen_string_literal: true

module User::VariablesHelper
  def build_variable(params)
    variable = Variable.new(params)
    variable.line_account = Current.user.line_account
    variable
  end
end
