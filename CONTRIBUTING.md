# Contributing to Claude Auto-Commit

Thank you for your interest in contributing to Claude Auto-Commit! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Git
- Bash shell (macOS, Linux, WSL)
- [Claude CLI](https://docs.anthropic.com/claude/cli) for testing
- Basic knowledge of shell scripting

### Development Setup
1. Fork the repository
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-auto-commit.git
   cd claude-auto-commit
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```

## 📝 How to Contribute

### Reporting Bugs
1. Search existing issues to avoid duplicates
2. Use the bug report template
3. Provide clear reproduction steps
4. Include system information (OS, shell version, etc.)

### Suggesting Features
1. Search existing feature requests
2. Use the feature request template
3. Explain the use case and benefits
4. Consider implementation complexity

### Code Contributions

#### Pull Request Process
1. Ensure your code follows the style guide
2. Add tests for new functionality
3. Update documentation as needed
4. Ensure all tests pass
5. Create a clear PR description

#### Code Style Guidelines
- Use 4 spaces for indentation
- Follow shell scripting best practices
- Add comments for complex logic
- Use meaningful variable names
- Keep functions focused and small

#### Testing
- Test on multiple platforms (macOS, Linux)
- Test with different Git repository states
- Verify multi-language functionality
- Test auto-update mechanism

## 🌍 Multi-language Support

### Adding New Languages
1. Add language code to supported languages list
2. Create translation files in appropriate format
3. Update documentation
4. Test with native speakers if possible

### Translation Guidelines
- Maintain technical accuracy
- Respect cultural conventions
- Keep messages concise
- Follow platform-specific standards

## 📚 Documentation

### Writing Documentation
- Use clear, concise language
- Include practical examples
- Keep README files up to date
- Add inline comments for complex code

### Documentation Structure
```
docs/
├── en/          # English documentation
├── ja/          # Japanese documentation
├── zh/          # Chinese documentation
└── ...          # Other languages
```

## 🔧 Technical Guidelines

### Shell Scripting Best Practices
- Use `set -e` for error handling
- Quote variables to prevent word splitting
- Use `local` for function variables
- Implement proper error messages
- Handle edge cases gracefully

### Auto-Update System
- Maintain backward compatibility
- Test update mechanisms thoroughly
- Provide rollback functionality
- Handle network failures gracefully

## 🎯 Project Structure

```
claude-auto-commit/
├── src/                    # Source code
│   └── claude-auto-commit.sh
├── scripts/                # Build and utility scripts
│   ├── install.sh
│   ├── build.sh
│   └── test.sh
├── docs/                   # Multi-language documentation
├── .github/                # GitHub workflows and templates
├── README.md               # Main project documentation
├── LICENSE                 # MIT License
└── CONTRIBUTING.md         # This file
```

## 🏷️ Commit Message Guidelines

We follow Conventional Commits specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions or modifications
- `chore`: Maintenance tasks

### Examples
```
feat(i18n): add Spanish language support

Add Spanish translations for all user-facing messages
and update documentation accordingly.

Closes #123
```

## 📋 Issue Templates

### Bug Report
- Description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- System information
- Additional context

### Feature Request
- Feature description
- Problem it solves
- Proposed solution
- Alternative solutions
- Additional context

## 🔍 Code Review Process

### For Contributors
- Respond to feedback promptly
- Make requested changes
- Keep discussions constructive
- Test thoroughly before requesting review

### For Reviewers
- Be constructive and helpful
- Focus on code quality and functionality
- Consider security implications
- Test changes when possible

## 📊 Performance Considerations

- Minimize external dependencies
- Optimize for common use cases
- Handle large repositories efficiently
- Consider network latency for updates

## 🔒 Security Guidelines

- Never expose API keys or secrets
- Validate all user inputs
- Use secure download methods
- Follow principle of least privilege

## 🏆 Recognition

Contributors will be recognized in:
- Release notes for significant contributions
- README acknowledgments
- GitHub contributors list

## 📞 Getting Help

- Join discussions in GitHub Issues
- Ask questions in appropriate channels
- Reach out to maintainers for guidance

## 📄 License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers the project.

---

Thank you for contributing to Claude Auto-Commit! Your efforts help make development workflows better for everyone. 🚀