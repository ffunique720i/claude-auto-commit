# FAQ - Frequently Asked Questions

## General Questions

### What is Claude Auto-Commit?
Claude Auto-Commit is an AI-powered tool that automatically generates meaningful Git commit messages by analyzing your code changes using Claude AI.

### How does it work?
The tool examines your staged and unstaged changes, sends a summary to Claude CLI, and generates an appropriate commit message based on the context and nature of your changes.

### ⚠️ Does it automatically push to remote?
**Yes, by default Claude Auto-Commit will:**
1. Stage all changes (`git add -A`)
2. Create a commit with the generated message
3. **Ask for confirmation before pushing** (NEW in v0.0.2)
4. Push to the remote repository if confirmed

To skip the push confirmation prompt, use the `-y` or `--yes` flag:
```bash
claude-auto-commit -y
```

To disable auto-push entirely, use the `-n` or `--no-push` flag:
```bash
claude-auto-commit -n
```

To manually select files to stage, use the `-s` or `--no-stage` flag:
```bash
claude-auto-commit -s
```

### Is it free to use?
Yes, Claude Auto-Commit is open-source and free to use. However, you need:
- **Claude Pro subscription** ($20/month) or Team plan
- **Claude Code CLI** installed and authenticated

The tool itself is free, but it requires Claude's API services which are paid.

## Installation Issues

### The installation script fails
1. Ensure you have `curl` and `git` installed
2. Check your internet connection
3. Try manual installation:
   ```bash
   curl -L -o claude-auto-commit https://github.com/0xkaz/claude-auto-commit/releases/latest/download/claude-auto-commit.sh
   chmod +x claude-auto-commit
   sudo mv claude-auto-commit /usr/local/bin/
   ```

### Command not found after installation
Add `/usr/local/bin` to your PATH:
```bash
export PATH="/usr/local/bin:$PATH"
```

### Permission denied errors
Use `sudo` for installation or install to a user directory:
```bash
mkdir -p ~/.local/bin
curl -L -o ~/.local/bin/claude-auto-commit https://github.com/0xkaz/claude-auto-commit/releases/latest/download/claude-auto-commit.sh
chmod +x ~/.local/bin/claude-auto-commit
export PATH="$HOME/.local/bin:$PATH"
```

## Usage Issues

### Claude CLI not found
You need to install Claude Code CLI first:

1. **Subscribe to Claude Pro or Team**
   - Visit: https://claude.ai
   - Subscribe to Claude Pro ($20/month) or Team plan
   - This is required to use Claude Code CLI

2. **Install Claude Code CLI**
   ```bash
   # Option 1: Using npm
   npm install -g @anthropic-ai/claude-cli
   
   # Option 2: Download from website
   # Visit: https://claude.ai/download
   ```

3. **Authenticate**
   ```bash
   claude login
   ```

### No changes detected
- Ensure you have uncommitted changes
- Check `git status` to see your changes
- Use `-s` flag to manually stage files

### Generated message is not appropriate
- Use `-t` to specify commit type (feat, fix, docs, etc.)
- Use `-c` for Conventional Commits format
- Edit the message with `e` option when prompted

### Auto-push fails
- Check your Git remote configuration
- Ensure you have push permissions
- Use `-n` flag to disable auto-push

## Configuration

### Where is the config file?
Default location: `~/.claude-auto-commit/config.yml`

### How to disable auto-updates?
Edit config file:
```yaml
auto_update:
  enabled: false
```

### How to change default language?
Edit config file:
```yaml
defaults:
  language: en  # or ja, zh, etc.
```

### How to disable auto-push by default?
Edit config file:
```yaml
git:
  auto_push: false  # Disable auto-push globally
```

## Troubleshooting

### Debug mode
Run with verbose output:
```bash
claude-auto-commit -v
```

### Check version
```bash
claude-auto-commit --version
```

### Reset configuration
```bash
rm -rf ~/.claude-auto-commit
```

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