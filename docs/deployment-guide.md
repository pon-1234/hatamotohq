# Fly.io デプロイメントガイド

## 📋 目次

1. [前提条件](#前提条件)
2. [必要な環境変数](#必要な環境変数)
3. [初回セットアップ](#初回セットアップ)
4. [デプロイ手順](#デプロイ手順)
5. [デプロイ後の確認](#デプロイ後の確認)
6. [トラブルシューティング](#トラブルシューティング)
7. [運用・メンテナンス](#運用・メンテナンス)

---

## 前提条件

### ✅ 完了済みの準備作業

以下の作業はすでに完了しています：

1. **データベース設定** - PostgreSQLを使用（mysql2は削除済み）
2. **Vue 3移行** - Vue 3.5.16への移行完了
3. **環境変数の整理** - すべての`MIX_`プレフィックスを`VITE_`に変更済み
4. **セッションセキュリティ** - 本番環境で`secure: true`が設定済み
5. **Dockerfileとfly.toml** - ポート8080で統一、Viteビルド設定済み
6. **不要ファイルの削除** - バックアップファイル、ビルド済みアセットを削除済み

### 🔑 必要なもの

1. **master.key** - Rails credentialsの暗号化キー
2. **LINE Bot認証情報** - Channel SecretとChannel Access Token
3. **Google Maps API Key** - 地図機能用
4. **Fly.ioアカウント** - [https://fly.io](https://fly.io)でサインアップ

---

## 必要な環境変数

### 必須の環境変数

```bash
# Rails関連
RAILS_MASTER_KEY         # config/master.keyの内容（必須）
DATABASE_URL             # Fly.ioが自動設定
REDIS_URL                # Fly.ioが自動設定
RAILS_SERVE_STATIC_FILES # true
RAILS_LOG_TO_STDOUT      # true

# フロントエンド関連（VITE）
VITE_ROOT_PATH           # https://hatamotohq.fly.dev
VITE_GOOGLE_MAP_KEY      # Google Maps APIキー（必須）
VITE_WS_FLEXA_URL        # wss://hatamotohq.fly.dev
VITE_SERVEY_MEDIA_FLEXA_URL # https://hatamotohq.fly.dev

# LINE Bot関連（必須）
LINE_CHANNEL_SECRET      # LINE Messaging APIのChannel Secret
LINE_CHANNEL_TOKEN       # LINE Messaging APIのChannel Access Token

# オプション
SENTRY_DSN               # Sentryのエラートラッキング用
GOOGLE_OAUTH_CLIENT_ID   # Google OAuth用
```

---

## 初回セットアップ

### 1. master.keyの準備

#### 既存のmaster.keyがある場合
```bash
# master.keyを作成（他の開発者から取得）
echo "your-32-character-hex-key" > config/master.key
chmod 600 config/master.key
```

#### 新規作成する場合
```bash
# 既存のcredentials.yml.encを削除
rm config/credentials.yml.enc

# 新しいcredentialsとmaster.keyを生成
EDITOR="vim" rails credentials:edit
```

### 2. Fly CLIのインストール

```bash
# macOS/Linux
curl -L https://fly.io/install.sh | sh

# ログイン
fly auth login
```

### 3. Fly.ioアプリの作成

```bash
# アプリを作成
fly apps create hatamotohq --org personal

# PostgreSQLデータベースを作成
fly postgres create --name hatamotohq-db --region nrt --initial-cluster-size 1

# データベースをアプリにアタッチ
fly postgres attach hatamotohq-db --app hatamotohq

# Redisを作成
fly redis create --name hatamotohq-redis --region nrt

# Redisをアプリにアタッチ  
fly redis attach hatamotohq-redis --app hatamotohq
```

### 4. ボリュームの作成（Active Storage用）

```bash
fly volumes create hatamotohq_storage --size 10 --region nrt --app hatamotohq
```

---

## デプロイ手順

### 1. 環境変数の設定

```bash
# 必須の環境変数を一括設定
fly secrets set \
  RAILS_MASTER_KEY=$(cat config/master.key) \
  VITE_ROOT_PATH=https://hatamotohq.fly.dev \
  VITE_GOOGLE_MAP_KEY=your-google-map-key \
  VITE_WS_FLEXA_URL=wss://hatamotohq.fly.dev \
  VITE_SERVEY_MEDIA_FLEXA_URL=https://hatamotohq.fly.dev \
  LINE_CHANNEL_SECRET=your-line-channel-secret \
  LINE_CHANNEL_TOKEN=your-line-channel-token \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_LOG_TO_STDOUT=true \
  --app hatamotohq

# 設定を確認
fly secrets list --app hatamotohq
```

### 2. デプロイの実行

```bash
# ドライラン（実際にはデプロイしない）
fly deploy --dry-run --app hatamotohq

# 問題がなければ実際にデプロイ
fly deploy --app hatamotohq

# ログを監視
fly logs --app hatamotohq
```

### 3. デプロイスクリプトの使用（推奨）

プロジェクトに含まれる`fly-deploy.sh`スクリプトを使用：

```bash
# 実行権限を付与
chmod +x fly-deploy.sh

# デプロイを実行
./fly-deploy.sh
```

---

## デプロイ後の確認

### 1. アプリケーションの状態確認

```bash
# ステータス確認
fly status --app hatamotohq

# ヘルスチェック
curl https://hatamotohq.fly.dev/health

# ブラウザで開く
fly open --app hatamotohq
```

### 2. ログの確認

```bash
# リアルタイムログ
fly logs --app hatamotohq

# 過去24時間のログ
fly logs --app hatamotohq --since 24h
```

### 3. コンソールアクセス

```bash
# SSHでコンテナに接続
fly ssh console --app hatamotohq

# Railsコンソール
fly ssh console --app hatamotohq -C "rails console"

# データベースマイグレーション確認
fly ssh console --app hatamotohq -C "rails db:migrate:status"
```

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. ヘルスチェックが失敗する

```bash
# ログを確認
fly logs --app hatamotohq | grep health

# 手動でサーバーを起動してエラーを確認
fly ssh console --app hatamotohq
cd /rails
bundle exec puma -C config/puma.rb
```

#### 2. データベース接続エラー

```bash
# DATABASE_URLを確認
fly ssh console --app hatamotohq -C "printenv DATABASE_URL"

# データベースに直接接続
fly postgres connect --app hatamotohq-db

# データベースのステータス確認
fly status --app hatamotohq-db
```

#### 3. アセットコンパイルエラー

```bash
# コンテナ内でビルドを再実行
fly ssh console --app hatamotohq
cd /rails
npm run build
```

#### 4. 環境変数が反映されない

```bash
# 環境変数を再確認
fly ssh console --app hatamotohq -C "printenv | grep VITE_"

# アプリを再起動
fly apps restart hatamotohq
```

---

## 運用・メンテナンス

### デイリー運用

```bash
# ログ監視
fly logs --app hatamotohq --since 1h

# メトリクス確認
fly dashboard metrics --app hatamotohq
```

### スケーリング

```bash
# 現在のスケール設定を確認
fly scale show --app hatamotohq

# インスタンス数を変更
fly scale count 2 --app hatamotohq

# マシンサイズを変更
fly scale vm shared-cpu-1x --app hatamotohq
```

### バックアップとリストア

```bash
# データベースのバックアップ
fly postgres backups list --app hatamotohq-db

# 手動バックアップの作成
fly ssh console --app hatamotohq-db -C "pg_dump -U postgres hatamotohq_production > backup.sql"
```

### ロールバック

```bash
# リリース履歴を確認
fly releases --app hatamotohq

# 特定のバージョンにロールバック
fly deploy --app hatamotohq --image registry.fly.io/hatamotohq@sha256:[previous-sha]
```

---

## 便利なコマンド集

```bash
# アプリの再起動
fly apps restart hatamotohq

# 環境変数の追加/更新（個別）
fly secrets set KEY=value --app hatamotohq

# 環境変数の削除
fly secrets unset KEY --app hatamotohq

# IPアドレスの確認
fly ips list --app hatamotohq

# ドメインの設定
fly certs add yourdomain.com --app hatamotohq

# ローカルでFly.io環境をシミュレート
fly proxy 8080 --app hatamotohq
```

---

最終更新: 2025年1月 