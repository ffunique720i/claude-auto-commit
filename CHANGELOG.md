# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-06-14

### 🎉 Major Version Update: CLI to SDK Migration

This release marks a significant architectural shift from Claude CLI dependency to Claude Code SDK integration, providing improved performance, reliability, and extensibility.

### Added
- ✨ Full Claude Code SDK integration (replaces CLI dependency)
- 📝 Enhanced template support for saving and reusing commit messages
- ⚙️  Configuration file support (~/.claude-auto-commit/config.json)
- 🔄 Retry mechanism with exponential backoff
- 🚀 Auto-push functionality
- 📊 Verbose logging and performance metrics
- 🌐 Enhanced multi-language support (English and Japanese)
- 😊 Emoji support in commit messages
- 📋 Conventional Commits format support
- 🔧 One-liner installer and runner scripts
- ⚡ Performance optimizations (parallel processing, caching)
- 🛡️  Enhanced error handling and resilience
- 📦 NPM package support for global installation

### Changed
- **BREAKING**: Migrated from Claude CLI to Claude Code SDK
- **BREAKING**: Node.js 22.0.0+ now required (upgraded from 16.0.0+)
- **BREAKING**: Main script changed from `.sh` to `.js` (src/claude-auto-commit.js)
- **BREAKING**: Installation method updated for SDK dependencies
- Improved structured codebase with object-oriented design
- Enhanced documentation and usage examples
- Updated installation process for SDK dependencies

### Technical Details
- Dependencies: @anthropic-ai/claude-code ^1.0.22
- Runtime: Node.js 22.0.0+ with ES modules support
- Architecture: Full JavaScript/TypeScript implementation
- Performance: Parallel git command execution, intelligent caching
- NPM: Available as both global CLI and local package

### Migration from v0.0.5
All core features from the CLI-based v0.0.5 are maintained with significant improvements:
- Backward compatible command-line interface
- Enhanced reliability and error handling
- Better performance and user experience
- Extended functionality with templates and configuration

### Installation Options
```bash
# Method 1: One-liner installation (recommended)
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/install.sh | bash

# Method 2: NPM global installation
npm install -g claude-auto-commit

# Method 3: One-time execution (no installation)
curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/run-once.sh | bash
```

### Usage Examples
```bash
# Basic usage
claude-auto-commit

# Japanese with emojis and conventional commits
claude-auto-commit -l ja -e -c

# Use specific commit type and auto-push
claude-auto-commit -t feat --push

# Dry run with template saving
claude-auto-commit --dry-run --save-template my-template

# Use saved template
claude-auto-commit --template my-template
```

### Configuration
Create `~/.claude-auto-commit/config.json`:
```json
{
  "language": "ja",
  "useEmoji": true,
  "conventionalCommit": true,
  "verbose": false
}
```

### Requirements
- Node.js 22.0.0 or later
- Claude Code SDK (automatically installed)
- Git repository
- ANTHROPIC_API_KEY environment variable

## [0.0.5] - 2024-06-13

### Added
- **Template System** for saving and reusing commit message patterns
  - `--save-template <name> "<template>"` to save a template
  - `--template <name>` or `-T <name>` to use a saved template
  - `--list-templates` to show all saved templates
  - `--delete-template <name>` to remove a template
- **Smart placeholders** in templates using `{variable}` syntax
  - Prompts for values when using templates with placeholders
  - Supports multiple placeholders in a single template
  - Example: `🔥 HOTFIX: {description} - fixes {issue}`
- Templates stored in `~/.claude-auto-commit/templates/`

## [0.0.4] - 2024-06-13

### Added
- `--smart-group` flag to analyze and group related files for logical commits
  - Detects frontend, backend, tests, docs, config, and style files
  - Shows file categories and statistics
  - Supports verbose mode for detailed file listings
- `--analyze-history` command to learn from commit history
  - Analyzes emoji usage patterns
  - Calculates average commit message length
  - Detects common commit prefixes
  - Identifies language preferences
  - Saves results to `~/.claude-auto-commit/commit-style.yml`
- `--style learned` option to apply learned commit patterns
  - Uses analyzed emoji usage percentage
  - Targets learned average message length
  - Automatically enables emoji if usage > 50%

### Fixed
- macOS compatibility for grep commands (removed -P flag)
- Bash 3.x compatibility (removed associative arrays)

## [0.0.3] - 2024-06-13

### Added
- `--dry-run` flag for generating commit messages without committing
- `--summary` flag for displaying detailed change statistics
  - File-by-file statistics
  - Lines added/deleted count
  - File type breakdown

### Changed
- **BREAKING**: Changed default interface language from Japanese to English
- All system messages, prompts, and outputs now default to English
- Help text and usage information displayed in English
- Error messages and status updates in English
- Comments in source code translated to English
- Improved change summary display with emoji indicators

### Fixed
- Consistent language experience for international users
- Better compatibility with global development teams

## [0.0.2] - 2024-06-13

### Added
- Push confirmation prompt before pushing to remote repository
- `-y` / `--yes` flag to skip push confirmation
- CHANGELOG.md file

### Changed
- Default behavior now asks for confirmation before pushing
- Updated documentation to reflect new push confirmation feature

### Security
- Prevents accidental pushes to remote repository

## [0.0.1] - 2024-06-13

### Added
- Initial release
- AI-powered commit message generation using Claude CLI
- Multi-language support (English, Japanese, Chinese)
- Auto-update functionality
- Conventional Commits support
- Configurable options through CLI flags and config file
- One-line installation script
- Comprehensive documentation

[0.0.2]: https://github.com/0xkaz/claude-auto-commit/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/0xkaz/claude-auto-commit/releases/tag/v0.0.1