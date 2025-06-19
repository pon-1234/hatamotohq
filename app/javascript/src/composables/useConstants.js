export const useActionMessage = () => {
  return {
    default: {
      type: 'postback',
      label: '',
      data: '',
      displayText: '',
      text: ''
    }
  };
};

export const useActionObjectsType = () => {
  return {
    Uri: 'uri',
    Postback: 'postback',
    Message: 'message',
    DatetimePicker: 'datetimepicker',
    Camera: 'camera',
    CameraRoll: 'cameraRoll',
    Location: 'location',
    None: 'none'
  };
};

export const usePostbackTypes = () => {
  return {
    none: 'アクションなし',
    text: 'テキスト送信',
    template: 'テンプレート送信',
    scenario: 'シナリオ配信',
    email: 'メール送信',
    tag: 'タグ設定',
    reminder: 'リマインダー設定',
    scoring: 'スコアリング',
    assign_staff: 'スタッフアサイン'
  };
};

export const useActionObjectsCollect = () => {
  return [
    {
      id: 'none',
      type: 'none',
      title: 'アクションなし'
    },
    {
      id: 1,
      type: 'uri',
      title: 'URLを開く'
    },
    {
      id: 2,
      type: 'uri',
      title: '電話する'
    },
    {
      id: 3,
      type: 'message',
      title: 'メッセージ送信'
    },
    {
      id: 4,
      type: 'datetimepicker',
      title: '日時選択'
    },
    {
      id: 5,
      type: 'camera',
      title: 'カメラ起動'
    },
    {
      id: 6,
      type: 'cameraRoll',
      title: 'カメラロール起動'
    },
    {
      id: 7,
      type: 'location',
      title: '位置情報送信'
    },
    {
      id: 8,
      type: 'survey',
      title: 'アンケート回答'
    }
  ];
}; 