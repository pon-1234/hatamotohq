# frozen_string_literal: true

class Postback::ScoringHandler < Postback::BaseHandler
  def perform
    # TODO action content: { operation: 'set', value: 10, variable: { id: 1, name: 'var_name' } }
    # 1. Kiểm tra tồn tại quan hệ friend_variable, chưa có thì tạo
    # 2. Tạo bản ghi scoring (friend_variable, value, old_value = friend_variable.value, new_value = content.value)
    # 3. Update friend_variable.value = new_value
  end
end
