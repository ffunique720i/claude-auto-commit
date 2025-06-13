# Claude Auto-Commit

🤖 AI-powered Git commit message generator using Claude CLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/0xkaz/claude-auto-commit/releases)

Claude Auto-Commit is an open-source tool that automatically generates intelligent Git commit messages by analyzing your code changes using Claude AI. It integrates seamlessly into your development workflow and supports multiple languages and configurations.

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