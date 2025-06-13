# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-06-13

### Added
- `--dry-run` flag for generating commit messages without committing
- `--summary` flag for displaying detailed change statistics
  - File-by-file statistics
  - Lines added/deleted count
  - File type breakdown

### Changed
- Improved change summary display with emoji indicators

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