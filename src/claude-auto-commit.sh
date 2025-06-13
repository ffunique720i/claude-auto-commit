#!/bin/bash

# Claude Auto-Commit - AI-powered Git commit message generator
# Version: 1.0.0
# Homepage: https://claude-auto-commit.0xkaz.com

VERSION="1.0.0"
REPO="0xkaz/claude-auto-commit"
CONFIG_DIR="$HOME/.claude-auto-commit"
CONFIG_FILE="$CONFIG_DIR/config.yml"
LAST_CHECK_FILE="$CONFIG_DIR/last-check"

# デフォルト設定
DEFAULT_BRANCH="main"
DEFAULT_LANGUAGE="en"
MAX_DIFF_LINES=500
USE_EMOJI=false
AUTO_PUSH=true
AUTO_STAGE=true
VERBOSE=false
AUTO_UPDATE=true
UPDATE_FREQUENCY="daily"

# 使用方法を表示
usage() {
    cat << EOF
使用方法: $(basename $0) [オプション]

オプション:
    -b, --branch <branch>      プッシュ先のブランチ (デフォルト: main)
    -l, --language <lang>      コミットメッセージの言語 (ja/en, デフォルト: ja)
    -e, --emoji                絵文字を使用する
    -n, --no-push              プッシュしない
    -s, --no-stage             自動ステージングしない（手動で選択）
    -d, --diff-lines <num>     差分表示の最大行数 (デフォルト: 500)
    -m, --message <msg>        カスタムコミットメッセージを使用
    -t, --type <type>          コミットタイプを指定 (feat/fix/docs/style/refactor/test/chore)
    -v, --verbose              詳細な出力を表示
    -c, --conventional         Conventional Commits形式を使用
    -p, --prefix <prefix>      カスタムプレフィックス（例: [WIP], [HOTFIX]）
    --update                   今すぐ更新チェック
    --no-update                今回は更新をスキップ
    --version                  バージョン情報を表示
    -h, --help                 このヘルプを表示

例:
    $(basename $0) -b develop -e -t feat
    $(basename $0) -m "カスタムメッセージ" -n
    $(basename $0) -c -t fix -l en
EOF
}

# 色付き出力用の関数
print_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

# 設定読み込み
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # YAML解析（簡易版）
        AUTO_UPDATE=$(grep -A 3 "auto_update:" "$CONFIG_FILE" | grep "enabled:" | sed 's/.*enabled:[[:space:]]*//' | tr -d '"')
        UPDATE_FREQUENCY=$(grep -A 3 "auto_update:" "$CONFIG_FILE" | grep "frequency:" | sed 's/.*frequency:[[:space:]]*//' | tr -d '"')
        DEFAULT_LANGUAGE=$(grep -A 5 "defaults:" "$CONFIG_FILE" | grep "language:" | sed 's/.*language:[[:space:]]*//' | tr -d '"')
        
        # デフォルト値設定
        AUTO_UPDATE=${AUTO_UPDATE:-true}
        UPDATE_FREQUENCY=${UPDATE_FREQUENCY:-daily}
        DEFAULT_LANGUAGE=${DEFAULT_LANGUAGE:-en}
    fi
}

# 最新バージョン取得
get_latest_version() {
    curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'
}

# バージョン比較
version_gt() {
    [ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ]
}

# 更新チェック
check_for_updates() {
    [ "$AUTO_UPDATE" = "false" ] && return 0
    
    # 前回チェック時刻を確認
    local now=$(date +%s)
    local last_check=0
    
    if [ -f "$LAST_CHECK_FILE" ]; then
        last_check=$(cat "$LAST_CHECK_FILE" 2>/dev/null || echo 0)
    fi
    
    local check_interval=86400  # 1日 (デフォルト)
    case $UPDATE_FREQUENCY in
        always) check_interval=0 ;;
        daily) check_interval=86400 ;;
        weekly) check_interval=604800 ;;
        manual) return 0 ;;
    esac
    
    if [ $((now - last_check)) -lt $check_interval ]; then
        return 0
    fi
    
    # 最新バージョンをチェック
    local latest_version=$(get_latest_version)
    if [ -z "$latest_version" ]; then
        return 0
    fi
    
    # チェック時刻を記録
    echo "$now" > "$LAST_CHECK_FILE"
    
    if version_gt "$latest_version" "$VERSION"; then
        print_info "New version available: v$latest_version (current: v$VERSION)"
        print_info "Updating automatically..."
        
        if update_binary "$latest_version"; then
            print_success "Update completed! Restarting with new version..."
            exec "$0" "$@"
        else
            print_warning "Update failed. Continuing with current version..."
        fi
    fi
}

# バイナリ更新
update_binary() {
    local new_version="$1"
    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/')
    local url="https://github.com/$REPO/releases/download/v$new_version/claude-auto-commit-$platform"
    local current_binary=$(which claude-auto-commit 2>/dev/null || echo "$0")
    
    # 一時ファイルにダウンロード
    local tmp_file=$(mktemp)
    
    if curl -L -s -o "$tmp_file" "$url" 2>/dev/null; then
        chmod +x "$tmp_file"
        
        # バックアップ作成
        cp "$current_binary" "$current_binary.backup"
        
        # 更新実行
        if mv "$tmp_file" "$current_binary" 2>/dev/null || sudo mv "$tmp_file" "$current_binary" 2>/dev/null; then
            return 0
        else
            # 失敗時はバックアップから復元
            mv "$current_binary.backup" "$current_binary" 2>/dev/null
            rm -f "$tmp_file"
            return 1
        fi
    else
        rm -f "$tmp_file"
        return 1
    fi
}

# オプション解析
BRANCH=$DEFAULT_BRANCH
LANGUAGE=$DEFAULT_LANGUAGE
CUSTOM_MESSAGE=""
COMMIT_TYPE=""
CONVENTIONAL_COMMITS=false
PREFIX=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -l|--language)
            LANGUAGE="$2"
            shift 2
            ;;
        -e|--emoji)
            USE_EMOJI=true
            shift
            ;;
        -n|--no-push)
            AUTO_PUSH=false
            shift
            ;;
        -s|--no-stage)
            AUTO_STAGE=false
            shift
            ;;
        -d|--diff-lines)
            MAX_DIFF_LINES="$2"
            shift 2
            ;;
        -m|--message)
            CUSTOM_MESSAGE="$2"
            shift 2
            ;;
        -t|--type)
            COMMIT_TYPE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -c|--conventional)
            CONVENTIONAL_COMMITS=true
            shift
            ;;
        -p|--prefix)
            PREFIX="$2"
            shift 2
            ;;
        --update)
            # 強制更新
            AUTO_UPDATE=true
            UPDATE_FREQUENCY="always"
            shift
            ;;
        --no-update)
            # 今回は更新スキップ
            AUTO_UPDATE=false
            shift
            ;;
        --version)
            echo "Claude Auto-Commit v$VERSION"
            echo "Homepage: https://claude-auto-commit.0xkaz.com"
            exit 0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            print_error "不明なオプション: $1"
            usage
            exit 1
            ;;
    esac
done

# 設定ディレクトリ作成
mkdir -p "$CONFIG_DIR"

# 設定読み込み
load_config

# 自動更新チェック
check_for_updates "$@"

# Git リポジトリかチェック
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Gitリポジトリではありません"
    exit 1
fi

# 現在のブランチを取得
CURRENT_BRANCH=$(git branch --show-current)
print_info "現在のブランチ: $CURRENT_BRANCH"

# 変更内容のサマリを生成
print_info "変更内容を解析中..."

# ステージング済みとステージング前の変更を区別して取得
STAGED_COUNT=$(git diff --cached --name-only | wc -l)
UNSTAGED_COUNT=$(git diff --name-only | wc -l)
UNTRACKED_COUNT=$(git ls-files --others --exclude-standard | wc -l)

TOTAL_CHANGES=$((STAGED_COUNT + UNSTAGED_COUNT + UNTRACKED_COUNT))

# 変更がない場合は終了
if [ "$TOTAL_CHANGES" -eq 0 ]; then
    print_info "変更されたファイルがありません。コミットする内容がないため終了します。"
    exit 0
fi

# 変更内容を表示
print_info "変更サマリ:"
echo "  ステージング済み: $STAGED_COUNT ファイル"
echo "  未ステージング: $UNSTAGED_COUNT ファイル"
echo "  未追跡: $UNTRACKED_COUNT ファイル"

# 手動ステージングモードの場合
if [ "$AUTO_STAGE" = false ]; then
    print_warning "手動ステージングモードです。git add -i を実行します..."
    git add -i
    
    # ステージング後の状態を再確認
    STAGED_COUNT=$(git diff --cached --name-only | wc -l)
    if [ "$STAGED_COUNT" -eq 0 ]; then
        print_error "ステージングされたファイルがありません"
        exit 1
    fi
fi

# カスタムメッセージが指定されていない場合はClaude CLIで生成
if [ -z "$CUSTOM_MESSAGE" ]; then
    # 変更内容の詳細を取得して一時ファイルに保存
    TEMP_FILE=$(mktemp)
    {
        echo "=== Git Status ==="
        git status --short
        echo ""
        echo "=== Changed Files Summary ==="
        echo "Staged: $STAGED_COUNT, Unstaged: $UNSTAGED_COUNT, Untracked: $UNTRACKED_COUNT"
        echo ""
        
        # 変更されたファイルの種類を分析
        echo "=== File Types Analysis ==="
        git diff --cached --name-only | rev | cut -d'.' -f1 | rev | sort | uniq -c | sort -rn
        echo ""
        
        # 差分の統計情報
        echo "=== Diff Statistics ==="
        git diff --cached --stat
        echo ""
        
        # 実際の差分（指定行数まで）
        if [ "$VERBOSE" = true ]; then
            echo "=== Actual Changes (first $MAX_DIFF_LINES lines) ==="
            git diff --cached --no-color | head -n $MAX_DIFF_LINES
        fi
    } > "$TEMP_FILE"

    # プロンプトの言語設定
    if [ "$LANGUAGE" = "en" ]; then
        PROMPT="Generate an appropriate commit message in English based on the following Git changes.
The commit message should be concise and capture the essence of the changes."
    else
        PROMPT="以下のGit変更内容から、適切な日本語のコミットメッセージを生成してください。
コミットメッセージは簡潔で、変更の本質を表すものにしてください。"
    fi

    # 絵文字設定
    if [ "$USE_EMOJI" = true ]; then
        PROMPT="$PROMPT
Please use appropriate emoji at the beginning of the message."
    else
        PROMPT="$PROMPT
絵文字は使用しないでください。"
    fi

    # Conventional Commits形式
    if [ "$CONVENTIONAL_COMMITS" = true ]; then
        PROMPT="$PROMPT

Use Conventional Commits format:
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore"
    fi

    # コミットタイプが指定されている場合
    if [ -n "$COMMIT_TYPE" ]; then
        PROMPT="$PROMPT

Commit type: $COMMIT_TYPE"
    fi

    # Claude CLIを使用してコミットメッセージを生成
    print_info "Claude CLIでコミットメッセージを生成中..."

    COMMIT_MESSAGE=$(claude -p "$PROMPT

変更内容:
$(cat "$TEMP_FILE")

コミットメッセージのみを出力してください。説明は不要です。")

    # 一時ファイルを削除
    rm -f "$TEMP_FILE"
else
    COMMIT_MESSAGE="$CUSTOM_MESSAGE"
fi

# プレフィックスを追加
if [ -n "$PREFIX" ]; then
    COMMIT_MESSAGE="$PREFIX $COMMIT_MESSAGE"
fi

# コミットメッセージが生成されたか確認
if [ -z "$COMMIT_MESSAGE" ]; then
    print_error "コミットメッセージの生成に失敗しました"
    exit 1
fi

print_info "生成されたコミットメッセージ:"
echo "$COMMIT_MESSAGE"

# ユーザーに確認
echo
read -p "このメッセージでコミットしますか？ (y/n/e[dit]): " -r REPLY
echo

case $REPLY in
    [Yy])
        # 自動ステージングが有効な場合
        if [ "$AUTO_STAGE" = true ]; then
            print_info "変更をステージング中..."
            git add -A
        fi
        
        # コミット実行
        print_info "コミットを実行中..."
        git commit -m "$COMMIT_MESSAGE"
        
        if [ $? -eq 0 ]; then
            print_success "コミットが成功しました"
            
            # 自動プッシュが有効な場合
            if [ "$AUTO_PUSH" = true ]; then
                print_info "$BRANCH ブランチにプッシュ中..."
                git push origin "$BRANCH"
                
                if [ $? -eq 0 ]; then
                    print_success "プッシュが完了しました"
                else
                    print_error "プッシュに失敗しました"
                    print_info "後で手動でプッシュしてください: git push origin $BRANCH"
                fi
            else
                print_info "自動プッシュは無効です。手動でプッシュしてください: git push origin $BRANCH"
            fi
        else
            print_error "コミットに失敗しました"
            exit 1
        fi
        ;;
    [Ee])
        # メッセージを編集
        TEMP_MSG_FILE=$(mktemp)
        echo "$COMMIT_MESSAGE" > "$TEMP_MSG_FILE"
        ${EDITOR:-vim} "$TEMP_MSG_FILE"
        COMMIT_MESSAGE=$(cat "$TEMP_MSG_FILE")
        rm -f "$TEMP_MSG_FILE"
        
        # 編集後に再度実行
        exec "$0" -m "$COMMIT_MESSAGE" "${@}"
        ;;
    *)
        print_info "コミットをキャンセルしました"
        ;;
esac