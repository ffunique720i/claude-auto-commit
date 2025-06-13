# FAQ - Frequently Asked Questions (v0.1.0)

## General Questions

### What is Claude Auto-Commit?
Claude Auto-Commit is an AI-powered tool that automatically generates meaningful Git commit messages by analyzing your code changes using Claude Code SDK with enhanced performance and reliability.

### How does it work?
The tool examines your staged and unstaged changes, uses Claude Code SDK to analyze them, and generates an appropriate commit message based on the context and nature of your changes with improved speed and accuracy.

### ⚠️ Does it automatically push to remote?
**By default, Claude Auto-Commit will:**
1. Stage all changes (`git add .`)
2. Create a commit with the generated message
3. **NOT push automatically** (changed in v0.1.0)

To enable auto-push, use the `--push` flag:
```bash
claude-auto-commit --push
```

To preview without committing, use the `--dry-run` flag:
```bash
claude-auto-commit --dry-run
```

### Is it free to use?
Yes, Claude Auto-Commit is open-source and free to use. However, you need:
- **Claude API access** (Pro/Max plan with API key)
- **Node.js 22.0.0+** installed
- **Claude Pro/Max subscription**
- **Claude CLI authentication** (run `claude login`)

The tool itself is free, but it requires Claude Pro/Max subscription. No API key needed - uses OAuth authentication.

## Authentication Issues

### How do I authenticate with Claude?
Run `claude login` and choose option 2: "Claude app (requires Max subscription)". This opens your browser for OAuth authentication.

### Do I need an API key?
No! Claude Auto-Commit uses Claude Code SDK with OAuth authentication. Just run `claude login` once.

### What if I get "authentication failed" errors?
1. Ensure you have Claude Pro/Max subscription
2. Run `claude login` to re-authenticate
3. Check that `claude -p "test"` works in your terminal

### Can I use my existing ANTHROPIC_API_KEY?
No, Claude Code SDK uses OAuth authentication, not API keys. Use `claude login` instead.

## Installation Issues

### The installation script fails
1. Ensure you have `curl`, `git`, and `Node.js 22+` installed
2. Check your internet connection
3. Try alternative installation methods:
   ```bash
   # Method 1: NPM global installation
   npm install -g claude-auto-commit
   
   # Method 2: One-time execution
   curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/run-once.sh | bash
   ```

### Node.js version issues
Ensure you have Node.js 22.0.0 or later:
```bash
node --version  # Should show v22.0.0 or later
```

Update Node.js if needed:
- Visit: https://nodejs.org/
- Use nvm: `nvm install 22 && nvm use 22`

### Command not found after installation
Add `~/.local/bin` to your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Permission denied errors
Use NPM global installation or user directory:
```bash
# NPM method (recommended)
npm install -g claude-auto-commit

# Or manual user installation
mkdir -p ~/.local/bin
# Follow one-liner installer
```

## Usage Issues

### ANTHROPIC_API_KEY not set
You need to set your Claude API key:

1. **Get your API key**
   - Visit: https://console.anthropic.com/
   - Create an account with Claude Pro/Max plan
   - Generate an API key

2. **Set the environment variable**
   ```bash
   # Temporary (current session)
   export ANTHROPIC_API_KEY="your-api-key-here"
   
   # Permanent (add to ~/.bashrc or ~/.zshrc)
   echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Claude Code SDK installation fails
The tool automatically installs the SDK, but if it fails:
```bash
# Manual installation
npm install -g @anthropic-ai/claude-code
```

### No changes detected
- Ensure you have uncommitted changes
- Check `git status` to see your changes
- Files are automatically staged in v0.1.0

### Generated message is not appropriate
- Use `-t` to specify commit type (feat, fix, docs, etc.)
- Use `-c` for Conventional Commits format
- Use `--dry-run` to preview before committing
- Save good messages as templates with `--save-template`

### Push fails when using --push
- Check your Git remote configuration
- Ensure you have push permissions
- Check branch existence on remote

### Performance is slow
v0.1.0 includes performance optimizations:
- Parallel git command execution
- Intelligent caching
- Use `--verbose` to see timing metrics

## Configuration

### Where is the config file?
Default location: `~/.claude-auto-commit/config.json` (changed to JSON in v0.1.0)

### How to change default language?
Edit config file:
```json
{
  "language": "en",
  "useEmoji": false,
  "conventionalCommit": false,
  "verbose": false
}
```

### How to enable auto-push by default?
Currently auto-push is disabled by default. Use `--push` flag or future config option.

### Template management
Templates are stored in: `~/.claude-auto-commit/templates/`
```bash
# List templates
claude-auto-commit --list-templates

# Use template
claude-auto-commit --template my-template
```

## Troubleshooting

### Debug mode
Run with verbose output to see performance metrics:
```bash
claude-auto-commit --verbose
```

### Check version
```bash
claude-auto-commit --help  # Shows version in help text
```

### Reset configuration
```bash
rm -rf ~/.claude-auto-commit
```

### Migration from v0.0.5
If upgrading from CLI version:
1. Install new SDK version
2. Set ANTHROPIC_API_KEY environment variable
3. Old config.yml will be ignored (JSON format now)
4. Templates need to be recreated

## Contributing

### How can I contribute?
- Report bugs via GitHub Issues
- Submit feature requests
- Create pull requests
- Improve documentation
- Add translations

### Where to report bugs?
https://github.com/0xkaz/claude-auto-commit/issues

## Need More Help?

- Documentation: https://claude-auto-commit.0xkaz.com
- GitHub: https://github.com/0xkaz/claude-auto-commit
- Issues: https://github.com/0xkaz/claude-auto-commit/issues