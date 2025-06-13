# Claude Auto-Commit

🤖 AI-powered Git commit message generator using Claude CLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/releases)
[![Website](https://img.shields.io/badge/website-claude--auto--commit.0xkaz.com-blue)](https://claude-auto-commit.0xkaz.com/)
[![GitHub stars](https://img.shields.io/github/stars/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/stargazers)

Claude Auto-Commit is an open-source tool that automatically generates intelligent Git commit messages by analyzing your code changes using Claude AI. It integrates seamlessly into your development workflow and supports multiple languages and configurations.

⚠️ **Important Notes**: 
- **Requires Claude Pro or Max subscription** for Claude Code CLI access
- By default, this tool will automatically stage all changes, commit, and push to your remote repository
- You will be prompted before pushing (use `-y` to skip confirmation)
- Use `-n` flag to disable auto-push, or `-s` flag to manually select files to stage

## 🚀 Quick Start

### Installation

```bash
curl -fsSL https://claude-auto-commit.0xkaz.com/install.sh | bash
```

### Basic Usage

```bash
# Analyze changes and generate commit message
claude-auto-commit

# Custom options
claude-auto-commit -l en -e -t feat
```

## ✨ Features

- 🧠 **AI Analysis**: Leverages Claude CLI to understand code changes and generate contextual commit messages
- 🌍 **Multi-language**: Interface available in English, Japanese, Chinese, Arabic, Spanish, French
- 📝 **Conventional Commits**: Optional support for conventional commit format
- 🔄 **Auto-update**: Automatic updates with rollback capability
- 🎯 **Smart Detection**: Analyzes file types, change patterns, and project context
- 🔍 **Dry Run Mode**: Preview commit messages without making actual commits
- 📋 **Change Summary**: Detailed statistics about your changes (lines added/deleted, file types)
- 🧠 **Commit Learning**: Analyze your commit history to maintain consistent style
- 🎯 **Smart Grouping**: Intelligently categorize files for logical commits
- 📝 **Template System**: Save and reuse common commit message patterns
- ⚡ **Lightweight**: Shell script with minimal dependencies
- 🛠️ **Configurable**: Extensive customization through CLI options and config files

## 📖 Documentation

- [English Documentation](./docs/en/README.md)
- [日本語ドキュメント](./docs/ja/README.md)
- [中文文档](./docs/zh/README.md)

Complete documentation and examples available at [claude-auto-commit.0xkaz.com](https://claude-auto-commit.0xkaz.com)

## 📋 Requirements

### 1. Claude Subscription (Required)
You need an active Claude subscription to use this tool:
- **Claude Pro** - For individual developers
- **Claude Max** - For power users with higher usage limits
- **Claude Team** - For team collaboration
- Sign up at [claude.ai](https://claude.ai)

### 2. Claude Code CLI Installation
After subscribing to Claude:
```bash
# Option 1: Download from Claude website (Recommended)
# Visit: https://claude.ai/download
# Download and install Claude for your platform

# Option 2: Using npm (if available)
npm install -g @anthropic-ai/claude-cli

# Authenticate with your Claude account
claude login
```

### 3. System Requirements
- Git repository
- Bash shell (macOS, Linux, WSL)
- curl (for installation)

## 🎯 Examples

### Basic Usage
```bash
# Simple commit with auto-generated message (will auto-stage, commit, and push)
claude-auto-commit

# Commit without auto-push (recommended for beginners)
claude-auto-commit -n

# Skip push confirmation prompt
claude-auto-commit -y

# Generate message without committing (dry-run)
claude-auto-commit --dry-run

# Show detailed change summary
claude-auto-commit --summary

# Manual file selection without auto-push
claude-auto-commit -s -n

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

# Preview message without committing
claude-auto-commit --dry-run

# Show detailed change statistics
claude-auto-commit --summary

# Combine options for detailed preview
claude-auto-commit --dry-run --summary -v

# Template management
claude-auto-commit --save-template hotfix "🔥 HOTFIX: {description}"
claude-auto-commit --template hotfix
claude-auto-commit --list-templates

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
# Download the script
curl -L -o claude-auto-commit https://github.com/0xkaz/claude-auto-commit/releases/latest/download/claude-auto-commit.sh
chmod +x claude-auto-commit
sudo mv claude-auto-commit /usr/local/bin/
```

### Method 3: Clone and Install
```bash
git clone https://github.com/0xkaz/claude-auto-commit.git
cd claude-auto-commit
chmod +x src/claude-auto-commit.sh
sudo ln -s $(pwd)/src/claude-auto-commit.sh /usr/local/bin/claude-auto-commit
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

## 🚀 What's New in v0.0.5

- **Template System**: Save and reuse commit message templates
  - Save templates: `--save-template <name> "<template>"`
  - Use templates: `--template <name>` or `-T <name>`
  - List templates: `--list-templates`
  - Delete templates: `--delete-template <name>`
- **Smart placeholders**: Use `{variable}` in templates for dynamic values

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) for Claude CLI
- [Conventional Commits](https://conventionalcommits.org) specification
- Open source community for inspiration

---

**Made with ❤️ for the developer community**

[Report Issues](https://github.com/0xkaz/claude-auto-commit/issues) | [Request Features](https://github.com/0xkaz/claude-auto-commit/issues/new?template=feature_request.md) | [Documentation](https://claude-auto-commit.0xkaz.com)