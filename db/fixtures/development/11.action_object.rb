# frozen_string_literal: true

json_arr = [
  {
    "id": 1,
    "title": 'URLを開く',
    "type": 'uri',
    "description": 'When a control associated with this action is tapped, the URI specified in the uri property is opened.',
    "format": {
      "type": 'uri',
      "label": 'View details',
      "uri": 'http://example.com/page/222'
    }
  },
  {
    "id": 2,
    "title": '電話する',
    "type": 'uri',
    "description": 'When a control associated with this action is tapped, the URI specified in the uri property is opened.',
    "format": {
      "type": 'uri',
      "label": 'View details',
      "uri": 'tel://0987654321'
    }
  },

  {
    "id": 3,
    "type": 'datetimepicker',
    "title": '時間を選択する',
    "description": 'When a control associated with this action is tapped, a postback event is returned via webhook with the date and time selected by the user from the date and time selection dialog. The datetime picker action does not support time zones.',
    "format": {
      "type": 'datetimepicker',
      "label": 'Select date',
      "data": 'storeId=12345',
      "mode": 'datetime'
    }
  },
  {
    "id": 4,
    "type": 'cameraRoll',
    "title": '写真を送る',
    "description": 'This action can be configured only with quick reply buttons. When a button associated with this action is tapped, the camera roll screen in LINE is opened.',
    "format": {
      "type": 'cameraRoll',
      "label": 'Camera roll'
    }
  },
  {
    "id": 5,
    "type": 'camera',
    "title": '写真を撮る',
    "description": 'This action can be configured only with quick reply buttons. When a button associated with this action is tapped, the camera screen in LINE is opened.',
    "format": {
      "type": 'camera',
      "label": 'Camera'
    }
  },

  {
    "id": 6,
    "type": 'location',
    "title": '位置情報を送る',
    "description": 'This action can be configured only with quick reply buttons. When a button associated with this action is tapped, the location screen in LINE is opened.',
    "format": {
      "type": 'location',
      "label": 'Location'
    }
  },
  {
    "id": 7,
    "type": 'survey',
    "title": 'アンケート',
    "description": 'This action can be configured only with quick reply buttons. When a button associated with this action is tapped, the location screen in LINE is opened.',
    "format": {
      "type": 'survey',
      "label": 'Location'
    }
  }
]

json_arr.each do |json|
  ActionObject.seed do |s|
    s.id = json[:id]
    s.type = json[:type]
    s.title = json[:title]
    s.description = json[:description]
    s.format = json[:format]
  end
end
