# frozen_string_literal: true

class Postback::ScoringHandler < Postback::BaseHandler
  def perform
    variable = Variable.find @content['variable']['id']
    friend_variable = FriendVariable.find_or_initialize_by line_friend_id: @friend.id, variable_id: variable.id
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
        check_data_type_compatible factor, current_value
        current_value.to_i + factor.to_i
      when 'minus'
        check_data_type_compatible factor, current_value
        current_value.to_i - factor.to_i
      when 'unset'
        nil
      end
    end

    def check_data_type_compatible(factor, current_value)
      raise 'データのタイプは不正です。' if [factor, current_value].any? { |value| !value.match(/^(-?)\d+$/) }
    end
end
