# 必要な環境変数リスト

## 必須の環境変数

### Rails関連
- `RAILS_MASTER_KEY` - config/master.keyの内容（必須）
- `DATABASE_URL` - Fly.ioが自動設定
- `REDIS_URL` - Fly.ioが自動設定
- `RAILS_SERVE_STATIC_FILES` - true
- `RAILS_LOG_TO_STDOUT` - true

### フロントエンド関連（VITE）
- `VITE_ROOT_PATH` - アプリケーションのベースURL（例: https://hatamotohq.fly.dev）
- `VITE_GOOGLE_MAP_KEY` - Google Maps APIキー（必須）
- `VITE_WS_FLEXA_URL` - WebSocketのURL（例: wss://hatamotohq.fly.dev）
- `VITE_SERVEY_MEDIA_FLEXA_URL` - メディアサーバーのURL（例: https://hatamotohq.fly.dev）

### LINE Bot関連（必須）
- `LINE_CHANNEL_SECRET` - LINE Messaging APIのChannel Secret
- `LINE_CHANNEL_TOKEN` - LINE Messaging APIのChannel Access Token

### オプション
- `SENTRY_DSN` - Sentryのエラートラッキング用（任意）
- `GOOGLE_OAUTH_CLIENT_ID` - Google OAuth用（任意）

## 環境変数の設定コマンド

```bash
# 必須の環境変数を設定
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
```

## 確認方法

```bash
# 設定された環境変数を確認
fly secrets list --app hatamotohq

# 特定の環境変数が設定されているか確認（値は表示されない）
fly ssh console --app hatamotohq -C "printenv | grep VITE_"
```