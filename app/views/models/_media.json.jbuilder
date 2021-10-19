# frozen_string_literal: true

json.(media, :id, :type, :url, :preview_url)
json.duration media.file.blob.duration
json.filename media.file.blob.filename
