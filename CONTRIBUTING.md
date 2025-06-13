# Contributing to Claude Auto-Commit

Thank you for your interest in contributing to Claude Auto-Commit! We welcome contributions from the community.

## 🤝 How to Contribute

### Reporting Issues
1. Check existing [issues](https://github.com/0xkaz/claude-auto-commit/issues) first
2. Use the appropriate issue template
3. Provide detailed information including:
   - Version number
   - Operating system
   - Steps to reproduce
   - Expected vs actual behavior

### Suggesting Features
1. Check if the feature has already been requested
2. Use the feature request template
3. Explain the use case and benefit
4. Be open to discussion and feedback

### Submitting Code Changes

#### Prerequisites
- Git repository with some commit history for testing
- Claude subscription (Pro, Max, or Team)
- Claude CLI installed and configured
- Bash shell (macOS, Linux, or WSL)

#### Development Setup
```bash
# Clone the repository
git clone https://github.com/0xkaz/claude-auto-commit.git
cd claude-auto-commit

# Make the script executable
chmod +x src/claude-auto-commit.sh

# Test the script
./src/claude-auto-commit.sh --help
```

#### Testing Your Changes
Before submitting a pull request, please test your changes:

```bash
# Test basic functionality
./src/claude-auto-commit.sh --dry-run

# Test with different options
./src/claude-auto-commit.sh --dry-run --summary -l en -e

# Test template system
./src/claude-auto-commit.sh --save-template test "Test: {description}"
./src/claude-auto-commit.sh --template test --dry-run

# Test history analysis
./src/claude-auto-commit.sh --analyze-history
```

#### Pull Request Process
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test thoroughly on your system
5. Update documentation if needed
6. Commit with descriptive messages
7. Push to your fork
8. Create a pull request using the template

## 📝 Code Style Guidelines

### Shell Script Best Practices
- Use meaningful variable names
- Add comments for complex logic
- Quote variables properly: `"$VARIABLE"`
- Use `set -e` for error handling where appropriate
- Follow existing indentation (2 spaces)

### Commit Message Format
We use conventional commits for consistency:
```
type(scope): description

feat: add template system
fix: resolve macOS compatibility issue
docs: update installation instructions
```

### Documentation
- Update README.md for new features
- Update help text in the script
- Add examples for new functionality
- Update CHANGELOG.md

## 🧪 Testing

### Manual Testing Checklist
- [ ] Basic commit message generation
- [ ] Dry run mode
- [ ] Different language options
- [ ] Template system
- [ ] History analysis
- [ ] Auto-update functionality
- [ ] Error handling

### Platform Testing
- [ ] macOS (Bash 3.x and 5.x)
- [ ] Linux (various distributions)
- [ ] Windows WSL

## 📋 Release Process

1. Update version in `src/claude-auto-commit.sh`
2. Update CHANGELOG.md
3. Create and test release
4. Tag version: `git tag v0.0.x`
5. Push tag: `git push origin v0.0.x`
6. GitHub Actions will create the release

## 🤔 Questions?

- Check the [README](./README.md) first
- Search [existing issues](https://github.com/0xkaz/claude-auto-commit/issues)
- Create a new issue with the "question" template
- Join discussions in the repository

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Claude Auto-Commit better! 🚀