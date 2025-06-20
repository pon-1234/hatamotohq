# HatamotoHQ Fly.ioデプロイガイド

## 前提条件

1. **Fly CLIのインストール**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **master.keyの準備**
   - `config/master.key`が存在することを確認
   - 存在しない場合は、他の開発者から取得するか、新しく作成

3. **必要な認証情報の準備**
   - LINE Channel Secret
   - LINE Channel Access Token
   - Google Maps API Key

## 自動デプロイスクリプトの使用（推奨）

```bash
# デプロイスクリプトを実行
./fly-deploy.sh
```

このスクリプトは以下を自動で実行します：
- Fly.ioアプリの作成
- PostgreSQLとRedisの作成・アタッチ
- ストレージボリュームの作成
- 基本的な環境変数の設定
- アプリケーションのデプロイ

## 手動デプロイ手順

### 1. Fly.ioにログイン
```bash
fly auth login
```

### 2. アプリケーションの作成
```bash
fly apps create hatamotohq --org personal
```

### 3. PostgreSQLの作成とアタッチ
```bash
fly postgres create --name hatamotohq-db --region nrt
fly postgres attach hatamotohq-db --app hatamotohq
```

### 4. Redisの作成とアタッチ
```bash
fly redis create --name hatamotohq-redis --region nrt
```

### 5. ストレージボリュームの作成
```bash
fly volumes create hatamotohq_storage --size 10 --region nrt --app hatamotohq
```

### 6. 環境変数の設定
```bash
# 必須の環境変数
fly secrets set \
  RAILS_MASTER_KEY=$(cat config/master.key) \
  VITE_ROOT_PATH=https://hatamotohq.fly.dev \
  VITE_GOOGLE_MAP_KEY=<YOUR_GOOGLE_MAP_KEY> \
  VITE_WS_FLEXA_URL=wss://hatamotohq.fly.dev \
  VITE_SERVEY_MEDIA_FLEXA_URL=https://hatamotohq.fly.dev \
  LINE_CHANNEL_SECRET=<YOUR_LINE_CHANNEL_SECRET> \
  LINE_CHANNEL_TOKEN=<YOUR_LINE_CHANNEL_TOKEN> \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_LOG_TO_STDOUT=true \
  --app hatamotohq
```

### 7. デプロイの実行
```bash
fly deploy --app hatamotohq
```

## デプロイ後の確認

### アプリケーションの状態確認
```bash
fly status --app hatamotohq
```

### ログの確認
```bash
fly logs --app hatamotohq
```

### アプリケーションを開く
```bash
fly open --app hatamotohq
```

### SSHアクセス（トラブルシューティング用）
```bash
fly ssh console --app hatamotohq
```

## トラブルシューティング

### ヘルスチェックが失敗する場合
1. `/health`エンドポイントが正しく動作しているか確認
2. データベースとRedisの接続を確認

### アセットが読み込まれない場合
1. `RAILS_SERVE_STATIC_FILES=true`が設定されているか確認
2. Viteのビルドが成功しているか確認

### データベース接続エラー
1. `DATABASE_URL`が自動で設定されているか確認
   ```bash
   fly ssh console --app hatamotohq -C "printenv DATABASE_URL"
   ```

### 500エラーが発生する場合
1. `RAILS_MASTER_KEY`が正しく設定されているか確認
2. ログを確認して詳細なエラーメッセージを確認

## メンテナンス

### データベースのバックアップ
```bash
fly postgres backup list --app hatamotohq-db
```

### スケーリング
```bash
# インスタンス数を増やす
fly scale count 2 --app hatamotohq

# マシンスペックを変更
fly scale vm shared-cpu-2x --app hatamotohq
```

### 環境変数の更新
```bash
fly secrets set KEY=value --app hatamotohq
```

## CI/CDの設定

GitHub Actionsを使用した自動デプロイについては、`.github/workflows/deploy.yml`を参照してください。