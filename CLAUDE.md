# Claude Auto-Commit プロジェクト

## 🎯 プロジェクト概要
Claude Code SDKを使用したAI駆動のGitコミットメッセージ生成ツール

## 📋 現在の状態
- ✅ v0.1.0 SDK版リリース完了
- ✅ Claude CLI → Claude Code SDK 完全移行
- ✅ パフォーマンス大幅改善（並列処理・キャッシュ）
- ✅ 新機能追加（テンプレート・設定ファイル・ワンライナー実行）
- ✅ エラーハンドリング強化
- ✅ NPMパッケージサポート
- ✅ 多言語対応（英語・日本語）
- ✅ GitHubリポジトリ公開: https://github.com/0xkaz/claude-auto-commit

## 🚀 次のTODO

### v0.1.0 完了事項
- ✅ Claude Code SDK完全移行
- ✅ パフォーマンス最適化
- ✅ 新機能実装（テンプレート・設定・ワンライナー）
- ✅ NPMパッケージ化対応

### 今後のバージョン
- [ ] v0.1.1: NPM公開・パッケージ最適化
- [ ] v0.2.0: VS Code拡張機能
- [ ] v0.3.0: GitHub Actions統合
- [ ] v1.0.0: プラグインシステム・企業向け機能

### 技術的改善
- [ ] TypeScript完全対応
- [ ] テストスイート拡充
- [ ] CI/CDパイプライン強化
- [ ] ドキュメント自動生成

## 📁 プロジェクト構造
```
claude-auto-commit/
├── src/
│   ├── claude-auto-commit.js    # 🆕 メインSDKスクリプト
│   └── claude-auto-commit.sh    # ⚠️  旧CLIスクリプト（非推奨・移行期間のみ）
├── bin/
│   └── claude-auto-commit       # 実行可能ファイル（JS版）
├── scripts/
│   ├── install.sh              # ワンライナーインストーラー
│   └── run-once.sh             # ワンタイム実行スクリプト
├── docs/                       # 多言語ドキュメント
├── package.json                # NPMパッケージ設定
└── CHANGELOG.md                # バージョン履歴
```

## 💡 技術仕様
- **Runtime**: Node.js 22.0.0+, ES Modules
- **SDK**: @anthropic-ai/claude-code ^1.0.22
- **設定ファイル**: `~/.claude-auto-commit/config.json`
- **テンプレート**: `~/.claude-auto-commit/templates/`
- **パフォーマンス**: 並列処理、インテリジェントキャッシュ

## 🔄 インストール方式
1. **ワンライナー** (推奨): スクリプトベース、自動セットアップ
2. **NPM Global**: `npm install -g claude-auto-commit`
3. **ワンタイム実行**: インストール不要、一回のみ実行

## 🚨 CLI版廃止スケジュール

### v0.1.0（現在）: 両方サポート + 非推奨警告
- ✅ **src/claude-auto-commit.js**: メイン推奨版（SDK）
- ⚠️ **src/claude-auto-commit.sh**: レガシー版（CLI）+ 起動時警告表示
- 🎯 **目的**: 既存ユーザーの段階的移行
- 📢 **警告内容**: 性能差、新機能、移行手順、削除予定日

### v0.2.0（予定）: CLI版完全削除
- ❌ **src/claude-auto-commit.sh**: 削除
- 📋 **移行ガイド**: 完全移行の手順提供
- 🎯 **目的**: 技術的負債の解消、メンテナンス負荷軽減

## 📅 リリース履歴
- 2025/6/14: v0.1.0 SDK版リリース
- 2025/6/13: v0.0.5 CLI版（最終）