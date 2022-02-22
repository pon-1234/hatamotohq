# frozen_string_literal: true

ReviewQuestion.seed do |s|
  s.id = 1
  s.type = 'rating'
  s.title = 'チェックイン'
  s.sort_order = 1
  s.config = { min_label: '不満', max_label: '満足', min_value: 1, max_value: 10 }
end
ReviewQuestion.seed do |s|
  s.id = 2
  s.type = 'rating'
  s.title = '料金'
  s.sort_order = 2
  s.config = { min_label: '不満', max_label: '満足', min_value: 1, max_value: 10 }
end
ReviewQuestion.seed do |s|
  s.id = 3
  s.type = 'rating'
  s.title = 'サービス'
  s.sort_order = 3
  s.config = { min_label: '不満', max_label: '満足', min_value: 1, max_value: 10 }
end
ReviewQuestion.seed do |s|
  s.id = 4
  s.type = 'text'
  s.title = 'その他'
  s.sort_order = 4
  s.required = false
end
