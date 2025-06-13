# Claude Auto-Commit

<div align="center">

![Claude Auto-Commit Hero](./docs/images/hero-banner.png)

🤖 **AI-powered Git commit message generator using Claude Code SDK**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/releases)
[![npm version](https://img.shields.io/npm/v/claude-auto-commit.svg)](https://www.npmjs.com/package/claude-auto-commit)
[![GitHub stars](https://img.shields.io/github/stars/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/network)
[![GitHub issues](https://img.shields.io/github/issues/0xkaz/claude-auto-commit.svg)](https://github.com/0xkaz/claude-auto-commit/issues)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](https://github.com/0xkaz/claude-auto-commit)
[![Node.js](https://img.shields.io/badge/Node.js-22%2B-green.svg)](https://nodejs.org)
[![Claude Code SDK](https://img.shields.io/badge/Powered%20by-Claude%20Code%20SDK-orange.svg)](https://docs.anthropic.com/en/docs/claude-code)

</div>

Claude Auto-Commit is an open-source tool that automatically generates intelligent Git commit messages by analyzing your code changes using Claude Code SDK. It integrates seamlessly into your development workflow with enhanced performance, reliability, and modern JavaScript architecture.

## 🌟 Transform Your Commit History

<div align="center">

![Before and After Comparison](./docs/images/demo-before-after-english.png)

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

- 🧠 **AI Analysis**: Leverages Claude Code SDK for intelligent code change understanding
- 🌍 **Multi-language**: Interface available in English and Japanese
- 📝 **Conventional Commits**: Optional support for conventional commit format
- 😊 **Emoji Support**: Add contextual emojis to commit messages
- 🔍 **Dry Run Mode**: Preview commit messages without making actual commits
- 📝 **Template System**: Save and reuse common commit message patterns
- ⚙️ **Configuration**: JSON-based configuration file support
- 🔄 **Retry Mechanism**: Enhanced error handling with exponential backoff
- ⚡ **Performance**: Parallel processing and intelligent caching
- 🚀 **Auto-push**: Optional automatic push to remote repository
- 📊 **Verbose Logging**: Detailed execution metrics and statistics
- 🛠️ **Configurable**: Extensive customization through CLI options and config files
- 📦 **Modern Architecture**: Node.js ES modules with TypeScript support

## 📖 Documentation

- [English Documentation](./docs/en/README.md)
- [日本語ドキュメント](./docs/ja/README.md)
- [中文文档](./docs/zh/README.md)

Complete documentation available in this repository.

## 📋 Requirements

### System Requirements
- **Node.js 22.0.0 or later**
- **Git repository**
- **ANTHROPIC_API_KEY environment variable**

### Claude API Access
You need a Claude account with API access:
- **Claude Pro** ($20/month) - Small repositories
- **Claude Max** ($100/month) - Regular development
- **Claude Max** ($200/month) - Large projects/teams

Set your API key:
```bash
export ANTHROPIC_API_KEY="your-api-key"
```

### Auto-Installation Dependencies
The tool automatically installs:
- Claude Code SDK (`@anthropic-ai/claude-code`)
- Required Node.js dependencies

## 🎯 Examples

<div align="center">

![Terminal Demo](./docs/images/demo-english-terminal.png)

*See Claude Auto-Commit in action with the `--summary` flag for detailed change analysis*

</div>

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

### Method 1: Installation Script (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/install.sh | bash
```

### Method 2: Download from GitHub Releases
```bash
# Download the latest release
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

### Method 4: Direct Script Usage
```bash
# For development or testing
git clone https://github.com/0xkaz/claude-auto-commit.git
cd claude-auto-commit
./src/claude-auto-commit.sh [options]
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

## 🚀 What's New in v0.1.4

- **Claude Code SDK Migration**: Migrated from Claude CLI to modern Claude Code SDK
  - Enhanced performance with parallel processing and intelligent caching
  - Exponential backoff retry mechanism for improved reliability
  - Template system with persistent storage
  - JSON configuration file support
- **NPM Package Distribution**: Available via `npx claude-auto-commit`
- **OAuth Authentication**: No API key required for Claude Pro/Max users
- **ES Modules Architecture**: Modern JavaScript with Node.js 22+ support
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

[Report Issues](https://github.com/0xkaz/claude-auto-commit/issues) | [Request Features](https://github.com/0xkaz/claude-auto-commit/issues/new?template=feature_request.md) | [Documentation](https://github.com/0xkaz/claude-auto-commit)