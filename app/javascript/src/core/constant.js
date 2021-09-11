import Util from './util';

export const MessageTypeIds = {
  Text: 1,
  Sticker: 2,
  Image: 3,
  Video: 4,
  Audio: 5,
  Location: 6,
  Imagemap: 7,
  TemplateButtons: 8,
  TemplateConfirm: 9,
  TemplateCarousel: 10,
  TemplateImageCarousel: 11,
  Flex: 12
};

export const MessageType = {
  Text: 'text',
  Sticker: 'sticker',
  Image: 'image',
  Video: 'video',
  Audio: 'audio',
  Location: 'location',
  Imagemap: 'imagemap',
  Template: 'template',
  Flex: 'flex'
};

export const MessageDeliveriesStatus = {
  Pending: 'pending',
  Draft: 'draft'
};

export const TemplateMessageType = {
  Buttons: 'buttons',
  Confirm: 'confirm',
  Carousel: 'carousel',
  ImageCarousel: 'image_carousel'
};

export const ActionObjectsType = {
  Postback: 'postback',
  Message: 'message',
  Uri: 'uri',
  Tel: 'tel',
  Survey: 'survey',
  Datetimepicker: 'datetimepicker',
  Camera: 'camera',
  CameraRoll: 'cameraRoll',
  Location: 'location'
};

export const ImageType = ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg'];

export const VideoType = ['video/quicktime', 'video/mp4', 'video/m4v', 'video/x-m4v', 'video/wmv'];

export const AudioType = ['audio/mpeg', 'audio/ogg', 'audio/mp3', 'audio/x-m4a'];

export const PdfType = ['application/pdf', 'application/x-pdf'];

export const UploadMaxSize = {
  Image: 10000000,
  Video: 200000000,
  Audio: 200000000,
  Pdf: 10000000,
  RichMenu: 1000000
};

export const Gender = [
  { value: 'all', text: '設定しない' },
  { value: 'male', text: '男性のみ' },
  { value: 'female', text: '女性のみ' }
];

export const Prefecture = [
  { value: 'jp_01', text: '北海道' },
  { value: 'jp_02', text: '青森県 ' },
  { value: 'jp_03', text: '岩手県' },
  { value: 'jp_04', text: '宮城県' },
  { value: 'jp_05', text: '秋田県' },
  { value: 'jp_06', text: '山形県' },
  { value: 'jp_07', text: '福島県' },
  { value: 'jp_08', text: '茨城県' },
  { value: 'jp_09', text: '栃木県' },
  { value: 'jp_10', text: '群馬県' },
  { value: 'jp_11', text: '埼玉県' },
  { value: 'jp_12', text: '千葉県' },
  { value: 'jp_13', text: '東京都' },
  { value: 'jp_14', text: '神奈川県' },
  { value: 'jp_15', text: '新潟県' },
  { value: 'jp_16', text: '富山県' },
  { value: 'jp_17', text: '石川県' },
  { value: 'jp_18', text: '福井県' },
  { value: 'jp_19', text: '山梨県' },
  { value: 'jp_20', text: '長野県' },
  { value: 'jp_21', text: '岐阜県' },
  { value: 'jp_22', text: '静岡県' },
  { value: 'jp_23', text: '愛知県' },
  { value: 'jp_24', text: '三重県' },
  { value: 'jp_25', text: '滋賀県' },
  { value: 'jp_26', text: '京都府' },
  { value: 'jp_27', text: '大阪府' },
  { value: 'jp_28', text: '兵庫県' },
  { value: 'jp_29', text: '奈良県' },
  { value: 'jp_30', text: '和歌山県' },
  { value: 'jp_31', text: '鳥取県' },
  { value: 'jp_32', text: '島根県' },
  { value: 'jp_33', text: '岡山県' },
  { value: 'jp_34', text: '広島県' },
  { value: 'jp_35', text: '山口県' },
  { value: 'jp_36', text: '徳島県' },
  { value: 'jp_37', text: '香川県' },
  { value: 'jp_38', text: '愛媛県' },
  { value: 'jp_39', text: '高知県' },
  { value: 'jp_40', text: '福岡県' },
  { value: 'jp_41', text: '佐賀県' },
  { value: 'jp_42', text: '長崎県' },
  { value: 'jp_43', text: '熊本県' },
  { value: 'jp_44', text: '大分県' },
  { value: 'jp_45', text: '宮崎県' },
  { value: 'jp_46', text: '鹿児島県' },
  { value: 'jp_47', text: '沖縄県' }
];

export const MonthBirthday = [
  { value: 1, text: '1月' },
  { value: 2, text: '2月' },
  { value: 3, text: '3月' },
  { value: 4, text: '4月' },
  { value: 5, text: '5月' },
  { value: 6, text: '6月' },
  { value: 7, text: '7月' },
  { value: 8, text: '8月' },
  { value: 9, text: '9月' },
  { value: 10, text: '10月' },
  { value: 11, text: '11月' },
  { value: 12, text: '12月' }
];

export const MessageDeliveriesStatusFilter = [
  { value: 'all', text: 'すべて' },
  { value: 'done', text: '配信済み' },
  { value: 'pending', text: '配信予約' },
  { value: 'sending', text: '配信待ち' },
  { value: 'draft', text: '下書き' }
];

export const ScenarioStatusFilter = [
  { value: 'all', text: 'すべて' },
  { value: 'enable', text: '配信中' },
  { value: 'disable', text: '停止中' },
  { value: 'draft', text: '下書き' }
];

export const RichMenuValue = {
  201: 6,
  202: 4,
  203: 4,
  204: 3,
  205: 2,
  206: 2,
  207: 1,
  1001: 3,
  1002: 2,
  1003: 2,
  1004: 2,
  1005: 1
};
export const RichMenuBounds = {
  201: [
    { x: 0, y: 0, width: 833, height: 843, crop_index: 0 },
    { x: 833, y: 0, width: 834, height: 843, crop_index: 0 },
    { x: 1667, y: 0, width: 833, height: 843, crop_index: 0 },
    { x: 0, y: 843, width: 833, height: 843, crop_index: 0 },
    { x: 833, y: 843, width: 834, height: 843, crop_index: 0 },
    { x: 1667, y: 843, width: 833, height: 843, crop_index: 0 }
  ],
  202: [
    { x: 0, y: 0, width: 1250, height: 843, crop_index: 3 },
    { x: 1250, y: 0, width: 1250, height: 843, crop_index: 3 },
    { x: 0, y: 843, width: 1250, height: 843, crop_index: 3 },
    { x: 1250, y: 843, width: 1250, height: 843, crop_index: 3 }
  ],
  203: [
    { x: 0, y: 0, width: 2500, height: 843, crop_index: 1 },
    { x: 0, y: 843, width: 833, height: 843, crop_index: 0 },
    { x: 833, y: 843, width: 834, height: 843, crop_index: 0 },
    { x: 1667, y: 843, width: 833, height: 843, crop_index: 0 }
  ],
  204: [
    { x: 0, y: 0, width: 1667, height: 1686, crop_index: 4 },
    { x: 1667, y: 0, width: 833, height: 843, crop_index: 0 },
    { x: 1667, y: 843, width: 833, height: 843, crop_index: 0 }
  ],
  205: [
    { x: 0, y: 0, width: 2500, height: 843, crop_index: 1 },
    { x: 0, y: 843, width: 2500, height: 843, crop_index: 1 }
  ],
  206: [
    { x: 0, y: 0, width: 1250, height: 1686, crop_index: 5 },
    { x: 1250, y: 0, width: 1250, height: 1686, crop_index: 5 }
  ],
  207: [
    { x: 0, y: 0, width: 2500, height: 1686, crop_index: 2 }
  ],
  1001: [
    { x: 0, y: 0, width: 833, height: 843, crop_index: 0 },
    { x: 833, y: 0, width: 834, height: 843, crop_index: 0 },
    { x: 1667, y: 0, width: 833, height: 843, crop_index: 0 }
  ],
  1002: [
    { x: 0, y: 0, width: 833, height: 843, crop_index: 0 },
    { x: 833, y: 0, width: 1667, height: 843, crop_index: 6 }
  ],
  1003: [
    { x: 0, y: 0, width: 1667, height: 843, crop_index: 6 },
    { x: 1667, y: 0, width: 833, height: 843, crop_index: 0 }
  ],
  1004: [
    { x: 0, y: 0, width: 1250, height: 843, crop_index: 3 },
    { x: 1250, y: 0, width: 1250, height: 843, crop_index: 3 }
  ],
  1005: [
    { x: 0, y: 0, width: 2500, height: 843, crop_index: 1 }
  ]
};

export const ImageMapValue = {
  201: 6,
  202: 4,
  203: 3,
  204: 3,
  205: 2,
  206: 2,
  207: 1,
  208: 3
};

// 1040 * 1040
export const ImageMapBounds = {
  201: [
    { x: 0, y: 0, width: 346, height: 520, crop_index: 7 },
    { x: 346, y: 0, width: 348, height: 520, crop_index: 7 },
    { x: 694, y: 0, width: 346, height: 520, crop_index: 7 },
    { x: 0, y: 520, width: 346, height: 520, crop_index: 7 },
    { x: 346, y: 520, width: 348, height: 520, crop_index: 7 },
    { x: 694, y: 520, width: 346, height: 520, crop_index: 7 }
  ],
  202: [
    { x: 0, y: 0, width: 520, height: 520, crop_index: 8 },
    { x: 520, y: 0, width: 520, height: 520, crop_index: 8 },
    { x: 0, y: 520, width: 520, height: 520, crop_index: 8 },
    { x: 520, y: 520, width: 520, height: 520, crop_index: 8 }
  ],
  203: [
    { x: 0, y: 0, width: 1040, height: 346, crop_index: 9 },
    { x: 0, y: 346, width: 1040, height: 348, crop_index: 9 },
    { x: 0, y: 694, width: 1040, height: 346, crop_index: 9 }
  ],
  204: [
    { x: 0, y: 0, width: 520, height: 520, crop_index: 10 },
    { x: 520, y: 0, width: 520, height: 520, crop_index: 8 },
    { x: 0, y: 520, width: 1040, height: 520, crop_index: 8 }
  ],
  205: [
    { x: 0, y: 0, width: 1040, height: 520, crop_index: 10 },
    { x: 0, y: 520, width: 1040, height: 520, crop_index: 10 }
  ],
  206: [
    { x: 0, y: 0, width: 520, height: 1040, crop_index: 12 },
    { x: 520, y: 0, width: 520, height: 1040, crop_index: 12 }
  ],
  207: [
    { x: 0, y: 0, width: 1040, height: 1040, crop_index: 13 }
  ],
  208: [
    { x: 0, y: 0, width: 1040, height: 260, crop_index: 10 },
    { x: 0, y: 260, width: 1040, height: 260, crop_index: 11 },
    { x: 0, y: 520, width: 1040, height: 520, crop_index: 11 }
  ]
};

export const PostbackTypes = {
  text: 'テキスト送信',
  template: 'テンプレート送信',
  scenario: 'ステップ送信',
  flexMessage: 'Flexメッセージ送信',
  email: 'メール通知',
  'no-action': '何もしない'
  // tag: 'タグを操作'
};

export const ActionMessage = {
  default: {
    type: 'postback',
    data: {
      messages: [
        { type: 'no-action' }
      ],
      tags: { type: 'tag', content: { tag_ids: [] } }
    }
  }
};

export const ActionMessageImageMap = {
  default: {
    type: 'uri',
    id: 1,
    linkUri: ''
  }
};

export const ImageRichMenuSize = [
  '2500x1686',
  '2500x843',
  '1200x810',
  '1200x405',
  '800x540',
  '800x270'
];

export const ImageImagemapSize = '1040x1040';

export const aspectModes = [
  'cover',
  'fit'
];

export const FontSizeClass = ['XXs', 'Xs', 'Sm', 'Md', 'Lg', 'Xl', 'XXl', '3Xl', '4Xl', '5Xl'];
