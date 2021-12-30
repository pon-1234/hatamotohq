# frozen_string_literal: true

Admin.seed do |s|
  s.id = 1
  s.email = 'admin@example.com'
  s.password = 'Admin1234@'
  s.name = 'スーパ管理者'
  s.role = 'superadmin'
end
