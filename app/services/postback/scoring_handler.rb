# frozen_string_literal: true

class Postback::ScoringHandler < Postback::BaseHandler
  FLOAT_NUMBER_REGEX = /^-?([0-9]+[.])?[0-9]+$/

  def perform
    variable = Variable.find @content['variable']['id']
    # update for latest friend variable
    friend_variable = FriendVariable.all.order(id: :desc).find_or_initialize_by line_friend_id: @friend.id, variable_id: variable.id
    new_value = calculate_new_variable_value(@content['operation'], @content['value'], (friend_variable.value || variable.default || '0'))
    friend_variable.scorings.build operation: @content['operation'], value: @content['value'],
      old_value: friend_variable.value, new_value: new_value
    friend_variable.value = new_value
    friend_variable.save!
  rescue => exception
    puts exception.message
  end

  private
    def calculate_new_variable_value(operation, factor, current_value)
      case operation
      when 'set'
        factor
      when 'add'
        check_data_type_compatible factor
        (convert_to_float(current_value) + factor.to_f).round(2)
      when 'minus'
        check_data_type_compatible factor
        (convert_to_float(current_value) - factor.to_f).round(2)
      when 'unset'
        nil
      end
    end

    def check_data_type_compatible(factor)
      # Only accept with float values
      raise 'データのタイプは不正です。' if !factor.match(FLOAT_NUMBER_REGEX)
    end

    def convert_to_float(value)
      return value.to_f if value.match(FLOAT_NUMBER_REGEX)
      0.0
    end
end
