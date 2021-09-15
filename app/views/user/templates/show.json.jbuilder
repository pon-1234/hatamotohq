json.(@template, :id, :name)
json.messages do
  json.array! @template.template_messages do |message|
    json.partial! '/models/template_message', message: message
  end
end