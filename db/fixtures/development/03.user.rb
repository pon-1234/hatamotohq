# frozen_string_literal: true

# Schema sometimes need to be reloaded before running a seed
User.reset_column_information()
User.seed do |s|
  s.id = 1
  s.email = 'client@example.com'
  s.password = 'Admin1234@'
  s.name = 'クライアント管理者'
  s.role = 'admin'
  s.client = Client.first
end
