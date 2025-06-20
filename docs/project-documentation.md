# HatamotoHQ プロジェクトドキュメント

## 目次
1. [プロジェクト概要](#プロジェクト概要)
2. [技術スタック](#技術スタック)
3. [開発環境セットアップ](#開発環境セットアップ)
4. [Vue 3 移行状況](#vue-3-移行状況)
5. [フロントエンド改善](#フロントエンド改善)
6. [デプロイメント](#デプロイメント)

---

## プロジェクト概要

HatamotoHQは、LINE Bot機能を中心としたメッセージング・CRMプラットフォームです。

### 主な機能
- LINE Botメッセージ管理
- リアルタイムチャット
- 顧客管理（CRM）
- アンケート機能
- リッチメニュー編集
- Flexメッセージビルダー

---

## 技術スタック詳細

詳細な技術スタックについては以下を参照：
- **基本的なセットアップ**: [README.md](../README.md)
- **アーキテクチャとAI開発支援情報**: [CLAUDE.md](../CLAUDE.md)

### Vue 2 → Vue 3 ライブラリ移行（完了）
| 旧ライブラリ | 新ライブラリ | 状態 |
|------------|------------|------|
| VeeValidate v2 | VeeValidate v4 | ✅ 完了 |
| CKEditor Vue 2 | CKEditor Vue 3 | ✅ 完了 |
| v-tooltip | FloatingVue | ✅ 完了 |
| vue-lazyload | vue3-lazyload | ✅ 完了 |
| vue-datetime | @vuepic/vue-datepicker | ✅ 完了 |
| vue-multiselect | @vueform/multiselect | ✅ 完了 |
| vue-select | vue-select@4 | ✅ 完了 |
| vue2-google-maps | @fawmi/vue-google-maps | ✅ 完了 |
| v-clipboard | vue-clipboard3 | ✅ 完了 |
| v-viewer | viewerjs (カスタムディレクティブ) | ✅ 完了 |
| vue-click-outside | カスタムディレクティブ | ✅ 完了 |
| vue-google-oauth2 | vue3-google-oauth2 | ✅ 完了 |
| vue-qrcode-component | qrcode.vue | ✅ 完了 |
| vue-chartkick | vue-chartkick@latest | ✅ 完了 |
| Bootstrap-Vue | カスタムBaseComponents | ✅ 完了 |

---

## Vue 3 移行完了 ✅

### 移行成果（2025年1月完了）
- **Vue 3.5.16ネイティブモード** - @vue/compat互換レイヤー完全削除
- **バンドルサイズ削減** - 2,746KB → 2,169KB（**21%削減**）
- **すべてのVue 2ライブラリ移行完了**
- **パフォーマンス向上** - Vue 3の最適化により高速化

### 主要な技術的変更
1. **ライブラリ移行**
   - すべてのVue 2専用ライブラリをVue 3対応版に置換
   - Bootstrap-Vue → カスタムBaseComponentsに完全移行
   
2. **コード最適化**
   - グローバルフィルター → グローバルプロパティに移行
   - ::v-deep → :deep()構文に更新
   - BaseSpinner, BaseDropdown, BaseTabsをComposition APIに移行

3. **ビルドシステム**
   - esbuild → Viteに移行
   - Vue 3ネイティブビルドで最適化

### 今後の改善余地（オプション）
- **Composition API移行** - 残り87ファイルのOptions APIコンポーネント
- **Pinia導入** - より現代的な状態管理
- **TypeScript導入** - 型安全性の向上

### 移行で作成したファイル
- `/app/javascript/src/core/vee-validate.js` - VeeValidate v4設定
- `/app/javascript/src/components/validation/` - 互換性ラッパー
- `/app/javascript/src/components/datetime/Datetime.vue` - vue-datetime互換
- `/app/javascript/src/directives/clipboard.js` - v-clipboard互換
- `/app/javascript/src/directives/click-outside.js` - vue-click-outside互換
- `/app/javascript/src/directives/viewer.js` - v-viewer互換
- `/app/javascript/src/components/multiselect/Multiselect.vue` - vue-multiselect互換

---

## フロントエンド改善

### 実施済みの改善 ✅

#### 1. 基本コンポーネントの作成
- **BaseModal.vue** - 統一モーダル
- **BaseTable.vue** - 高機能テーブル
- **BaseForm.vue** - バリデーション統合フォーム
- **BaseCard.vue** - カードコンポーネント
- **BaseDropdown.vue** - ドロップダウン
- **BaseTabs.vue** - タブコンポーネント
- **BaseSpinner.vue** - ローディングスピナー

#### 2. jQuery依存の削除
- DOM操作ユーティリティ（`dom.js`）作成
- jQueryを使用していたコンポーネントのリファクタリング
- ESLint設定からjQuery環境を削除

#### 3. エラーハンドリングの統一
- **error-handler.js** - 統一エラーハンドリング
- **ApiErrorHandler** (Rails) - API側のエラー処理
- **ApiResponseHelper** (Rails) - レスポンス標準化

#### 4. カスタムディレクティブ
- **v-tooltip** - ツールチップディレクティブ
- **v-clipboard** - クリップボードコピー

### 使用方法
```javascript
// application.jsに追加
import BaseComponents from './src/components/base';
import Directives from './src/directives';
import ErrorHandlerPlugin from './src/plugins/error-handler';

Vue.use(BaseComponents);
Vue.use(Directives);
Vue.use(ErrorHandlerPlugin);
```

---

## デプロイメント

### 環境構成
- **Production**: Fly.io (main branch)
- **Staging**: Fly.io (staging branch) 
- **Development**: Fly.io (develop branch)

### Fly.io セットアップ

1. **Fly CLIインストール**
   ```bash
   curl -L https://fly.io/install.sh | sh
   fly auth login
   ```

2. **アプリケーション作成**
   ```bash
   fly apps create hatamotohq-dev --org your-org
   fly apps create hatamotohq-staging --org your-org
   ```

3. **データベース作成**
   ```bash
   fly postgres create --name hatamotohq-dev-db --region nrt
   fly postgres attach hatamotohq-dev-db --app hatamotohq-dev
   ```

4. **環境変数設定**
   ```bash
   fly secrets import < .env.development --app hatamotohq-dev
   ```

5. **デプロイ**
   ```bash
   fly deploy --config fly.development.toml --app hatamotohq-dev
   ```

### よく使うコマンド
```bash
# ログ確認
fly logs --app hatamotohq-dev

# SSHアクセス
fly ssh console --app hatamotohq-dev

# Railsコンソール
fly ssh console --app hatamotohq-dev -C "rails console"

# マイグレーション実行
fly ssh console --app hatamotohq-dev -C "rails db:migrate"

# ステータス確認
fly status --app hatamotohq-dev

# ロールバック
fly releases --app hatamotohq-dev
fly deploy --app hatamotohq-dev --image registry.fly.io/hatamotohq-dev@sha256:[previous-sha]
```

### ヘルスチェック
```bash
curl https://hatamotohq-dev.fly.dev/health
```

期待されるレスポンス:
```json
{
  "status": "ok",
  "timestamp": "2025-06-18T...",
  "version": "7.2.1",
  "checks": {
    "database": {"status": "ok"},
    "redis": {"status": "ok"}
  }
}
```

---

## 今後の計画

### 短期（1ヶ月）
1. Bootstrap-VueからBootstrapVueNextへの移行開始
2. 残りのVue 2ライブラリの移行
3. パフォーマンステストの実施

### 中期（3ヶ月）
1. Vue 3互換モードの削除
2. TypeScriptの段階的導入
3. E2Eテストの追加

### 長期（6ヶ月）
1. Composition APIへの完全移行
2. Piniaへの移行検討
3. パフォーマンス最適化

---

## トラブルシューティング

### よくある問題

1. **ポート競合**
   - Rails: 3000 (変更: `rails s -p 3001`)
   - Vite: 3036 (`config/vite.json`で設定)

2. **アセットコンパイルエラー**
   ```bash
   bin/vite clobber  # キャッシュクリア
   npm run build     # 再ビルド
   ```

3. **Vue互換性警告**
   - `::v-deep`警告は互換モードでは正常
   - 時間があるときに`:deep()`に更新

4. **データベース接続エラー**
   ```bash
   fly status --app hatamotohq-dev-db
   fly postgres db-url --app hatamotohq-dev-db
   ```

---

最終更新: 2025年6月19日 