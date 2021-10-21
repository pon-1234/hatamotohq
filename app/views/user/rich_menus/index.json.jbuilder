# frozen_string_literal: true

json.array! @folders do |folder|
  json.(folder, :id, :name)
  json.rich_menus do
    json.array! folder.rich_menus do |rich_menu|
      json.(rich_menu, :id, :folder_id, :name, :status, :selected, :member_count)
      json.image_url rich_menu.image_url
      json.created_at rich_menu.created_at.strftime('%Y.%m.%d')
    end
  end
end
