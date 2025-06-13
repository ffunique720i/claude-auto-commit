# GitHub Repository Settings

This document contains the recommended settings for the Claude Auto-Commit repository.

## Repository About Section

### Description
```
🤖 AI-powered Git commit message generator using Claude CLI. Intelligently analyzes code changes and generates contextual commit messages with multi-language support and advanced features.
```

### Topics/Tags
```
ai
claude
git
commit
automation
bash
shell-script
cli-tool
developer-tools
conventional-commits
artificial-intelligence
code-analysis
devops
productivity
open-source
```

### Website
```
https://claude-auto-commit.0xkaz.com
```

## Repository Settings

### General Settings
- **Visibility**: Public
- **Features**:
  - ✅ Wikis (disabled)
  - ✅ Issues (enabled)
  - ✅ Sponsorships (enabled)
  - ✅ Preserve this repository (enabled)
  - ✅ Discussions (enabled)
  - ✅ Projects (enabled)

### Branch Protection Rules

#### Main Branch Protection
- **Branch name pattern**: `main`
- **Protect matching branches**: ✅
- **Restrict pushes that create files larger than 100MB**: ✅
- **Require a pull request before merging**: ✅
  - Required number of reviewers: 1
  - Dismiss stale reviews: ✅
  - Require review from code owners: ✅
- **Require status checks to pass**: ✅
  - Require branches to be up to date: ✅
- **Require conversation resolution**: ✅
- **Restrict who can push to matching branches**: ✅
  - Allow force pushes: ❌
  - Allow deletions: ❌

### Security Settings
- **Vulnerability alerts**: ✅ Enabled
- **Dependabot alerts**: ✅ Enabled
- **Dependabot security updates**: ✅ Enabled
- **Dependabot version updates**: ✅ Enabled
- **Code scanning alerts**: ✅ Enabled
- **Secret scanning alerts**: ✅ Enabled

## Social Preview

### Recommended Open Graph Image Specifications
- **Size**: 1280×640 pixels
- **Format**: PNG or JPG
- **Content**: 
  - Claude Auto-Commit logo/text
  - Tagline: "AI-Powered Git Commit Messages"
  - Visual representation of the tool in action
  - Clean, professional design with good contrast

### Alternative Text
```
Claude Auto-Commit: AI-powered Git commit message generator using Claude CLI with intelligent code analysis and multi-language support
```

## Release Settings

### Tags and Releases
- **Tag format**: `v{major}.{minor}.{patch}` (e.g., v0.0.5)
- **Release title format**: `Claude Auto-Commit v{version}`
- **Automatic release notes**: ✅ Enabled
- **Pre-release**: Use for beta versions
- **Latest release**: Mark stable versions as latest

### Release Assets
- Primary asset: `claude-auto-commit.sh`
- Checksum file: `checksums.txt` (optional)

## Automation

### GitHub Actions
- **Release workflow**: ✅ Enabled (already configured)
- **Auto-update workflow**: Consider for future
- **Testing workflow**: Consider for CI/CD

### Apps and Integrations
- **Dependabot**: ✅ Enabled
- **CodeQL**: ✅ Enabled for security scanning

## Community Standards

### Files Present
- ✅ README.md
- ✅ LICENSE (MIT)
- ✅ CONTRIBUTING.md
- ✅ CHANGELOG.md
- ✅ Issue templates
- ✅ Pull request template
- ✅ Code of conduct (consider adding)
- ✅ Security policy (consider adding)

### Recommended Additions

#### Code of Conduct
```bash
# Add a code of conduct from GitHub's templates
# Go to Insights > Community > Code of conduct > Add
```

#### Security Policy
```bash
# Add SECURITY.md file
# Describe security vulnerability reporting process
```

## Analytics and Insights

### Traffic Analytics
- Monitor page views, unique visitors
- Track clone and download statistics
- Analyze referrer data

### Community Metrics
- Issues opened/closed ratio
- Pull request activity
- Star growth over time
- Fork activity

## Maintenance

### Regular Tasks
- Review and respond to issues
- Update dependencies
- Monitor security alerts
- Update documentation
- Release new versions
- Community engagement

---

**Note**: These settings should be applied through the GitHub web interface in the repository settings.