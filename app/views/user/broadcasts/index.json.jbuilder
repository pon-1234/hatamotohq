# frozen_string_literal: true

json.meta do
  json.total_pages @broadcasts.total_pages
  json.current_page @broadcasts.current_page
  json.total_count @broadcasts.total_count
  json.limit_value @broadcasts.limit_value
end
json.data do
  json.array! @broadcasts do |broadcast|
    json.(broadcast, :id, :title, :type, :status, :deliver_now, :deliver_at, :schedule_at, :conditions)
    json.editable broadcast.editable?
    json.destroyable broadcast.destroyable?
    json.tags do
      json.array! broadcast.tags do |tag|
        json.partial! 'models/tag', tag: tag
      end
    end
  end
end
