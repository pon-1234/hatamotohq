# 開発ガイド

## 📋 目次

1. [開発環境のセットアップ](#開発環境のセットアップ)
2. [開発サーバーの起動](#開発サーバーの起動)
3. [開発フロー](#開発フロー)
4. [コーディング規約](#コーディング規約)
5. [テスト](#テスト)
6. [デバッグ](#デバッグ)
7. [よくある問題](#よくある問題)

---

## 開発環境のセットアップ

### 必要なツール

- Ruby 3.3.6
- Node.js 18.x以上
- PostgreSQL 14以上
- Redis 6.x以上
- Yarn 1.22以上

### 1. リポジトリのクローン

```bash
git clone https://github.com/your-org/hatamotohq.git
cd hatamotohq
```

### 2. 依存関係のインストール

```bash
# Rubyの依存関係
bundle install

# Node.jsの依存関係
yarn install --ignore-engines
```

### 3. データベースのセットアップ

```bash
# PostgreSQLが起動していることを確認
brew services start postgresql  # macOS
sudo service postgresql start    # Linux

# データベースの作成とマイグレーション
rails db:create
rails db:migrate
rails db:seed  # 初期データの投入
```

### 4. 環境変数の設定

```bash
# .env.exampleをコピー
cp .env.example .env

# 必要な環境変数を編集
vi .env
```

必須の環境変数：
```
# Google Maps API
VITE_GOOGLE_MAP_KEY=your-google-maps-api-key

# LINE Bot（開発環境では任意）
LINE_CHANNEL_SECRET=your-line-channel-secret
LINE_CHANNEL_TOKEN=your-line-channel-token
```

### 5. master.keyの設定

```bash
# 他の開発者から取得するか、新規作成
echo "your-32-character-hex-key" > config/master.key
chmod 600 config/master.key
```

---

## 開発サーバーの起動

### Foremanを使った起動（推奨）

```bash
# すべてのプロセスを同時に起動
foreman start -f Procfile.dev
```

これにより以下が起動します：
- Rails サーバー (port 3000)
- Vite 開発サーバー (port 3036)
- Sidekiq (バックグラウンドジョブ)

### 個別起動

```bash
# Railsサーバー
rails server

# Viteサーバー（別ターミナル）
bin/vite dev

# Sidekiq（別ターミナル）
bundle exec sidekiq
```

### アクセスURL

- アプリケーション: http://localhost:3000
- Vite開発サーバー: http://localhost:3036
- Sidekiq Web UI: http://localhost:3000/sidekiq

---

## 開発フロー

### 1. ブランチ戦略

```bash
# 機能開発
git checkout -b feature/機能名

# バグ修正
git checkout -b fix/バグ名

# ホットフィックス
git checkout -b hotfix/修正内容
```

### 2. コミットメッセージ

```bash
# 形式: <type>: <subject>

# 例
feat: ユーザー認証機能を追加
fix: ログイン時のリダイレクトエラーを修正
docs: READMEを更新
style: コードフォーマットを修正
refactor: 認証ロジックをリファクタリング
test: ユーザーモデルのテストを追加
chore: 依存関係を更新
```

### 3. プルリクエスト

1. 変更をコミット
2. リモートにプッシュ
3. GitHubでプルリクエストを作成
4. コードレビューを受ける
5. マージ

---

## コーディング規約

### Ruby/Rails

```ruby
# Rubocopを使用してコードをチェック
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

### JavaScript/Vue

```bash
# ESLintでチェック
npm run lint

# 自動修正
npm run lint:fix
```

### Vue 3のベストプラクティス

1. **Composition APIの使用**（新規コンポーネント）
```vue
<script setup>
import { ref, computed } from 'vue'

const count = ref(0)
const doubled = computed(() => count.value * 2)
</script>
```

2. **グローバルプロパティの使用**
```javascript
// フィルターの代わりに
app.config.globalProperties.$filters = {
  formatDate: (value) => {
    // フォーマット処理
  }
}
```

3. **スタイルのスコープ**
```vue
<style scoped>
/* または */
<style module>
```

---

## テスト

### RSpecの実行

```bash
# すべてのテスト
bundle exec rspec

# 特定のファイル
bundle exec rspec spec/models/user_spec.rb

# 特定の行
bundle exec rspec spec/models/user_spec.rb:42
```

### JavaScriptテスト

```bash
# Vitestの実行
npm run test

# ウォッチモード
npm run test:watch

# カバレッジ
npm run test:coverage
```

### E2Eテスト（今後実装予定）

```bash
# Cypressの起動
npm run cypress:open
```

---

## デバッグ

### Rails

1. **byebugの使用**
```ruby
def some_method
  byebug  # ここで停止
  # コード
end
```

2. **Railsコンソール**
```bash
rails console
# または
rails c
```

3. **ログの確認**
```bash
tail -f log/development.log
```

### Vue/JavaScript

1. **ブラウザの開発者ツール**
   - Chrome DevTools
   - Vue.js devtools拡張

2. **console.logの使用**
```javascript
console.log('デバッグ情報:', variable)
console.table(arrayData)
console.error('エラー:', error)
```

3. **Vueデバッグ**
```vue
<template>
  <pre>{{ $data }}</pre>
</template>
```

---

## よくある問題

### 1. ポート競合

```bash
# 使用中のポートを確認
lsof -i :3000
lsof -i :3036

# プロセスを終了
kill -9 <PID>
```

### 2. データベース接続エラー

```bash
# PostgreSQLの状態確認
brew services list  # macOS
sudo service postgresql status  # Linux

# データベースの再作成
rails db:drop db:create db:migrate
```

### 3. アセットコンパイルエラー

```bash
# キャッシュをクリア
bin/vite clobber

# node_modulesを再インストール
rm -rf node_modules
yarn install --ignore-engines
```

### 4. Sidekiqジョブが実行されない

```bash
# Redisの確認
redis-cli ping

# Sidekiqのキューを確認
rails c
> Sidekiq::Queue.all
```

### 5. 環境変数が読み込まれない

```bash
# .envファイルの確認
cat .env

# dotenv-railsが正しく動作しているか確認
rails c
> ENV['VITE_GOOGLE_MAP_KEY']
```

---

## 便利なコマンド

```bash
# データベースのリセット
rails db:reset

# マイグレーションステータス
rails db:migrate:status

# ルーティング確認
rails routes | grep user

# Gemの更新
bundle update

# npmパッケージの更新
yarn upgrade-interactive

# アセットのプリコンパイル（本番環境をシミュレート）
RAILS_ENV=production rails assets:precompile

# テスト用データベースの準備
rails db:test:prepare
```

---

## 開発のヒント

1. **ホットリロード**: Viteは自動的にホットリロードするので、ブラウザをリフレッシュする必要はありません

2. **API開発**: Postmanまたはcurlを使用してAPIエンドポイントをテスト

3. **パフォーマンス**: `bullet` gemが有効なので、N+1クエリの警告に注意

4. **セキュリティ**: `brakeman`でセキュリティチェック
   ```bash
   bundle exec brakeman
   ```

---

最終更新: 2025年1月 