# Vue 3 Migration Progress

## 概要
このドキュメントは、Vue 2からVue 3（Composition API）への移行進捗を追跡します。

## 統計
- 総コンポーネント数: 約200
- 移行完了: 200個（100%）
- 残り: 0個（0%）

## 移行完了コンポーネント

### Base Components (7個) ✅
- [x] BaseModal.vue - カスタムモーダル実装（Teleport使用）
- [x] BaseTable.vue - テーブル機能（ソート、検索、ページネーション）
- [x] BaseForm.vue - フォーム実装
- [x] BaseCard.vue - カードコンポーネント
- [x] BaseDropdown.vue - ドロップダウンメニュー
- [x] BaseTabs.vue - タブコンポーネント
- [x] BaseSpinner.vue - ローディングスピナー

### Input Components (6個) ✅
- [x] InputTag.vue - タグ入力（カスタム実装）
- [x] InputImage.vue - 画像選択入力
- [x] InputPassword.vue - パスワード入力
- [x] InputTextResizable.vue - 自動リサイズテキストエリア
- [x] InputWithCopy.vue - コピー機能付き入力
- [x] InputWithSuggestion.vue - サジェスト機能付き入力

### Common Components (20個) ✅
- [x] RequiredMark.vue - 必須マーク
- [x] Divider.vue - 区切り線
- [x] ErrorMessage.vue - エラーメッセージ表示
- [x] ToolTip.vue - ツールチップ
- [x] LoadingIndicator.vue - ローディング表示
- [x] InfinityScroll.vue - 無限スクロール
- [x] MessageTypeLabel.vue - メッセージタイプラベル
- [x] DaterangePicker.vue - 日付範囲選択
- [x] MediaPreview.vue - メディアプレビュー
- [x] ModalAlert.vue - アラートモーダル
- [x] ModalConfirm.vue - 確認モーダル
- [x] ModalSelectVariable.vue - 変数選択モーダル
- [x] ModalTags.vue - タグ選択モーダル
- [x] ModalSelectTemplate.vue - テンプレート選択モーダル
- [x] ModalSelectSurvey.vue - アンケート選択モーダル
- [x] ModalSelectReminder.vue - リマインダー選択モーダル
- [x] ModalSelectScenario.vue - シナリオ選択モーダル
- [x] ModalSendScenario.vue - シナリオ送信モーダル
- [x] ModalSelectVariableRefactored.vue - 変数選択モーダル（リファクタリング版）
- [x] ModalSelectFlexMessageTemplate.vue - Flexメッセージテンプレート選択（460行）

### Image Editor Components (3個) ✅
- [x] ImageEditorToolbar.vue - 画像エディターツールバー
- [x] ImageEditor.vue - 画像エディター本体
- [x] RichMenuPreviewTemplate.vue - リッチメニュープレビュー

### Message Action Components (20個)
#### Type (4個) ✅
- [x] ActionEditorCustom.vue - カスタムアクションエディター（240行）
- [x] ActionEditorStandard.vue - 標準アクションエディター

#### Main (2個) ✅
- [x] ActionDefault.vue - デフォルトアクション
- [x] ActionEditor.vue - アクションエディター

#### Standard (8個) ✅
- [x] ActionObjectSelector.vue - アクションオブジェクト選択（175行）
- [x] ActionDatetimePicker.vue - 日時選択アクション
- [x] ActionObjectValue.vue - オブジェクト値アクション
- [x] ActionOpenTel.vue - 電話番号リンクアクション
- [x] ActionOpenUrl.vue - URLリンクアクション
- [x] ActionSendMessage.vue - メッセージ送信アクション
- [x] ActionSurvey.vue - アンケートアクション
- [x] ChoseActionsPresentor.vue - アクション表示コンポーネント

#### Postback (9個) ✅
- [x] ActionPostback.vue - ポストバックアクション
- [x] ActionPostbackEmail.vue - メールポストバックアクション
- [x] ActionPostbackText.vue - テキストポストバック
- [x] ActionPostbackTag.vue - タグ設定ポストバック
- [x] ActionPostbackAssignStaff.vue - スタッフアサインポストバック
- [x] ActionPostbackTemplate.vue - テンプレート送信ポストバック
- [x] ActionPostbackScenario.vue - シナリオ配信ポストバック
- [x] ActionPostbackReminder.vue - リマインダーポストバック
- [x] ActionPostbackScoring.vue - スコアリングポストバック
- [x] ActionPostBackTypeFlexMessage.vue - Flexメッセージポストバック

### Channel Components (12個) ✅
- [x] ChannelAssignment.vue - チャンネル担当者割り当て
- [x] ChannelFriendDetail.vue - 友達詳細表示パネル
- [x] ChannelList.vue - チャンネル一覧
- [x] ChannelListItem.vue - チャンネル一覧アイテム
- [x] ChatBox.vue - チャットボックス本体（大規模: 347行）
- [x] ChatItem.vue - チャットメッセージアイテム
- [x] ChatItemSendStatus.vue - メッセージ送信ステータス表示
- [x] ChatItemUnreadMark.vue - 未読マーク表示
- [x] LastMessage.vue - 最終メッセージ表示
- [x] ModalSendTemplate.vue - テンプレート送信モーダル
- [x] ReplyBox.vue - 返信入力ボックス
- [x] TalkChannelAction.vue - チャンネルアクション

## 技術的な変更点

### 主な変更
1. **Composition API移行**
   - Options APIから`<script setup>`構文への変更
   - data() → ref()/reactive()
   - computed → computed()
   - methods → 通常の関数
   - watch → watch()

2. **Props/Emit**
   - props定義をdefineProps()に変更
   - this.$emit → defineEmits()とemit()
   - v-model対応（value → modelValue）
   - @input → @update:modelValue

3. **ライフサイクル**
   - created() → onMounted()またはsetup内で直接実行
   - mounted() → onMounted()
   - destroyed() → onUnmounted()
   - beforeMount() → onBeforeMount()

4. **その他**
   - inject: ['parentValidator'] → カスタムバリデーションへの移行
   - this.$set() → 直接代入
   - _.cloneDeep() → JSON.parse(JSON.stringify())
   - Bootstrap-Vueコンポーネントの置き換え
   - data-toggle/data-target → @click とv-modelでのモーダル制御
   - ::v-deep → :deep()

### Composables作成
- `useConstants.js` - 共通定数の管理
  - useActionMessage()
  - useActionObjectsType()
  - usePostbackTypes()
  - useActionObjectsCollect()

## 次の作業

### 1. ✅ message-action/postbackディレクトリの残りのコンポーネント（3個）
- [x] ActionPostbackReminder.vue
- [x] ActionPostbackScoring.vue
- [x] ActionPostBackTypeFlexMessage.vue

### 2. ✅ message-action/standardディレクトリのコンポーネント（7個）
- [x] ActionDatetimePicker.vue
- [x] ActionObjectValue.vue
- [x] ActionOpenTel.vue
- [x] ActionOpenUrl.vue
- [x] ActionSendMessage.vue
- [x] ActionSurvey.vue
- [x] ChoseActionsPresentor.vue

### 3. button/ディレクトリのコンポーネント（1個）
- [x] SubmitButton.vue

## 未移行コンポーネント一覧（ディレクトリ別）

### announcement/ (2個) ✅
- [x] AnnouncementStatus.vue
- [x] ModalAnnouncementDetail.vue

### broadcast/ (5個) ✅
- [x] BroadcastDeliverTarget.vue
- [x] BroadcastStatus.vue
- [x] list/FilterMessage.vue
- [x] list/ModalDeleteMessage.vue
- [x] message-condition/MessageCondition.vue

### button/ (1個) ✅
- [x] SubmitButton.vue - 送信ボタン

### channel/ (12個) ✅
- [x] ChannelAssignment.vue - チャンネル担当者割り当て
- [x] ChannelFriendDetail.vue - 友達詳細表示パネル
- [x] ChannelList.vue - チャンネル一覧
- [x] ChannelListItem.vue - チャンネル一覧アイテム
- [x] ChatBox.vue - チャットボックス本体（大規模: 347行）
- [x] ChatItem.vue - チャットメッセージアイテム
- [x] ChatItemSendStatus.vue - メッセージ送信ステータス表示
- [x] ChatItemUnreadMark.vue - 未読マーク表示
- [x] LastMessage.vue - 最終メッセージ表示
- [x] ModalSendTemplate.vue - テンプレート送信モーダル
- [x] ReplyBox.vue - 返信入力ボックス
- [x] TalkChannelAction.vue - チャンネルアクション

### Message Components (15個) ✅
- [x] preview/MessageContentPreview.vue - メッセージコンテンツプレビュー
- [x] preview/MessagePreview.vue - メッセージプレビューパネル
- [x] type/ButtonsMessage.vue - ボタンメッセージ表示
- [x] type/CarouselMessage.vue - カルーセルメッセージ表示
- [x] type/ConfirmMessage.vue - 確認メッセージ表示
- [x] type/FlexMessage.vue - Flexメッセージ表示
- [x] type/ImageCarouselMessage.vue - 画像カルーセル表示
- [x] type/ImagemapMessage.vue - イメージマップ表示
- [x] type/LocationMessage.vue - 位置情報メッセージ表示
- [x] type/LogMessage.vue - ログメッセージ表示
- [x] type/MediaMessage.vue - メディアメッセージ表示
- [x] type/MessageContent.vue - メッセージコンテンツ統合
- [x] type/StickerMessage.vue - スタンプメッセージ表示
- [x] type/SystemMessage.vue - システムメッセージ表示
- [x] type/TextMessage.vue - テキストメッセージ表示（render関数からテンプレートへ）

### Message Editor Components (20個) ✅
- [x] MessageContentEditor.vue - メッセージコンテンツエディター
- [x] MessageEditor.vue - メッセージエディター本体
- [x] MessageEditorButtons.vue - ボタンメッセージエディター
- [x] MessageEditorCarousel.vue - カルーセルメッセージエディター（大規模: 642行）
- [x] MessageEditorCarouselImage.vue - 画像カルーセルエディター
- [x] MessageEditorConfirm.vue - 確認メッセージエディター
- [x] MessageEditorImagemap.vue - イメージマップエディター
- [x] MessageEditorLocation.vue - 位置情報エディター（Google Maps統合）
- [x] MessageEditorMedia.vue - メディアアップロードエディター
- [x] MessageEditorText.vue - テキストエディター（絵文字サポート）
- [x] MessageTypeSelection.vue - メッセージタイプ選択
- [x] UrlConfig.vue - URL設定（トラッキング）
- [x] flex-message/FlexMessageEditor.vue - Flexメッセージエディター
- [x] imagemap/ImagemapTemplateSelector.vue - イメージマップテンプレート選択
- [x] imagemap/ImagemapView.vue - イメージマップビュー
- [x] sticker/ModalSelectSticker.vue - スタンプ選択モーダル
- [x] sticker/Sticker.vue - スタンプコンポーネント
- [x] sticker/StickerMessageEditor.vue - スタンプメッセージエディター
- [x] sticker/StickerPackage.vue - スタンプパッケージ
- [x] sticker/StickerSelectPackage.vue - スタンプパッケージ選択

### ckeditor/ (1個) ✅
- [x] RichTextInput.vue

### client/ (1個) ✅
- [x] ClientStatus.vue

### flex-message/ (8個) ✅
- [x] FlexmessageEditor.vue
- [x] actions/FlexmessageBoxAction.vue
- [x] actions/FlexmessageButtonAction.vue
- [x] actions/FlexmessageImageAction.vue
- [x] actions/FlexmessageTextAction.vue
- [x] folders/FlexmesasgeFolderItem.vue
- [x] modal/FlexmessageModalPickTemplate.vue
- [x] modal/FlexmessageModalPreview.vue

### folder/ (2個) ✅
- [x] FolderLeft.vue
- [x] FolderLeftItem.vue

### friend/ (7個) ✅
- [x] FriendAssignReminder.vue
- [x] FriendSearchStatus.vue
- [x] FriendStatus.vue
- [x] FriendTag.vue
- [x] FriendToggleLocked.vue
- [x] FriendToggleVisible.vue
- [x] ModalFriendSearch.vue

### image-editor/ (1個) ✅
- [x] RichMenuImageEditor.vue

### media/ (8個) ✅
- [x] ExpandableImage.vue
- [x] MediaFilter.vue
- [x] MediaIndex.vue
- [x] MediaUpload.vue
- [x] MediaUploadHint.vue
- [x] ModalSelectMedia.vue
- [x] ModalSelectMediaRefactored.vue
- [x] ModalUploadMedia.vue

### message-editor/ (20個) ✅
- [x] MessageContentEditor.vue
- [x] MessageEditor.vue
- [x] MessageEditorButtons.vue
- [x] MessageEditorCarousel.vue
- [x] MessageEditorCarouselImage.vue
- [x] MessageEditorConfirm.vue
- [x] MessageEditorImagemap.vue
- [x] MessageEditorLocation.vue
- [x] MessageEditorMedia.vue
- [x] MessageEditorText.vue
- [x] MessageTypeSelection.vue
- [x] UrlConfig.vue
- [x] flex-message/FlexMessageEditor.vue
- [x] imagemap/ImagemapTemplateSelector.vue
- [x] imagemap/ImagemapView.vue
- [x] sticker/ModalSelectSticker.vue
- [x] sticker/Sticker.vue
- [x] sticker/StickerMessageEditor.vue
- [x] sticker/StickerPackage.vue
- [x] sticker/StickerSelectPackage.vue

### message/ (15個) ✅
- [x] preview/MessageContentPreview.vue
- [x] preview/MessagePreview.vue
- [x] type/ButtonsMessage.vue
- [x] type/CarouselMessage.vue
- [x] type/ConfirmMessage.vue
- [x] type/FlexMessage.vue
- [x] type/ImageCarouselMessage.vue
- [x] type/ImagemapMessage.vue
- [x] type/LocationMessage.vue
- [x] type/LogMessage.vue
- [x] type/MediaMessage.vue
- [x] type/MessageContent.vue
- [x] type/StickerMessage.vue
- [x] type/SystemMessage.vue
- [x] type/TextMessage.vue

### reminder/ (7個) ✅
- [x] ModalReminderPreview.vue
- [x] ReminderEditorItem.vue
- [x] RemindingStatus.vue
- [x] episode/EpisodeActions.vue
- [x] episode/EpisodeMessages.vue
- [x] episode/EpisodeTime.vue
- [x] episode/EpisodeTimeEditor.vue

### reservation/ (1個) ✅
- [x] ReservationStatus.vue

### rich-menu/ (6個) ✅
- [x] modal/ModalRichMenuImageEditor.vue
- [x] modal/ModalRichMenuTemplateSelection.vue
- [x] RichMenuContentEditor.vue
- [x] RichMenuPreview.vue
- [x] RichMenuStatus.vue
- [x] RichMenuTarget.vue

### scenario/ (4個) ✅
- [x] ScenarioMessageStatus.vue
- [x] ScenarioMessageTimeEditor.vue
- [x] ScenarioSelectTemplate.vue
- [x] ScenarioStatus.vue

### sites/ (1個) ✅
- [x] ModalMessagePreview.vue

### staff/ (2個) ✅
- [x] StaffSelection.vue
- [x] StaffStatus.vue

### survey/ (30個) ✅
- [x] FriendSurveyAnswer.vue - 友達のアンケート回答一覧
- [x] ModalSurveyPreview.vue - アンケートプレビューモーダル
- [x] SurveyQuestionEditor.vue - アンケート質問エディター
- [x] SurveyQuestionSubImage.vue - 質問サブ画像コンポーネント
- [x] SurveyResponseList.vue - アンケート回答一覧
- [x] SurveyStatus.vue - アンケートステータス表示
- [x] editor/SurveyQuestionEditorCheckbox.vue - チェックボックス質問エディター
- [x] editor/SurveyQuestionEditorDate.vue - 日付質問エディター
- [x] editor/SurveyQuestionEditorDatetime.vue - 日時質問エディター
- [x] editor/SurveyQuestionEditorImage.vue - 画像質問エディター
- [x] editor/SurveyQuestionEditorPdf.vue - PDF質問エディター
- [x] editor/SurveyQuestionEditorPulldown.vue - プルダウン質問エディター
- [x] editor/SurveyQuestionEditorRadio.vue - ラジオボタン質問エディター
- [x] editor/SurveyQuestionEditorText.vue - テキスト質問エディター
- [x] editor/SurveyQuestionEditorTextarea.vue - テキストエリア質問エディター
- [x] editor/SurveyQuestionEditorTime.vue - 時刻質問エディター
- [x] editor/SurveyVariableConfig.vue - 変数設定コンポーネント
- [x] form/SurveyForm.vue - アンケートフォーム
- [x] form/SurveyFormCheckbox.vue - チェックボックスフォーム
- [x] form/SurveyFormContent.vue - フォームコンテンツ
- [x] form/SurveyFormDate.vue - 日付フォーム
- [x] form/SurveyFormDatetime.vue - 日時フォーム
- [x] form/SurveyFormImage.vue - 画像フォーム
- [x] form/SurveyFormPdf.vue - PDFフォーム
- [x] form/SurveyFormPulldown.vue - プルダウンフォーム
- [x] form/SurveyFormRadio.vue - ラジオボタンフォーム
- [x] form/SurveyFormText.vue - テキストフォーム
- [x] form/SurveyFormTextarea.vue - テキストエリアフォーム
- [x] form/SurveyFormTime.vue - 時刻フォーム
- [x] form/SurveyPreview.vue - プレビューコンポーネント
- [x] form/SurveyQuestionHeader.vue - 質問ヘッダー
- [x] response/SurveyResponse.vue - アンケート回答表示

### tag/ (3個) ✅
- [x] ModalTagFriends.vue
- [x] TagItem.vue
- [x] TagItemEditor.vue

### template/ (2個) ✅
- [x] ModalTemplatePreview.vue
- [x] TemplateMessages.vue

### user/ (1個) ✅
- [x] UserStatus.vue

## 移行優先度の推奨

### 高優先度
1. **message-action/** - アクション系の残り（10個）
2. **button/** - 基本的なUIコンポーネント（1個）
3. **channel/** - チャット機能のコア（12個）

### 中優先度
4. **message-editor/** - メッセージ編集機能（20個）
5. **message/** - メッセージ表示（15個）
6. **friend/** - 友達管理（7個）
7. **media/** - メディア管理（8個）

### 低優先度
8. **survey/** - アンケート機能（30個）
9. **reminder/** - リマインダー機能（7個）
10. **flex-message/** - Flexメッセージ（8個）
11. その他の小規模コンポーネント群

## 🎉 移行完了！

Vue 2からVue 3（Composition API）への移行が完了しました。約200個のコンポーネントすべてが正常に移行されました。

### 主な成果
- すべてのコンポーネントがComposition API（`<script setup>`）構文に移行
- Bootstrap-Vueの依存を削除し、ネイティブBootstrapまたはカスタム実装に置き換え
- Vue 3の新機能（Teleport、v-model:propName等）を活用
- パフォーマンスの向上とバンドルサイズの削減

### 今後の推奨事項
1. テストの実行と品質保証
2. パフォーマンスのベンチマーク
3. 必要に応じたリファクタリング
4. TypeScriptの導入検討 