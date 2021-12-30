# frozen_string_literal: true

User.seed do |s|
  s.id = 1
  s.email = 'client@example.com'
  s.password = 'Admin1234@'
  s.name = 'クライアント管理者'
  s.role = 'admin'
end
