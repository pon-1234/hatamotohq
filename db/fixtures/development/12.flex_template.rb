# frozen_string_literal: true

json_arr = [
  {
    "id": 1,
    "type": 'rsv_available',
    "content": {
      "type": 'bubble',
      "hero": {
        "url": '{roomImageUrl}',
        "size": 'full',
        "type": 'image',
        "aspectMode": 'cover',
        "aspectRatio": '20:13'
      },
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "flex": 0,
                "size": 'xl',
                "text": '{roomPrice}',
                "type": 'text',
                "wrap": true,
                "weight": 'bold',
                "color": '#FF0000'
              }
            ]
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "size": 'lg',
                "text": '{roomName}',
                "type": 'text',
                "wrap": true,
                "weight": 'bold',
                "flex": 2
              }
            ],
            "margin": 'md'
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "type": 'text',
                "text": '{roomArea}',
                "flex": 1
              },
              {
                "type": 'text',
                "text": '{roomCapacity}',
                "flex": 1
              },
              {
                "type": 'text',
                "text": '{roomSmoking}',
                "flex": 1
              }
            ],
            "margin": 'md'
          }
        ]
      },
      "footer": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'button',
            "style": 'primary',
            "action": {
              "uri": '{roomOTAUrl}',
              "type": 'uri',
              "label": '予約する'
            }
          }
        ]
      }
    }
  },
  {
    "id": 2,
    "type": 'rsv_unavailable',
    "content": {
      "type": 'bubble',
      "hero": {
        "url": '{roomImageUrl}',
        "size": 'full',
        "type": 'image',
        "aspectMode": 'cover',
        "aspectRatio": '20:13'
      },
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "flex": 0,
                "size": 'xl',
                "text": '{roomPrice}',
                "type": 'text',
                "wrap": true,
                "weight": 'bold',
                "color": '#FF0000'
              }
            ]
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "size": 'lg',
                "text": '{roomName}',
                "type": 'text',
                "wrap": true,
                "weight": 'bold',
                "flex": 2
              }
            ],
            "margin": 'md'
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "type": 'text',
                "text": '{roomArea}',
                "flex": 1
              },
              {
                "type": 'text',
                "text": '{roomCapacity}',
                "flex": 1
              },
              {
                "type": 'text',
                "text": '{roomSmoking}',
                "flex": 1
              }
            ],
            "margin": 'md'
          }
        ]
      },
      "footer": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'button',
            "flex": 2,
            "style": 'primary',
            "color": '#aaaaaa',
            "action": {
              "type": 'postback',
              "label": '人気になる',
              "data": '{postbackData}'
            }
          }
        ]
      }
    }
  }
]

json_arr.each do |json|
  FlexTemplate.seed do |s|
    s.id = json[:id]
    s.type = json[:type]
    s.content = json[:content]
  end
end
