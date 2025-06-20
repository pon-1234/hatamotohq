# Fly.ioデプロイに向けた必須タスクリスト

## 🎉 完了したタスク

### ✅ デプロイを妨げる重大な問題（すべて解決済み）

1. **データベース設定** - 既にPostgreSQLを使用していることを確認
2. **Vue 3フィルター** - 既に正しく実装されていることを確認
3. **環境変数の管理**
   - `.env.ci`をGitから削除し`.gitignore`に追加
   - すべての`MIX_`プレフィックスを`VITE_`に変更（170箇所以上）
   - 環境変数ファイル（.env, .env.example等）も更新
4. **セッションストアのセキュリティ** - 本番環境で`secure: true`が設定されるよう修正

### ✅ 推奨される改善タスク（すべて完了）

5. **fly.tomlとDockerfileの設定**
   - ポート番号を8080に統一
   - Viteビルドコマンドに更新
   - docker-entrypoint.shを修正
6. **不要なファイルのクリーンアップ**
   - バックアップファイル（.bak, .backup）を削除
   - `rails_server.log`を`.gitignore`に追加
7. **アセットパイプラインの整理**
   - Viteにスタイルシートを統合
   - すべてのレイアウトファイルで`vite_stylesheet_tag`を使用
   - 不要なCSSビルドスクリプトを削除

### ✅ 最終確認と修正（フィードバック対応）

8. **データベース設定の最終確認**
   - Gemfileに`gem 'pg'`が存在し、mysql2が無いことを確認済み
   - `config/database.yml.ci`をPostgreSQLに修正済み
9. **ビルド済みアセットの対応**
   - `/public/app/assets/builds`を`.gitignore`に追加
   - Gitトラッキングから削除済み（200+ファイル）
10. **Dockerfileの最適化**
   - bundle installとyarn installが適切に実行されることを確認
   - 不要なbuild:cssコマンドを削除

---

# Fly.ioデプロイに向けた必須タスクリスト

## 🚨 デプロイを妨げる重大な問題（最優先）

### 1. データベース設定の不整合の解決
- [ ] 使用するデータベースをPostgreSQLに決定
- [ ] Gemfileに`gem 'pg'`を追加し、`gem 'mysql2'`を削除
- [ ] `bundle install`を実行
- [ ] `config/database.yml`のproductionとstagingのadapterを`postgresql`に変更
- [ ] `db/migrate/`内のマイグレーションファイルでMySQL固有のSQL記述を確認
- [ ] MySQL固有のSQL記述をPostgreSQL互換に修正

### 2. Vue 2からVue 3への移行完了
- [ ] `app/javascript/src/filters/index.js`のVue 2グローバルフィルターを確認
- [ ] Vue 3のグローバルプロパティまたはProvide/Inject方式に書き換え
- [ ] Vue 2時代の非互換コードをすべて特定し修正
- [ ] フロントエンドのビルドが正常に完了することを確認

### 3. 環境変数の管理とセキュリティ改善
- [ ] `.env.ci`を`.gitignore`に追加
- [ ] `.env.ci`をリポジトリから削除
- [ ] GitHub ActionsのSecretsにCI用環境変数を設定
- [ ] `process.env.MIX_ROOT_PATH`を`import.meta.env.VITE_ROOT_PATH`に変更
- [ ] その他のMIX_プレフィックス環境変数をVITE_プレフィックスに統一

### 4. セッションストアのセキュリティ設定修正
- [ ] `config/initializers/session_store.rb`のコメントアウトを解除
- [ ] 本番環境で`secure: true`が設定されるように修正
- [ ] HTTPSでのセッションCookie送信を確保

## 📋 推奨される改善タスク

### 5. アセットパイプラインの整理
- [ ] `app/assets/stylesheets`と`app/javascript/stylesheets`の重複を確認
- [ ] スタイルシートを`app/javascript`ディレクトリに一本化
- [ ] 不要なスタイルシートファイルを削除
- [ ] Viteの設定でスタイルシートのインポートパスを更新

### 6. 不要なファイルのクリーンアップ
- [ ] `.github/workflows/dep_dev.yml.bak`を削除
- [ ] `.github/workflows/dep_stg.yml.bak`を削除
- [ ] `package.json.backup`を削除
- [ ] `rails_server.log`を`.gitignore`に追加
- [ ] その他のバックアップファイルやログファイルを特定し削除

### 7. fly.tomlの設定確認
- [ ] `[processes]`セクションでwebプロセス（Puma）が定義されているか確認
- [ ] `[processes]`セクションでworkerプロセス（Sidekiq）が定義されているか確認
- [ ] `[deploy]`セクションで`release_command = "bundle exec rails db:migrate"`が設定されているか確認
- [ ] `[env]`セクションで以下の環境変数が設定されているか確認：
  - [ ] `RAILS_ENV=production`
  - [ ] `RAILS_SERVE_STATIC_FILES=true`
  - [ ] `RAILS_LOG_TO_STDOUT=true`
- [ ] PostgreSQLアドオンの設定を確認
- [ ] Redisアドオンの設定を確認

### 8. Dockerfileの設定確認
- [ ] ベースイメージのRubyバージョンが3.3.6と一致しているか確認
- [ ] Node.jsがインストールされているか確認
- [ ] Yarnがインストールされているか確認
- [ ] `bundle install`が実行されているか確認
- [ ] `yarn install`または`npm install`が実行されているか確認
- [ ] `vite build`が実行されているか確認

### 9. テストの拡充とCI/CDの改善
- [ ] pendingのテストケースを実装または削除
- [ ] 空のテストファイルを実装または削除
- [ ] リクエストスペックを拡充
- [ ] GitHub ActionsでRSpecを実行するワークフローを設定
- [ ] デプロイ前にテストが成功することを必須にする

## 🔄 デプロイ前の最終確認

### 10. ローカル環境での動作確認
- [ ] PostgreSQLでのローカル環境構築
- [ ] `rails db:create db:migrate db:seed`が正常に動作することを確認
- [ ] `foreman start -f Procfile.dev`で開発サーバーが起動することを確認
- [ ] フロントエンドが正常に表示されることを確認

### 11. デプロイテスト
- [ ] `fly deploy`をdry-runモードで実行
- [ ] エラーがないことを確認
- [ ] 実際にデプロイを実行
- [ ] デプロイ後のヘルスチェックが成功することを確認

## 優先度の目安

1. **最高優先度**: タスク1-4（これらを解決しないとデプロイ不可）
2. **高優先度**: タスク7-8（Fly.io固有の設定）
3. **中優先度**: タスク5-6, 10（品質向上）
4. **低優先度**: タスク9（長期的な改善）

各タスクの完了時には、動作確認を行い、問題がないことを確認してから次のタスクに進んでください。