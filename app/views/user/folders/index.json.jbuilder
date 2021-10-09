json.array! @folders do |folder|
  json.(folder, :id, :name)
end
