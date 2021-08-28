# frozen_string_literal: true

json.(@folder, :id, :name)
json.tags_count @folder.tags.count
