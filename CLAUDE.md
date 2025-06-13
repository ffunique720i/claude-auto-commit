# Claude Auto-Commit プロジェクト

## 🎯 プロジェクト概要
Claude CLIを使用したAI駆動のGitコミットメッセージ生成ツール

## 📋 現在の状態
- ✅ 基本機能実装完了
- ✅ 多言語対応（6言語）
- ✅ 自動更新システム実装
- ✅ Cloudflare Pages対応Webサイト作成
- ✅ GitHub Actions設定
- ✅ GitHubリポジトリ公開: https://github.com/0xkaz/claude-auto-commit
- ✅ Webサイト公開: https://claude-auto-commit.0xkaz.com/

## 🚀 次のTODO

### 即座に実行
1. **v0.0.1の正式リリース**
   ```bash
   git tag v0.0.1
   git push origin v0.0.1
   ```

2. **GitHubリポジトリの最適化**
   - Aboutセクションの設定（Description、Topics）
   - Social preview画像の設定
   - README.mdへのバッジ追加

3. **ユーザー受け入れ準備**
   - Issue/PRテンプレートの作成
   - インストールスクリプトの最終動作確認
   - FAQ/トラブルシューティングの準備

### 今後の機能追加
- [ ] 他言語サポート追加（スペイン語、フランス語、アラビア語）
- [ ] プラグインシステム
- [ ] VS Code拡張機能
- [ ] GitHub Actions統合
- [ ] チーム向け機能

## 📁 プロジェクト構造
```
claude-auto-commit/
├── src/                    # メインスクリプト
├── website/                # Cloudflare Pages用
├── docs/                   # 多言語ドキュメント
├── scripts/                # インストール・ビルドスクリプト
└── .github/workflows/      # CI/CD設定
```

## 💡 開発メモ
- 自動更新は24時間ごとにチェック
- 設定ファイルは`~/.claude-auto-commit/config.yml`
- ログは`~/.claude-auto-commit/logs/`に保存
- Cloudflare Pagesは自動デプロイ設定済み
  - mainブランチへのプッシュ時に`website/`ディレクトリが自動デプロイ
  - デプロイ先: https://claude-auto-commit.0xkaz.com/

## 🐛 既知の問題
- Windows対応は未テスト
- プロキシ環境での動作確認必要

## 📅 重要日程
- 2025/6/13: プロジェクト公開予定