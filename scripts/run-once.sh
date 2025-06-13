#!/bin/bash

# Claude Auto Commit SDK - One-time Execution Script
# Usage: curl -fsSL https://raw.githubusercontent.com/0xkaz/claude-auto-commit/main/scripts/run-once.sh | bash

set -e

TEMP_DIR="/tmp/claude-auto-commit-$$"
REPO_URL="https://github.com/0xkaz/claude-auto-commit"

echo "🚀 Running Claude Auto Commit SDK (One-time execution)"
echo "   No installation required - temporary execution"
echo ""

# Check prerequisites
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js is required. Please install: https://nodejs.org"
    exit 1
fi

NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -z "$NODE_VERSION" ] || [ "$NODE_VERSION" -lt 22 ]; then
    echo "❌ Node.js 22+ required. Current: $(node -v)"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git is required"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "❌ Please run this in a git repository"
    exit 1
fi

# Check for Claude Code SDK
if ! command -v claude >/dev/null 2>&1; then
    echo "⚠️  Claude Code SDK not found. Installing temporarily..."
    npm install -g @anthropic-ai/claude-code
fi

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "📥 Downloading Claude Auto Commit SDK..."

# Download and extract
git clone --depth 1 "$REPO_URL" . 2>/dev/null || {
    curl -sL "$REPO_URL/archive/main.tar.gz" | tar xz --strip-components=1
}

# Install dependencies
echo "📦 Installing dependencies..."
npm install --silent

# Check Claude CLI authentication
if ! claude -p "test" >/dev/null 2>&1; then
    echo "⚠️  Claude CLI not authenticated"
    echo "   Please run: claude login"
    echo "   (Requires Claude Pro/Max subscription)"
    echo ""
    exit 1
fi

# Parse command line arguments and pass them through
echo "🤖 Running claude-auto-commit..."
node src/claude-auto-commit.js "$@"

# Cleanup
echo ""
echo "🧹 Cleaning up temporary files..."
cd /
rm -rf "$TEMP_DIR"

echo "✅ Done! One-time execution completed."