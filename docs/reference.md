# Auto Commit Tool

このプロジェクトには、Claude CLIを活用した自動コミットツールが含まれています。

## 基本使用方法

```bash
# 基本実行（元のauto-commit.shと同じ動作）
./auto-commit.sh

# 短縮版
./ac
```

## 高度なオプション

```bash
# 開発ブランチにプッシュ
./auto-commit.sh -b develop

# 英語でConventional Commits形式
./auto-commit.sh -l en -c -t feat

# カスタムメッセージでプッシュなし
./auto-commit.sh -m "Fix critical bug" -n

# 手動ステージング + 詳細出力
./auto-commit.sh -s -v

# 絵文字付き
./auto-commit.sh -e

# プレフィックス付き
./auto-commit.sh -p "[HOTFIX]"
```

## 全オプション

| オプション | 説明 | デフォルト |
|-----------|------|----------|
| `-b, --branch` | プッシュ先ブランチ | `main` |
| `-l, --language` | 言語 (ja/en) | `ja` |
| `-e, --emoji` | 絵文字使用 | `false` |
| `-n, --no-push` | プッシュしない | `false` |
| `-s, --no-stage` | 手動ステージング | `false` |
| `-m, --message` | カスタムメッセージ | Claude生成 |
| `-t, --type` | コミットタイプ | 自動 |
| `-c, --conventional` | Conventional Commits | `false` |
| `-p, --prefix` | プレフィックス | なし |
| `-v, --verbose` | 詳細出力 | `false` |
| `-h, --help` | ヘルプ表示 | - |

## 機能

- ✅ Claude CLIによる智的なコミットメッセージ生成
- ✅ 変更がない場合の自動終了
- ✅ ステージング済み/未ステージングの区別
- ✅ 複数言語対応
- ✅ Conventional Commits対応
- ✅ 手動ステージング選択
- ✅ メッセージ編集機能
- ✅ 柔軟なブランチ指定
- ✅ カスタムプレフィックス

## 使用例

### 日常的な開発
```bash
./ac  # 最もシンプル
```

### フィーチャー開発
```bash
./ac -b feature/new-api -t feat -e
```

### バグ修正
```bash
./ac -t fix -c -l en
```

### ホットフィックス
```bash
./ac -p "[HOTFIX]" -b main
```