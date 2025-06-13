# Claude Auto-Commit

<div align="center">

![Claude Auto-Commit Hero](../images/hero-banner.png)

🤖 **Claude Code SDKを使用したAI駆動のGitコミットメッセージ生成ツール**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/releases)
[![npm version](https://img.shields.io/npm/v/claude-auto-commit.svg)](https://www.npmjs.com/package/claude-auto-commit)
[![GitHub stars](https://img.shields.io/github/stars/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/stargazers)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](https://github.com/0xkaz/claude-auto-commit)
[![Node.js](https://img.shields.io/badge/Node.js-22%2B-green.svg)](https://nodejs.org)
[![Claude Code SDK](https://img.shields.io/badge/Powered%20by-Claude%20Code%20SDK-orange.svg)](https://docs.anthropic.com/en/docs/claude-code)

</div>

**言語**: [English](../en/README.md) | [中文](../zh/README.md)

Claude Auto-Commitは、AI駆動のコミットメッセージ生成をGitワークフローに統合するオープンソースのコマンドラインツールです。コードの変更を分析し、Claude Code SDKを使用して高性能で信頼性の高い、意味のある文脈に沿ったコミットメッセージを作成します。

## 🌟 コミット履歴を変革

<div align="center">

![Before and After Comparison](../images/demo-before-after-english.png)

*曖昧なコミットメッセージにさようなら。Claude AIにコードの物語を語る意味のあるコミットを書かせましょう。*

</div>

## 🚀 クイックスタート

### インストール方法

**方法1: ワンライナーインストール（推奨）**
```bash
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/install.sh | bash
```

**方法2: NPMグローバルインストール**
```bash
npm install -g claude-auto-commit
```

**方法3: ワンタイム実行（インストール不要）**
```bash
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/run-once.sh | bash
```

### 基本的な使い方

```bash
# 変更を分析してコミットメッセージ生成
claude-auto-commit

# 日本語・絵文字・Conventional Commits形式
claude-auto-commit -l ja -e -c

# カスタムコミットタイプで自動プッシュ
claude-auto-commit -t feat --push
# コミットメッセージを生成してプッシュ
claude-auto-commit

# カスタムオプション付き
claude-auto-commit -l ja -e -t feat
```

## ✨ 機能

- 🧠 **AI駆動**: Claude CLIを使用して智的なコミットメッセージを生成
- 🌍 **多言語対応**: 日本語、英語、中国語、アラビア語、スペイン語、フランス語に対応
- 📝 **Conventional Commits**: オプションでConventional Commits形式に対応
- 🔄 **自動更新**: 毎日の自動更新（設定可能）
- 🎯 **智的分析**: コード変更、ファイルタイプ、パターンを分析
- ⚡ **高速・軽量**: 日常的な開発ワークフローに最適化
- 🛠️ **高度な設定**: 豊富なカスタマイズオプション

## 📋 要件

- Gitリポジトリ
- [Claude CLI](https://docs.anthropic.com/claude/cli) がインストール・設定済み
- Bashシェル（macOS、Linux、WSL）

## 🎯 使用例

### 基本的な使用方法
```bash
# 自動生成されたメッセージでシンプルなコミット
claude-auto-commit

# カスタムブランチと絵文字
claude-auto-commit -b develop -e

# 日本語でConventional Commits
claude-auto-commit -l ja -c -t feat

# カスタムメッセージ、プッシュなし
claude-auto-commit -m "カスタムコミットメッセージ" -n
```

### 高度なオプション
```bash
# 手動ステージングと詳細出力
claude-auto-commit -s -v

# ホットフィックス用のカスタムプレフィックス
claude-auto-commit -p "[HOTFIX]" -t fix

# ツールの更新
claude-auto-commit --update
```

## 🔧 インストール方法

### 方法1: ワンライナー（推奨）
```bash
curl -fsSL https://claude-auto-commit.0xkaz.com/install.sh | bash
```

### 方法2: 手動ダウンロード
```bash
# プラットフォーム用にダウンロード
curl -L -o claude-auto-commit https://github.com/0xkaz/claude-auto-commit/releases/latest/download/claude-auto-commit-$(uname -s)-$(uname -m)
chmod +x claude-auto-commit
sudo mv claude-auto-commit /usr/local/bin/
```

### 方法3: NPX（Node.jsユーザー向け）
```bash
npx claude-auto-commit@latest
```

## ⚙️ 設定

`~/.claude-auto-commit/config.yml`を作成：

```yaml
auto_update:
  enabled: true
  frequency: daily  # daily/weekly/manual/always
  silent: false

defaults:
  language: ja
  branch: main
  emoji: false
  conventional: false

git:
  auto_stage: true
  auto_push: true
```

## 📖 全オプション

| オプション | 説明 | デフォルト |
|-----------|------|----------|
| `-b, --branch <branch>` | プッシュ先ブランチ | `main` |
| `-l, --language <lang>` | 言語 (ja/en/zh/ar/es/fr) | `en` |
| `-e, --emoji` | 絵文字使用 | `false` |
| `-n, --no-push` | プッシュしない | `false` |
| `-s, --no-stage` | 手動ステージング | `false` |
| `-m, --message <msg>` | カスタムメッセージ | Claude生成 |
| `-t, --type <type>` | コミットタイプ | 自動 |
| `-c, --conventional` | Conventional Commits | `false` |
| `-p, --prefix <prefix>` | プレフィックス | なし |
| `-v, --verbose` | 詳細出力 | `false` |
| `--update` | 即座に更新 | - |
| `--no-update` | 今回は更新をスキップ | - |
| `--version` | バージョン表示 | - |
| `-h, --help` | ヘルプ表示 | - |

## 🌟 特徴

### 智的なコミットメッセージ生成
Claude AIがコード変更を分析し、以下を考慮してメッセージを生成：
- 変更されたファイルの種類
- 追加・修正・削除された行数
- コードの実際の差分
- プロジェクトのコンテキスト

### 多言語対応
各言語のプログラミングコミュニティの文化に適したメッセージを生成：
- **日本語**: 丁寧で詳細な説明
- **英語**: 簡潔で標準的な表現
- **中国語**: 技術的で直接的な表現

### 自動更新システム
- 毎日の自動更新チェック
- シームレスなバックグラウンド更新
- 失敗時の自動ロールバック

## 🤝 コントリビューション

コントリビューションを歓迎します！詳細は[CONTRIBUTING.md](../../CONTRIBUTING.md)をご覧ください。

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています - 詳細は[LICENSE](../../LICENSE)ファイルをご覧ください。

## 🙏 謝辞

- [Anthropic](https://anthropic.com) のClaude CLI
- [Conventional Commits](https://conventionalcommits.org) 仕様
- オープンソースコミュニティからのインスピレーション

---

**開発者コミュニティへの愛を込めて ❤️**

[問題を報告](https://github.com/0xkaz/claude-auto-commit/issues) | [機能要求](https://github.com/0xkaz/claude-auto-commit/issues/new?template=feature_request.md)