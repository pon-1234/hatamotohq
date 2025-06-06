# Fly.ioデプロイ手順

このドキュメントでは、Ruby on RailsアプリケーションをFly.ioにデプロイする手順を説明します。

## 前提条件

1. [Fly.io CLI](https://fly.io/docs/hands-on/install-flyctl/)がインストールされていること
2. Fly.ioアカウントが作成されていること

## 1. Fly CLIのインストールと認証

```bash
# Fly CLIのインストール（macOS）
brew install flyctl

# Fly.ioにログイン
fly auth login
```

## 2. アプリケーションの初期化

```bash
# Fly.ioアプリを作成（プロジェクトルートで実行）
fly apps create hatamotohq

# または既存の設定を使用
fly launch --no-deploy
```

## 3. データベースの設定

### PostgreSQLを使用する場合（推奨）

```bash
# Fly.io PostgreSQLクラスターを作成
fly postgres create --name hatamotohq-db

# データベースをアプリにアタッチ
fly postgres attach --app hatamotohq hatamotohq-db
```

### 外部MySQLを使用する場合

PlanetScaleやAWS RDSなどの外部MySQLサービスを使用することも可能です。

## 4. Redisの設定（Sidekiq用）

```bash
# Fly.io Redisを作成
fly redis create --name hatamotohq-redis

# Redisをアプリにアタッチ
fly redis attach --app hatamotohq hatamotohq-redis
```

## 5. 環境変数の設定

`.fly.env.example`を参考に、必要な環境変数を設定してください：

```bash
# 例：SECRET_KEY_BASEの設定
fly secrets set SECRET_KEY_BASE=$(bundle exec rails secret)

# Rails Master Keyの設定（config/master.keyから）
fly secrets set RAILS_MASTER_KEY=your_master_key_here

# LINE Bot APIの設定
fly secrets set LINE_CHANNEL_SECRET=your_line_channel_secret
fly secrets set LINE_CHANNEL_TOKEN=your_line_channel_token

# AWS S3の設定
fly secrets set AWS_ACCESS_KEY_ID=your_aws_access_key
fly secrets set AWS_SECRET_ACCESS_KEY=your_aws_secret_key
fly secrets set AWS_REGION=your_aws_region
fly secrets set AWS_BUCKET=your_s3_bucket_name

# Sentryの設定
fly secrets set SENTRY_DSN=your_sentry_dsn

# FCMの設定
fly secrets set FCM_SERVER_KEY=your_fcm_server_key
```

## 6. ボリュームの作成（必要に応じて）

```bash
# データ永続化用のボリュームを作成
fly volumes create data --region nrt --size 1
```

## 7. デプロイの実行

```bash
# 初回デプロイ
fly deploy

# デプロイ状況の確認
fly status

# ログの確認
fly logs
```

## 8. データベースマイグレーション

```bash
# マイグレーションの実行
fly ssh console --app hatamotohq -C "bundle exec rails db:migrate"

# シードデータの投入（必要に応じて）
fly ssh console --app hatamotohq -C "bundle exec rails db:seed"
```

## 9. Sidekiqワーカーの設定

`fly.toml`でワーカープロセスが設定されています。必要に応じてワーカーのスケーリングを行ってください：

```bash
# ワーカープロセスのスケーリング
fly scale count worker=1
```

## 10. カスタムドメインの設定

```bash
# カスタムドメインの追加
fly certs create your-domain.com

# DNS設定の確認
fly certs show your-domain.com
```

## トラブルシューティング

### ログの確認

```bash
# リアルタイムログの確認
fly logs

# 特定のプロセスのログ
fly logs --app hatamotohq --process app
```

### SSH接続

```bash
# コンテナにSSH接続
fly ssh console

# Railsコンソールの起動
fly ssh console -C "bundle exec rails console"
```

### パフォーマンス監視

```bash
# メトリクスの確認
fly metrics

# アプリの状態確認
fly status
```

## 設定ファイルの説明

- `fly.toml`: Fly.ioの設定ファイル
- `Dockerfile`: コンテナイメージのビルド設定
- `.fly.env.example`: 環境変数の設定例

## 注意事項

1. 本番環境では適切なリソース（CPU、メモリ）を設定してください
2. データベースバックアップを定期的に取得してください
3. セキュリティのため、すべての秘密情報は`fly secrets`で管理してください
4. アプリケーションの監視とログ分析を設定してください

## サポート

- [Fly.io公式ドキュメント](https://fly.io/docs/)
- [Ruby on Rails on Fly.io](https://fly.io/docs/rails/) 