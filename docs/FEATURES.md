# Claude Auto-Commit Features (v0.1.0)

## Core Features

### 🧠 AI-Powered Commit Messages
Claude Code SDK analyzes your code changes to generate meaningful commit messages that accurately describe what was changed and why.

### 🌍 Multi-Language Support
Currently supports:
- English (en)
- Japanese (ja)

### 📝 Conventional Commits
Support for the [Conventional Commits](https://www.conventionalcommits.org/) specification:
```bash
claude-auto-commit -c -t feat
# Output: feat: add user authentication module
```

### 😊 Emoji Support
Add contextual emojis to commit messages:
```bash
claude-auto-commit -e
# Output: ✨ Add new user authentication feature
```

### ⚡ Performance Optimizations
- **Parallel Processing**: Git commands executed in parallel
- **Intelligent Caching**: Reduced duplicate API calls
- **Retry Mechanism**: Enhanced error handling with exponential backoff

## New Features (v0.0.3)

### 🔍 Dry Run Mode
Preview the generated commit message without actually committing:
```bash
claude-auto-commit --dry-run
```

### 📊 Change Summary
Get detailed statistics about your changes:
```bash
claude-auto-commit --summary

# Output:
# 📋 Detailed change contents:
#   📁 File statistics:
#     src/app.js    | 45 +++++++++++++++++++++++++++++++++++++--------
#     src/utils.js  | 12 ++++++------
#   
#   ➕ 51 lines added
#   ➖ 18 lines deleted
#   
#   📝 File types:
#     .js: 2 files
#     .md: 1 file
```

## Configuration Options

### Command Line Flags

| Flag | Description |
|------|-------------|
| `-b, --branch <branch>` | Target branch for push (default: main) |
| `-l, --language <lang>` | Commit message language |
| `-e, --emoji` | Use emoji in commit messages |
| `-n, --no-push` | Don't push after commit |
| `-s, --no-stage` | Manual file staging |
| `-d, --diff-lines <num>` | Max diff lines to analyze |
| `-m, --message <msg>` | Custom commit message |
| `-t, --type <type>` | Commit type (feat/fix/docs/etc) |
| `-v, --verbose` | Verbose output |
| `-c, --conventional` | Use Conventional Commits format |
| `-p, --prefix <prefix>` | Custom prefix (e.g., [WIP]) |
| `-y, --yes` | Skip push confirmation |
| `--dry-run` | Preview without committing |
| `--summary` | Show detailed change statistics |

### Configuration File

Create `~/.claude-auto-commit/config.yml`:

```yaml
auto_update:
  enabled: true
  frequency: daily  # daily/weekly/manual/always
  silent: false

defaults:
  language: en
  branch: main
  emoji: false
  conventional: false

git:
  auto_stage: true
  auto_push: true
```

## Usage Examples

### Basic Usage
```bash
# Simple commit with auto-generated message
claude-auto-commit

# Without pushing
claude-auto-commit -n
```

### Advanced Usage
```bash
# Dry run with summary in Japanese
claude-auto-commit --dry-run --summary -l ja

# Conventional commit for a new feature with emoji
claude-auto-commit -c -t feat -e

# Custom prefix with manual staging
claude-auto-commit -p "[HOTFIX]" -s

# Skip all confirmations for automation
claude-auto-commit -y
```

## Workflow Integration

### Git Aliases
Add to your `.gitconfig`:
```ini
[alias]
    ac = !claude-auto-commit
    acp = !claude-auto-commit -n
    acd = !claude-auto-commit --dry-run --summary
```

### Pre-commit Hook
Coming soon: Automatic message generation as a git hook.

## New Features (v0.0.4)

### 🧠 Commit History Learning
Analyze your project's commit history to maintain consistent style:
```bash
# Analyze last 100 commits
claude-auto-commit --analyze-history

# Output:
# 📊 Emoji usage: 76% (76/100 commits)
# 📏 Average message length: 52 characters
# 🏷️ Common prefixes: feat:, fix:, docs:
# 🌐 Detected languages: English 85%, Japanese 15%
```

### 🎯 Smart File Grouping
Intelligently categorize changed files:
```bash
claude-auto-commit --smart-group

# Output:
# File categories detected:
#   🎯 Frontend/Application: 3 files
#   🔧 Backend/API: 2 files
#   📖 Documentation: 1 file
```

### 📊 Learned Style Application
Apply analyzed patterns to new commits:
```bash
# Use learned commit style
claude-auto-commit --style learned
```

## New Features (v0.1.0) - Latest SDK Version

### 📝 Enhanced Template System
Save and reuse common commit message patterns with persistent storage:

```bash
# Save a template (stored in ~/.claude-auto-commit/templates/)
claude-auto-commit --dry-run --save-template feature-update

# Use a saved template
claude-auto-commit --template feature-update

# List available templates
claude-auto-commit --list-templates
```

### ⚙️ Configuration File Support
JSON-based configuration with caching:

```bash
# Configuration saved in ~/.claude-auto-commit/config.json
{
  "language": "ja",
  "useEmoji": true,
  "conventionalCommit": true,
  "verbose": false
}
```

### 🚀 Auto-Push Support
Optional automatic push to remote repository:

```bash
# Enable auto-push for this commit
claude-auto-commit --push

# Enable auto-push in configuration
# "autoPush": true in config.json
```

### 📊 Verbose Logging & Performance Metrics
Detailed execution information and timing:

```bash
# Enable verbose mode
claude-auto-commit --verbose

# Output:
# ⏱️  Config and Git setup: 45.23ms
# ⏱️  Change detection: 12.15ms
# ⏱️  Staging changes: 89.47ms
# ⏱️  Git changes analysis: 156.89ms
# ⏱️  Commit message generation: 1247.56ms
# ⏱️  Total execution time: 1551.30ms
```

### 🔄 Enhanced Retry Mechanism
Improved reliability with exponential backoff:

```bash
# Automatic retry on failure
🤖 Generating commit message (attempt 1/3)...
❌ Attempt 1 failed: Network timeout
⏳ Retrying in 1000ms...
🤖 Generating commit message (attempt 2/3)...
✅ Success!
```

### 📦 Multiple Installation Methods
- **One-liner installer**: `curl -fsSL ... | bash`
- **NPM global**: `npm install -g claude-auto-commit`
- **One-time execution**: `curl -fsSL .../run-once.sh | bash`

## Breaking Changes (v0.1.0)

### 🔄 Architecture Migration
- **From**: Claude CLI dependency
- **To**: Claude Code SDK integration
- **Benefit**: Better performance, reliability, modern Node.js architecture

### 📋 New Requirements
- **Node.js 22.0.0+** (upgraded from 16.0.0+)
- **ANTHROPIC_API_KEY** environment variable
- **ES Modules** support

### 🛠️ Updated Command Interface
All previous CLI options remain compatible, with new additions:

| New Flag | Description |
|----------|-------------|
| `--push` | Auto-push after commit |
| `--template <name>` | Use saved template |
| `--save-template <name>` | Save message as template (dry-run only) |
| `--list-templates` | List available templates |

## Upcoming Features (v0.2.0+)

- ✂️ **VS Code Extension**: Direct IDE integration
- 🔧 **CI/CD Integration**: GitHub Actions workflow
- 🔗 **Plugin System**: Extensible architecture
- 📈 **Advanced Analytics**: Commit pattern analysis
- 🌐 **Additional Languages**: Spanish, French, Arabic support
- 🎯 **Team Features**: Shared templates and conventions