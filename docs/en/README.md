# Claude Auto-Commit

<div align="center">

![Claude Auto-Commit Hero](../images/hero-banner.png)

🤖 **AI-powered Git commit message generator using Claude Code SDK**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/releases)
[![npm version](https://img.shields.io/npm/v/claude-auto-commit.svg)](https://www.npmjs.com/package/claude-auto-commit)
[![GitHub stars](https://img.shields.io/github/stars/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/stargazers)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](https://github.com/0xkaz/claude-auto-commit)
[![Node.js](https://img.shields.io/badge/Node.js-22%2B-green.svg)](https://nodejs.org)
[![Claude Code SDK](https://img.shields.io/badge/Powered%20by-Claude%20Code%20SDK-orange.svg)](https://docs.anthropic.com/en/docs/claude-code)

</div>

**Language**: [日本語](../ja/README.md) | [中文](../zh/README.md)

Claude Auto-Commit is an open-source command-line tool that integrates AI-powered commit message generation into your Git workflow. By analyzing your code changes, it creates meaningful and contextual commit messages using Claude Code SDK with enhanced performance and reliability.

## 🌟 Transform Your Commit History

<div align="center">

![Before and After Comparison](../images/demo-before-after-english.png)

*Say goodbye to vague commit messages. Let Claude AI write meaningful commits that tell the story of your code.*

</div>

⚠️ **Important Notes**: 
- **Requires Claude Pro/Max subscription** and Claude CLI authentication
- **No API key needed** - uses Claude Code SDK with OAuth authentication
- Run `claude login` first if not already authenticated
- By default, this tool will automatically stage all changes and commit
- Use `--push` flag to enable auto-push to remote repository
- Use `--dry-run` flag to preview commit messages without committing

## 🚀 Quick Start

### Installation Options

**Method 1: NPX execution (recommended, no installation needed)**
```bash
npx claude-auto-commit
```

**Method 2: NPM global installation**
```bash
npm install -g claude-auto-commit
```

**Method 3: Script installation**
```bash
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/install.sh | bash
```

**Method 4: One-time script execution**
```bash
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/run-once.sh | bash
```

### Basic Usage

```bash
# Analyze changes and generate commit message
npx claude-auto-commit

# Japanese with emojis and conventional commits
npx claude-auto-commit -l ja -e -c

# Custom commit type with auto-push
npx claude-auto-commit -t feat --push
```

### Authentication Setup

Claude Auto-Commit uses Claude Code SDK which requires **Claude Pro or Max subscription**:

```bash
# First-time setup: Login to Claude CLI
claude login

# Choose option: "2. Claude app (requires Max subscription)"
# This opens your browser for OAuth authentication
# No API key needed - authentication is handled automatically
```

After initial login, your authentication is saved and claude-auto-commit will work seamlessly.

## ✨ Features

- 🧠 **AI-Powered**: Generates intelligent commit messages using Claude CLI
- 🌍 **Multi-language**: Supports English, Japanese, Chinese, Arabic, Spanish, French
- 📝 **Conventional Commits**: Optional conventional commits format
- 🔄 **Auto-update**: Daily automatic updates (configurable)
- 🎯 **Smart Analysis**: Analyzes code changes, file types, and patterns
- ⚡ **Fast & Lightweight**: Optimized for daily development workflow
- 🛠️ **Highly Configurable**: Extensive customization options

## 📋 Requirements

- Git repository
- [Claude CLI](https://docs.anthropic.com/claude/cli) installed and configured
- Bash shell (macOS, Linux, WSL)

## 🎯 Examples

### Basic Usage
```bash
# Simple commit with auto-generated message
claude-auto-commit

# Custom branch and emoji
claude-auto-commit -b develop -e

# English with conventional commits
claude-auto-commit -l en -c -t feat

# Custom message, no push
claude-auto-commit -m "Custom commit message" -n
```

### Advanced Options
```bash
# Manual staging with verbose output
claude-auto-commit -s -v

# Custom prefix for hotfix
claude-auto-commit -p "[HOTFIX]" -t fix

# Update tool
claude-auto-commit --update
```

## 🔧 Installation Methods

### Method 1: One-liner (Recommended)
```bash
curl -fsSL https://claude-auto-commit.0xkaz.com/install.sh | bash
```

### Method 2: Manual Download
```bash
# Download for your platform
curl -L -o claude-auto-commit https://github.com/0xkaz/claude-auto-commit/releases/latest/download/claude-auto-commit-$(uname -s)-$(uname -m)
chmod +x claude-auto-commit
sudo mv claude-auto-commit /usr/local/bin/
```

### Method 3: NPX (Node.js users)
```bash
npx claude-auto-commit@latest
```

## ⚙️ Configuration

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

## 📖 All Options

| Option | Description | Default |
|--------|-------------|---------|
| `-b, --branch <branch>` | Target branch for push | `main` |
| `-l, --language <lang>` | Language (en/ja/zh/ar/es/fr) | `en` |
| `-e, --emoji` | Use emojis | `false` |
| `-n, --no-push` | Don't push | `false` |
| `-s, --no-stage` | Manual staging | `false` |
| `-m, --message <msg>` | Custom message | Claude generated |
| `-t, --type <type>` | Commit type | Auto-detected |
| `-c, --conventional` | Conventional Commits | `false` |
| `-p, --prefix <prefix>` | Prefix | None |
| `-v, --verbose` | Verbose output | `false` |
| `--update` | Update now | - |
| `--no-update` | Skip update this time | - |
| `--version` | Show version | - |
| `-h, --help` | Show help | - |

## 🌟 Key Features

### Intelligent Commit Message Generation
Claude AI analyzes code changes and considers:
- Types of files changed
- Number of lines added, modified, deleted
- Actual code differences
- Project context

### Multi-language Support
Generates messages appropriate for each language's programming community culture:
- **English**: Concise and standard expressions
- **Japanese**: Polite and detailed explanations
- **Chinese**: Technical and direct expressions

### Automatic Update System
- Daily automatic update checks
- Seamless background updates
- Automatic rollback on failure

## 🔄 Auto-Update System

Claude Auto-Commit features a sophisticated auto-update system:

### Default Behavior
- Checks for updates daily (configurable)
- Downloads and installs updates automatically
- Restarts with new version seamlessly
- No user intervention required

### Configuration Options
```yaml
auto_update:
  enabled: true        # Enable/disable auto-updates
  frequency: daily     # daily/weekly/manual/always
  silent: false        # Silent updates (no notifications)
```

### Manual Control
```bash
# Force update now
claude-auto-commit --update

# Skip update this time
claude-auto-commit --no-update

# Check current version
claude-auto-commit --version
```

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](../../CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) for Claude CLI
- [Conventional Commits](https://conventionalcommits.org) specification
- Open source community for inspiration

---

**Made with ❤️ for the developer community**

[Report Issues](https://github.com/0xkaz/claude-auto-commit/issues) | [Request Features](https://github.com/0xkaz/claude-auto-commit/issues/new?template=feature_request.md)