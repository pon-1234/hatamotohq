# HatamotoHQ Deployment Setup Guide

## 前提条件

1. **master.key** - ✅ 作成済み（config/master.key）
2. **LINE Bot認証情報** - 要設定
3. **Google Maps API Key** - 要設定

## 必要な認証情報の取得方法

### 1. LINE Channel認証情報

LINE Developers Console (https://developers.line.biz/console/) から取得：

1. プロバイダーとチャネルを作成
2. Messaging API設定から以下を取得：
   - **Channel Secret**: 「チャネル基本設定」タブ
   - **Channel Access Token**: 「Messaging API設定」タブで発行

### 2. Google Maps API Key

Google Cloud Console (https://console.cloud.google.com/) から取得：

1. プロジェクトを作成または選択
2. 「APIとサービス」→「認証情報」
3. 「認証情報を作成」→「APIキー」
4. 必要なAPI（Maps JavaScript API等）を有効化

## 環境変数の設定

`.env`ファイルの以下の値を実際の認証情報に置き換えてください：

```bash
# LINE Bot認証情報
LINE_CHANNEL_SECRET=YOUR_LINE_CHANNEL_SECRET  # 実際のChannel Secretに置き換え
LINE_CHANNEL_TOKEN=YOUR_LINE_CHANNEL_TOKEN    # 実際のChannel Access Tokenに置き換え

# Google Maps API
VITE_GOOGLE_MAP_KEY=YOUR_GOOGLE_MAPS_API_KEY # 実際のAPI Keyに置き換え
```

## デプロイ手順

すべての認証情報を設定したら：

```bash
# デプロイスクリプトを実行
./fly-deploy.sh
```

## 重要な注意事項

- **master.key**は絶対に他人と共有しないでください
- `.env`ファイルはGitにコミットしないでください（.gitignoreに含まれています）
- 本番環境の認証情報は開発環境とは別に管理してください

## トラブルシューティング

### master.keyエラーの場合
```bash
# 既存のmaster.keyを削除して再作成
rm config/master.key
openssl rand -hex 16 > config/master.key
chmod 600 config/master.key
```

### 環境変数が読み込まれない場合
```bash
# Fly.ioのシークレットとして設定
fly secrets set LINE_CHANNEL_SECRET="your-secret"
fly secrets set LINE_CHANNEL_TOKEN="your-token"
fly secrets set VITE_GOOGLE_MAP_KEY="your-api-key"
```