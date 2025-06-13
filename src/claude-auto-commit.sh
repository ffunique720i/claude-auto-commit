#!/bin/bash

# Claude Auto-Commit - AI-powered Git commit message generator
# Version: 0.0.5 (DEPRECATED)
# Repository: https://github.com/0xkaz/claude-auto-commit

VERSION="0.0.5"

# 🚨 DEPRECATION WARNING
echo ""
echo "⚠️  WARNING: CLI version (claude-auto-commit.sh) is DEPRECATED!"
echo "   📦 Please migrate to SDK version for better performance:"
echo "   📥 Installation: curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/install.sh | bash"
echo "   🆕 New features: Templates, Config files, Performance optimizations"
echo "   📅 CLI version will be removed in v0.2.0"
echo ""
sleep 3
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
SMART_GROUP=false
ANALYZE_HISTORY=false
USE_LEARNED_STYLE=false
SAVE_TEMPLATE=""
USE_TEMPLATE=""
LIST_TEMPLATES=false
DELETE_TEMPLATE=""

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
    --smart-group              Group related files into logical commits
    --analyze-history          Analyze commit history to learn patterns
    --style learned            Use learned commit style from history
    --save-template <name>     Save a commit message template
    --template <name>          Use a saved template (-T for short)
    --list-templates           List all saved templates
    --delete-template <name>   Delete a saved template
    --update                   Check for updates now
    --no-update                Skip update check
    --version                  Show version information
    -h, --help                 Show this help

Examples:
    $(basename $0) -b develop -e -t feat
    $(basename $0) -m "Custom message" -n
    $(basename $0) -c -t fix -l en
    $(basename $0) --dry-run  # Generate message only
    $(basename $0) --smart-group  # Group related files
    $(basename $0) --analyze-history  # Learn from commit history
    $(basename $0) --save-template hotfix "🔥 HOTFIX: {description}"
    $(basename $0) --template hotfix  # Use saved template
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

# Update script
update_binary() {
    local new_version="$1"
    local url="https://github.com/$REPO/releases/download/v$new_version/claude-auto-commit.sh"
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
        --smart-group)
            SMART_GROUP=true
            shift
            ;;
        --analyze-history)
            ANALYZE_HISTORY=true
            shift
            ;;
        --style)
            if [ "$2" = "learned" ]; then
                USE_LEARNED_STYLE=true
            fi
            shift 2
            ;;
        --save-template)
            SAVE_TEMPLATE="$2"
            CUSTOM_MESSAGE="$3"
            shift 3
            ;;
        --template|-T)
            USE_TEMPLATE="$2"
            shift 2
            ;;
        --list-templates)
            LIST_TEMPLATES=true
            shift
            ;;
        --delete-template)
            DELETE_TEMPLATE="$2"
            shift 2
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
            echo "Repository: https://github.com/0xkaz/claude-auto-commit"
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

# Create templates directory
TEMPLATES_DIR="$CONFIG_DIR/templates"
mkdir -p "$TEMPLATES_DIR"

# Load config
load_config

# Auto-update check
check_for_updates "$@"

# Template management functions
if [ "$LIST_TEMPLATES" = true ]; then
    print_info "📝 Available templates:"
    if [ -d "$TEMPLATES_DIR" ] && [ "$(ls -A "$TEMPLATES_DIR" 2>/dev/null)" ]; then
        for template in "$TEMPLATES_DIR"/*; do
            [ -f "$template" ] && {
                name=$(basename "$template")
                content=$(cat "$template")
                echo "  • $name: $content"
            }
        done
    else
        echo "  No templates found."
        echo "  Create one with: $(basename $0) --save-template <name> \"<template>\""
    fi
    exit 0
fi

if [ -n "$DELETE_TEMPLATE" ]; then
    if [ -f "$TEMPLATES_DIR/$DELETE_TEMPLATE" ]; then
        rm "$TEMPLATES_DIR/$DELETE_TEMPLATE"
        print_success "Template '$DELETE_TEMPLATE' deleted"
    else
        print_error "Template '$DELETE_TEMPLATE' not found"
    fi
    exit 0
fi

if [ -n "$SAVE_TEMPLATE" ]; then
    if [ -z "$CUSTOM_MESSAGE" ]; then
        print_error "Template content required"
        echo "Usage: $(basename $0) --save-template <name> \"<template>\""
        exit 1
    fi
    echo "$CUSTOM_MESSAGE" > "$TEMPLATES_DIR/$SAVE_TEMPLATE"
    print_success "Template '$SAVE_TEMPLATE' saved"
    echo "Use it with: $(basename $0) --template $SAVE_TEMPLATE"
    exit 0
fi

# Check if we're in a Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a Git repository"
    exit 1
fi

# Analyze commit history if requested
if [ "$ANALYZE_HISTORY" = true ]; then
    print_info "Analyzing commit history..."
    
    # Get recent commits (last 100)
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
    ANALYZE_COUNT=$((COMMIT_COUNT > 100 ? 100 : COMMIT_COUNT))
    
    if [ "$COMMIT_COUNT" -eq 0 ]; then
        print_error "No commits found in repository"
        exit 1
    fi
    
    # Analyze patterns
    echo
    print_info "📊 Commit History Analysis (last $ANALYZE_COUNT commits)"
    echo
    
    # Emoji usage
    EMOJI_COUNT=$(git log --oneline -n $ANALYZE_COUNT | grep -E "^[a-f0-9]+ [🎯🚀💡🔧🐛📝✨🎨⚡️🔥💄🎉✅🚧🚨♻️➕➖🔀📦🍱🏷️🌐💬🗃️🔊🔇📱💻🎨⚗️🔍🥅🩹🔨📌⬆️⬇️]" | wc -l)
    EMOJI_PERCENT=$((EMOJI_COUNT * 100 / ANALYZE_COUNT))
    echo "  📊 Emoji usage: $EMOJI_PERCENT% ($EMOJI_COUNT/$ANALYZE_COUNT commits)"
    
    # Average message length
    AVG_LENGTH=$(git log --oneline -n $ANALYZE_COUNT | awk '{$1=""; print length($0)}' | awk '{sum+=$1} END {print int(sum/NR)}')
    echo "  📏 Average message length: $AVG_LENGTH characters"
    
    # Common prefixes
    echo "  🏷️ Common prefixes:"
    git log --oneline -n $ANALYZE_COUNT | sed 's/^[a-f0-9]* //' | grep -oE "^(feat|fix|docs|style|refactor|test|chore|build|ci|perf|revert|wip|hotfix|release):" | sort | uniq -c | sort -rn | head -5 | while read count prefix; do
        echo "     $prefix $count times"
    done
    
    # Language detection (simplified for macOS compatibility)
    echo "  🌐 Detected languages:"
    # For macOS, use a simpler approach
    JAPANESE_COUNT=$(git log --oneline -n $ANALYZE_COUNT | grep -E "[ぁ-んァ-ヶー一-龠]" | wc -l | tr -d ' ')
    ENGLISH_COUNT=$((ANALYZE_COUNT - JAPANESE_COUNT))
    [ "$JAPANESE_COUNT" -gt 0 ] && echo "     Japanese: $((JAPANESE_COUNT * 100 / ANALYZE_COUNT))% ($JAPANESE_COUNT commits)"
    [ "$ENGLISH_COUNT" -gt 0 ] && echo "     English: $((ENGLISH_COUNT * 100 / ANALYZE_COUNT))% ($ENGLISH_COUNT commits)"
    
    # Save analysis results
    cat > "$CONFIG_DIR/commit-style.yml" << EOF
# Learned commit style from history analysis
commit_style:
  emoji_usage: $EMOJI_PERCENT
  average_length: $AVG_LENGTH
  analyzed_commits: $ANALYZE_COUNT
  analysis_date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
EOF
    
    echo
    print_success "Analysis complete! Results saved to $CONFIG_DIR/commit-style.yml"
    echo
    print_info "Use '--style learned' to apply these patterns to new commits"
    exit 0
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

# Smart grouping if requested
if [ "$SMART_GROUP" = true ]; then
    echo
    print_info "🎯 Analyzing file changes for logical grouping..."
    
    # Get all changed files
    ALL_CHANGED_FILES=$(git diff --name-only; git diff --cached --name-only; git ls-files --others --exclude-standard)
    
    # Analyze file patterns (simplified for compatibility)
    echo
    print_info "File categories detected:"
    
    # Frontend/JS files
    FRONTEND_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "^(src|lib|app)/.*\.(js|ts|jsx|tsx)$" | wc -l | tr -d ' ')
    [ "$FRONTEND_FILES" -gt 0 ] && echo "  🎯 Frontend/Application: $FRONTEND_FILES files"
    
    # Backend files
    BACKEND_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "^(api|server|backend)/.*" | wc -l | tr -d ' ')
    [ "$BACKEND_FILES" -gt 0 ] && echo "  🔧 Backend/API: $BACKEND_FILES files"
    
    # Test files
    TEST_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "^(test|spec|__tests__)/.*" | wc -l | tr -d ' ')
    [ "$TEST_FILES" -gt 0 ] && echo "  🧪 Tests: $TEST_FILES files"
    
    # Documentation
    DOC_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "^(docs?|README|CONTRIBUTING|CHANGELOG)" | wc -l | tr -d ' ')
    [ "$DOC_FILES" -gt 0 ] && echo "  📖 Documentation: $DOC_FILES files"
    
    # Config files
    CONFIG_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "^(\.github|\.gitlab|\.|config)" | wc -l | tr -d ' ')
    [ "$CONFIG_FILES" -gt 0 ] && echo "  ⚙️ Configuration: $CONFIG_FILES files"
    
    # Style files
    STYLE_FILES=$(echo "$ALL_CHANGED_FILES" | grep -E "\.(css|scss|sass|less|styl)$" | wc -l | tr -d ' ')
    [ "$STYLE_FILES" -gt 0 ] && echo "  🎨 Styles: $STYLE_FILES files"
    
    if [ "$VERBOSE" = true ]; then
        echo
        echo "  Files by directory:"
        echo "$ALL_CHANGED_FILES" | cut -d'/' -f1 | sort | uniq -c | sort -rn | head -10 | while read count dir; do
            [ -n "$dir" ] && echo "    $dir/: $count files"
        done
    fi
    
    echo
    read -p "Select groups to commit (e.g., 1,3 or 'all' or 'skip'): " -r GROUP_SELECTION
    
    if [ "$GROUP_SELECTION" = "skip" ]; then
        print_info "Smart grouping skipped. Proceeding with normal commit..."
    elif [ "$GROUP_SELECTION" != "all" ] && [ -n "$GROUP_SELECTION" ]; then
        # TODO: Implement selective group commit
        print_warning "Selective group commit not yet implemented. Proceeding with all changes..."
    fi
    echo
fi

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

# Use template if specified
if [ -n "$USE_TEMPLATE" ]; then
    if [ -f "$TEMPLATES_DIR/$USE_TEMPLATE" ]; then
        TEMPLATE_CONTENT=$(cat "$TEMPLATES_DIR/$USE_TEMPLATE")
        print_info "Using template: $USE_TEMPLATE"
        
        # Process template placeholders
        if echo "$TEMPLATE_CONTENT" | grep -q "{"; then
            # Extract placeholders
            PLACEHOLDERS=$(echo "$TEMPLATE_CONTENT" | grep -o '{[^}]*}' | sort -u)
            
            # Replace each placeholder
            FINAL_MESSAGE="$TEMPLATE_CONTENT"
            for placeholder in $PLACEHOLDERS; do
                var_name=$(echo "$placeholder" | tr -d '{}')
                echo
                read -p "Enter value for $var_name: " -r var_value
                FINAL_MESSAGE=$(echo "$FINAL_MESSAGE" | sed "s/$placeholder/$var_value/g")
            done
            CUSTOM_MESSAGE="$FINAL_MESSAGE"
        else
            CUSTOM_MESSAGE="$TEMPLATE_CONTENT"
        fi
    else
        print_error "Template '$USE_TEMPLATE' not found"
        print_info "Available templates:"
        ls "$TEMPLATES_DIR" 2>/dev/null | sed 's/^/  • /' || echo "  No templates found"
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

    # Apply learned style if requested
    if [ "$USE_LEARNED_STYLE" = true ] && [ -f "$CONFIG_DIR/commit-style.yml" ]; then
        # Read learned style
        LEARNED_EMOJI=$(grep "emoji_usage:" "$CONFIG_DIR/commit-style.yml" | awk '{print $2}')
        LEARNED_LENGTH=$(grep "average_length:" "$CONFIG_DIR/commit-style.yml" | awk '{print $2}')
        
        PROMPT="$PROMPT

Based on commit history analysis:
- Use emoji in ${LEARNED_EMOJI}% of cases
- Target message length: around ${LEARNED_LENGTH} characters"
        
        # Override emoji setting based on learned pattern
        if [ "$LEARNED_EMOJI" -gt 50 ]; then
            USE_EMOJI=true
        fi
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