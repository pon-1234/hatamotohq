# frozen_string_literal: true

json.(media, :id, :type, :url, :preview_url, :download_url, :file_name, :created_at)
json.duration media.file.blob.duration
