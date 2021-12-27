# frozen_string_literal: true

json_arr = [
  {
    "id": 1,
    "type": 'rsv_available',
    "content": {
      "type": 'bubble',
      "hero": {
        "type": 'image',
        "size": 'full',
        "aspectRatio": '20:13',
        "aspectMode": 'cover',
        "url": '{roomImageUrl}'
      },
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'text',
            "text": '{roomName}',
            "wrap": true,
            "weight": 'bold',
            "size": 'xl'
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "contents": [
              {
                "type": 'text',
                "text": '{roomPrice}',
                "wrap": true,
                "weight": 'bold',
                "size": 'xl',
                "flex": 0
              }
            ]
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
              "type": 'uri',
              "label": '予約する',
              "uri": '{roomOTAUrl}'
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
        "type": 'image',
        "size": 'full',
        "aspectRatio": '20:13',
        "aspectMode": 'cover',
        "url": '{roomImageUrl}'
      },
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "spacing": 'sm',
        "contents": [
          {
            "type": 'text',
            "text": '{roomName}',
            "wrap": true,
            "weight": 'bold',
            "size": 'xl'
          },
          {
            "type": 'box',
            "layout": 'baseline',
            "flex": 1,
            "contents": [
              {
                "type": 'text',
                "text": '{roomPrice} 円',
                "wrap": true,
                "weight": 'bold',
                "size": 'xl',
                "flex": 0
              }
            ]
          },
          {
            "type": 'text',
            "text": 'Temporarily out of stock',
            "wrap": true,
            "size": 'xxs',
            "margin": 'md',
            "color": '#ff5551',
            "flex": 0
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
