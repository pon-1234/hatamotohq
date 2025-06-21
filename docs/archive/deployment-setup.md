# Fly.ioデプロイセットアップ手順

## 🚨 重要な問題: master.keyが見つかりません

Rails credentialsを使用するには`config/master.key`が必要ですが、現在存在しません。

### 対処方法

#### オプション1: 既存のmaster.keyを取得
もし他の開発者やバックアップからmaster.keyを取得できる場合：
```bash
# master.keyを作成（32文字の16進数文字列）
echo "YOUR_MASTER_KEY_HERE" > config/master.key
chmod 600 config/master.key
```

#### オプション2: 新しいcredentialsを作成
既存のmaster.keyが取得できない場合：
```bash
# 既存のcredentials.yml.encを削除
rm config/credentials.yml.enc

# 新しいcredentialsとmaster.keyを生成
EDITOR="vim" rails credentials:edit

# 以下の内容を追加して保存
# secret_key_base: <自動生成される>
# その他必要な設定...
```

## Fly.ioアプリの作成（まだ作成していない場合）

```bash
# Fly.ioにログイン
fly auth login

# アプリを作成
fly apps create hatamotohq --org personal

# PostgreSQLデータベースを作成
fly postgres create --name hatamotohq-db --region nrt

# データベースをアプリにアタッチ
fly postgres attach hatamotohq-db --app hatamotohq

# Redisを作成
fly redis create --name hatamotohq-redis --region nrt

# Redisをアプリにアタッチ
fly redis attach hatamotohq-redis --app hatamotohq
```

## 環境変数の設定

```bash
# master.keyが存在することを確認してから実行
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key) --app hatamotohq

# アプリケーションのURL（デプロイ後に実際のURLに更新）
fly secrets set VITE_ROOT_PATH=https://hatamotohq.fly.dev --app hatamotohq

# その他の環境変数（必要に応じて実際の値に置き換え）
fly secrets set VITE_GOOGLE_MAP_KEY=your-google-map-key --app hatamotohq
fly secrets set VITE_WS_FLEXA_URL=wss://hatamotohq.fly.dev --app hatamotohq
fly secrets set VITE_SERVEY_MEDIA_FLEXA_URL=https://hatamotohq.fly.dev --app hatamotohq

# LINE Bot関連の環境変数（必須）
fly secrets set LINE_CHANNEL_SECRET=your-line-channel-secret --app hatamotohq
fly secrets set LINE_CHANNEL_TOKEN=your-line-channel-token --app hatamotohq

# その他の必要な環境変数
fly secrets set RAILS_SERVE_STATIC_FILES=true --app hatamotohq
fly secrets set RAILS_LOG_TO_STDOUT=true --app hatamotohq

# 設定した環境変数を確認
fly secrets list --app hatamotohq
```

## ボリュームの作成（Active Storage用）

```bash
fly volumes create hatamotohq_storage --size 10 --region nrt --app hatamotohq
```

## デプロイの実行

```bash
# ドライラン（実際にはデプロイしない）
fly deploy --dry-run --app hatamotohq

# 問題がなければ実際にデプロイ
fly deploy --app hatamotohq

# デプロイの進行状況を確認
fly logs --app hatamotohq

# アプリの状態を確認
fly status --app hatamotohq
```

## デプロイ後の確認

```bash
# アプリを開く
fly open --app hatamotohq

# コンソールに接続して動作確認
fly ssh console --app hatamotohq
```

## トラブルシューティング

### ヘルスチェックが失敗する場合
```bash
# アプリのログを確認
fly logs --app hatamotohq

# SSHで接続して手動で起動を試みる
fly ssh console --app hatamotohq
cd /rails
bundle exec rails console
```

### データベース接続エラーの場合
```bash
# DATABASE_URLが正しく設定されているか確認
fly ssh console --app hatamotohq -C "printenv DATABASE_URL"

# データベースに直接接続
fly postgres connect --app hatamotohq-db
```