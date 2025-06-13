# Claude Auto-Commit

🤖 AI-powered Git commit message generator using Claude CLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/releases)
[![Website](https://img.shields.io/badge/website-claude--auto--commit.0xkaz.com-blue)](https://claude-auto-commit.0xkaz.com/)
[![GitHub stars](https://img.shields.io/github/stars/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/stargazers)

Claude Auto-Commit is an open-source tool that automatically generates intelligent Git commit messages by analyzing your code changes using Claude AI. It integrates seamlessly into your development workflow and supports multiple languages and configurations.

⚠️ **Important**: By default, this tool will automatically stage all changes, commit, and push to your remote repository. You will be prompted before pushing (use `-y` to skip confirmation). Use `-n` flag to disable auto-push, or `-s` flag to manually select files to stage.

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
- ⚡ **Lightweight**: Shell script with minimal dependencies
- 🛠️ **Configurable**: Extensive customization through CLI options and config files

## 📖 Documentation

- [English Documentation](./docs/en/README.md)
- [日本語ドキュメント](./docs/ja/README.md)
- [中文文档](./docs/zh/README.md)

Complete documentation and examples available at [claude-auto-commit.0xkaz.com](https://claude-auto-commit.0xkaz.com)

## 📋 Requirements

- Git repository
- **Claude Code CLI** (requires active Claude subscription)
  - Install Claude Code CLI: `npm install -g @anthropic-ai/claude-cli` or download from [claude.ai/download](https://claude.ai/download)
  - Authenticate: `claude login`
  - **Note**: Claude Code CLI requires an active Claude Pro or Team subscription
- Bash shell (macOS, Linux, WSL)

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

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) for Claude CLI
- [Conventional Commits](https://conventionalcommits.org) specification
- Open source community for inspiration

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

**Made with ❤️ for the developer community**

[Report Issues](https://github.com/0xkaz/claude-auto-commit/issues) | [Request Features](https://github.com/0xkaz/claude-auto-commit/issues/new?template=feature_request.md) | [Documentation](https://claude-auto-commit.0xkaz.com)