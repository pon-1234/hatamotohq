# Fly.ioデプロイ最終チェックリスト

## ✅ 完了項目

### 1. Gemfileとdatabase.yml
- [x] `gem 'pg'`が存在（mysql2は存在しない）
- [x] `config/database.yml`の本番環境が`DATABASE_URL`を使用
- [x] `config/database.yml.ci`もPostgreSQLに修正済み

### 2. Dockerfile
- [x] PostgreSQL用のパッケージ（postgresql-dev, postgresql-client）インストール済み
- [x] Node.jsとYarnのインストール済み
- [x] bundle installとyarn installが実行される
- [x] Viteビルドコマンド（npm run build）が実行される
- [x] ポート8080で統一済み
- [ ] マルチステージビルドの検討（オプション - Dockerfile.multistageを作成済み）

### 3. fly.toml
- [x] `release_command = "bundle exec rails db:migrate"`設定済み
- [x] webプロセス: `bundle exec puma -C config/puma.rb`
- [x] workerプロセス: `bundle exec sidekiq -C config/sidekiq.yml`
- [x] `force_https = true`設定済み
- [x] ポート8080で統一済み

### 4. 環境変数
- [x] すべての`MIX_`プレフィックスを`VITE_`に変更済み
- [x] .env.ciを削除し、.gitignoreに追加済み

## 🚀 デプロイ前の最終確認

### 1. Fly.ioの環境変数設定
```bash
# 必須の環境変数を設定
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)
fly secrets set VITE_ROOT_PATH=https://your-app.fly.dev
fly secrets set VITE_GOOGLE_MAP_KEY=your-google-map-key
fly secrets set VITE_WS_FLEXA_URL=wss://your-app.fly.dev
fly secrets set VITE_SERVEY_MEDIA_FLEXA_URL=https://your-app.fly.dev

# 確認
fly secrets list
```

### 2. ローカルでの最終動作確認
```bash
# 依存関係のインストール
bundle install
yarn install --ignore-engines

# 開発サーバーの起動
foreman start -f Procfile.dev
```

### 3. デプロイコマンド
```bash
# ドライラン（実際にはデプロイしない）
fly deploy --dry-run

# Staging環境へのデプロイ（もしあれば）
fly deploy --config fly.staging.toml

# 本番環境へのデプロイ
fly deploy

# ログの確認
fly logs -a hatamotohq
```

## 📝 トラブルシューティング

### もしデプロイに失敗した場合

1. **ビルドエラー**: `fly logs`でエラーメッセージを確認
2. **起動エラー**: ヘルスチェックのパス（/health）が正しいか確認
3. **データベース接続エラー**: DATABASE_URLが正しく設定されているか確認
4. **アセットエラー**: Viteビルドが成功しているか確認

### 便利なコマンド
```bash
# アプリの状態確認
fly status

# SSHでコンテナに接続
fly ssh console

# データベースに接続
fly postgres connect -a hatamotohq-db

# スケール設定
fly scale show
```