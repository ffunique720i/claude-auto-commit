#!/bin/bash

# Claude Auto-Commit - AI-powered Git commit message generator
# Version: 0.0.3
# Homepage: https://claude-auto-commit.0xkaz.com

VERSION="0.0.3"
REPO="0xkaz/claude-auto-commit"
CONFIG_DIR="$HOME/.claude-auto-commit"
CONFIG_FILE="$CONFIG_DIR/config.yml"
LAST_CHECK_FILE="$CONFIG_DIR/last-check"

# Default settings
DEFAULT_BRANCH="main"
DEFAULT_LANGUAGE="en"
MAX_DIFF_LINES=500
USE_EMOJI=false
AUTO_PUSH=true
AUTO_STAGE=true
VERBOSE=false
AUTO_UPDATE=true
UPDATE_FREQUENCY="daily"
SKIP_PUSH_CONFIRM=false
DRY_RUN=false
SHOW_SUMMARY=false

# Display usage information
usage() {
    cat << EOF
Usage: $(basename $0) [options]

Options:
    -b, --branch <branch>      Target branch for push (default: main)
    -l, --language <lang>      Commit message language (en/ja/zh, default: en)
    -e, --emoji                Use emoji in commit messages
    -n, --no-push              Don't push after commit
    -s, --no-stage             Manual file staging (no auto-stage)
    -d, --diff-lines <num>     Max diff lines to analyze (default: 500)
    -m, --message <msg>        Use custom commit message
    -t, --type <type>          Specify commit type (feat/fix/docs/style/refactor/test/chore)
    -v, --verbose              Show verbose output
    -c, --conventional         Use Conventional Commits format
    -p, --prefix <prefix>      Custom prefix (e.g., [WIP], [HOTFIX])
    -y, --yes                  Skip push confirmation
    --dry-run                  Generate message only (no commit)
    --summary                  Show detailed change summary
    --update                   Check for updates now
    --no-update                Skip update check
    --version                  Show version information
    -h, --help                 Show this help

Examples:
    $(basename $0) -b develop -e -t feat
    $(basename $0) -m "Custom message" -n
    $(basename $0) -c -t fix -l en
    $(basename $0) --dry-run  # Generate message only
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

# Load config
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # YAML解析（簡易版）
        AUTO_UPDATE=$(grep -A 3 "auto_update:" "$CONFIG_FILE" | grep "enabled:" | sed 's/.*enabled:[[:space:]]*//' | tr -d '"')
        UPDATE_FREQUENCY=$(grep -A 3 "auto_update:" "$CONFIG_FILE" | grep "frequency:" | sed 's/.*frequency:[[:space:]]*//' | tr -d '"')
        DEFAULT_LANGUAGE=$(grep -A 5 "defaults:" "$CONFIG_FILE" | grep "language:" | sed 's/.*language:[[:space:]]*//' | tr -d '"')
        
        # Set default values
        AUTO_UPDATE=${AUTO_UPDATE:-true}
        UPDATE_FREQUENCY=${UPDATE_FREQUENCY:-daily}
        DEFAULT_LANGUAGE=${DEFAULT_LANGUAGE:-en}
    fi
}

# Get latest version
get_latest_version() {
    curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//'
}

# Compare versions
version_gt() {
    [ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ]
}

# Check for updates
check_for_updates() {
    [ "$AUTO_UPDATE" = "false" ] && return 0
    
    # Check last update time
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
    
    # Check latest version
    local latest_version=$(get_latest_version)
    if [ -z "$latest_version" ]; then
        return 0
    fi
    
    # Record check time
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

# Update binary
update_binary() {
    local new_version="$1"
    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/')
    local url="https://github.com/$REPO/releases/download/v$new_version/claude-auto-commit-$platform"
    local current_binary=$(which claude-auto-commit 2>/dev/null || echo "$0")
    
    # 一時ファイルにダウンロード
    local tmp_file=$(mktemp)
    
    if curl -L -s -o "$tmp_file" "$url" 2>/dev/null; then
        chmod +x "$tmp_file"
        
        # Create backup
        cp "$current_binary" "$current_binary.backup"
        
        # Execute update
        if mv "$tmp_file" "$current_binary" 2>/dev/null || sudo mv "$tmp_file" "$current_binary" 2>/dev/null; then
            return 0
        else
            # Restore from backup on failure
            mv "$current_binary.backup" "$current_binary" 2>/dev/null
            rm -f "$tmp_file"
            return 1
        fi
    else
        rm -f "$tmp_file"
        return 1
    fi
}

# Parse options
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
        -y|--yes)
            SKIP_PUSH_CONFIRM=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --summary)
            SHOW_SUMMARY=true
            shift
            ;;
        --update)
            # Force update
            AUTO_UPDATE=true
            UPDATE_FREQUENCY="always"
            shift
            ;;
        --no-update)
            # Skip update this time
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
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Create config directory
mkdir -p "$CONFIG_DIR"

# Load config
load_config

# Auto-update check
check_for_updates "$@"

# Check if we're in a Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a Git repository"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
print_info "Current branch: $CURRENT_BRANCH"

# Generate change summary
print_info "Analyzing changes..."

# Get staged and unstaged changes separately
STAGED_COUNT=$(git diff --cached --name-only | wc -l)
UNSTAGED_COUNT=$(git diff --name-only | wc -l)
UNTRACKED_COUNT=$(git ls-files --others --exclude-standard | wc -l)

TOTAL_CHANGES=$((STAGED_COUNT + UNSTAGED_COUNT + UNTRACKED_COUNT))

# Exit if no changes
if [ "$TOTAL_CHANGES" -eq 0 ]; then
    print_info "No files changed. Nothing to commit."
    exit 0
fi

# Display change summary
print_info "Change summary:"
echo "  Staged: $STAGED_COUNT files"
echo "  Unstaged: $UNSTAGED_COUNT files"
echo "  Untracked: $UNTRACKED_COUNT files"

# Show detailed summary
if [ "$SHOW_SUMMARY" = true ]; then
    echo
    print_info "📋 Detailed change contents:"
    
    # File statistics
    if [ "$STAGED_COUNT" -gt 0 ] || [ "$AUTO_STAGE" = true ]; then
        echo
        echo "  📁 File statistics:"
        git diff --cached --stat 2>/dev/null || git diff --stat
        
        # Lines added/deleted
        ADDITIONS=$(git diff --cached --numstat 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo 0)
        DELETIONS=$(git diff --cached --numstat 2>/dev/null | awk '{sum+=$2} END {print sum}' || echo 0)
        [ -z "$ADDITIONS" ] && ADDITIONS=0
        [ -z "$DELETIONS" ] && DELETIONS=0
        
        echo
        echo "  ➕ $ADDITIONS lines added"
        echo "  ➖ $DELETIONS lines deleted"
        
        # File type statistics
        echo
        echo "  📝 File types:"
        git diff --cached --name-only 2>/dev/null | rev | cut -d'.' -f1 | rev | sort | uniq -c | sort -rn | head -10 | while read count ext; do
            [ -n "$ext" ] && echo "    .$ext: $count files"
        done
    fi
    echo
fi

# Manual staging mode
if [ "$AUTO_STAGE" = false ]; then
    print_warning "Manual staging mode. Running git add -i..."
    git add -i
    
    # Check staging status after manual selection
    STAGED_COUNT=$(git diff --cached --name-only | wc -l)
    if [ "$STAGED_COUNT" -eq 0 ]; then
        print_error "No files staged"
        exit 1
    fi
fi

# Generate message with Claude CLI if no custom message provided
if [ -z "$CUSTOM_MESSAGE" ]; then
    # Get detailed changes and save to temp file
    TEMP_FILE=$(mktemp)
    {
        echo "=== Git Status ==="
        git status --short
        echo ""
        echo "=== Changed Files Summary ==="
        echo "Staged: $STAGED_COUNT, Unstaged: $UNSTAGED_COUNT, Untracked: $UNTRACKED_COUNT"
        echo ""
        
        # Analyze changed file types
        echo "=== File Types Analysis ==="
        git diff --cached --name-only | rev | cut -d'.' -f1 | rev | sort | uniq -c | sort -rn
        echo ""
        
        # Diff statistics
        echo "=== Diff Statistics ==="
        git diff --cached --stat
        echo ""
        
        # Actual diff (up to specified lines)
        if [ "$VERBOSE" = true ]; then
            echo "=== Actual Changes (first $MAX_DIFF_LINES lines) ==="
            git diff --cached --no-color | head -n $MAX_DIFF_LINES
        fi
    } > "$TEMP_FILE"

    # Language prompt settings
    if [ "$LANGUAGE" = "en" ]; then
        PROMPT="Generate an appropriate commit message in English based on the following Git changes.
The commit message should be concise and capture the essence of the changes."
    else
        PROMPT="Generate an appropriate commit message in Japanese based on the following Git changes.
The commit message should be concise and capture the essence of the changes."
    fi

    # Emoji settings
    if [ "$USE_EMOJI" = true ]; then
        PROMPT="$PROMPT
Please use appropriate emoji at the beginning of the message."
    else
        PROMPT="$PROMPT
Do not use emoji."
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

    # Generate commit message using Claude CLI
    print_info "Generating commit message with Claude CLI..."

    COMMIT_MESSAGE=$(claude -p "$PROMPT

Changes:
$(cat "$TEMP_FILE")

Output only the commit message. No explanation needed.")

    # Remove temp file
    rm -f "$TEMP_FILE"
else
    COMMIT_MESSAGE="$CUSTOM_MESSAGE"
fi

# Add prefix
if [ -n "$PREFIX" ]; then
    COMMIT_MESSAGE="$PREFIX $COMMIT_MESSAGE"
fi

# Verify commit message was generated
if [ -z "$COMMIT_MESSAGE" ]; then
    print_error "Failed to generate commit message"
    exit 1
fi

print_info "Generated commit message:"
echo "$COMMIT_MESSAGE"

# Exit here if dry run mode
if [ "$DRY_RUN" = true ]; then
    echo
    print_info "Dry run mode: No commit was made"
    exit 0
fi

# Confirm with user
echo
read -p "Commit with this message? (y/n/e[dit]): " -r REPLY
echo

case $REPLY in
    [Yy])
        # Auto-stage if enabled
        if [ "$AUTO_STAGE" = true ]; then
            print_info "Staging changes..."
            git add -A
        fi
        
        # Execute commit
        print_info "Creating commit..."
        git commit -m "$COMMIT_MESSAGE"
        
        if [ $? -eq 0 ]; then
            print_success "Commit successful"
            
            # Auto-push if enabled
            if [ "$AUTO_PUSH" = true ]; then
                # Confirm before push
                if [ "$SKIP_PUSH_CONFIRM" = false ]; then
                    echo
                    print_warning "About to push to remote repository ($BRANCH branch)"
                    read -p "Continue with push? (y/n): " -r PUSH_REPLY
                    echo
                    
                    if [[ ! $PUSH_REPLY =~ ^[Yy]$ ]]; then
                        print_info "Push skipped. To push manually: git push origin $BRANCH"
                        exit 0
                    fi
                fi
                
                print_info "Pushing to $BRANCH branch..."
                git push origin "$BRANCH"
                
                if [ $? -eq 0 ]; then
                    print_success "Push completed"
                else
                    print_error "Push failed"
                    print_info "Please push manually later: git push origin $BRANCH"
                fi
            else
                print_info "Auto-push disabled. To push manually: git push origin $BRANCH"
            fi
        else
            print_error "Commit failed"
            exit 1
        fi
        ;;
    [Ee])
        # Edit message
        TEMP_MSG_FILE=$(mktemp)
        echo "$COMMIT_MESSAGE" > "$TEMP_MSG_FILE"
        ${EDITOR:-vim} "$TEMP_MSG_FILE"
        COMMIT_MESSAGE=$(cat "$TEMP_MSG_FILE")
        rm -f "$TEMP_MSG_FILE"
        
        # Re-run with edited message
        exec "$0" -m "$COMMIT_MESSAGE" "${@}"
        ;;
    *)
        print_info "Commit cancelled"
        ;;
esac