#!/bin/bash

# Claude Auto-Commit Installer
# Usage: curl -fsSL https://claude-auto-commit.0xkaz.com/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="0xkaz/claude-auto-commit"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="claude-auto-commit"
CONFIG_DIR="$HOME/.claude-auto-commit"

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS and architecture
detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    
    case $os in
        darwin) os="darwin" ;;
        linux) os="linux" ;;
        *) 
            print_error "Unsupported OS: $os"
            exit 1
            ;;
    esac
    
    case $arch in
        x86_64) arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *)
            print_error "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
    
    echo "${os}-${arch}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command_exists curl; then
        print_error "curl is required but not installed"
        exit 1
    fi
    
    if ! command_exists git; then
        print_error "git is required but not installed"
        exit 1
    fi
    
    if ! command_exists claude; then
        print_warning "Claude CLI not found. Please install it first:"
        echo "  Visit: https://docs.anthropic.com/claude/cli"
        echo ""
        read -p "Continue installation anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "Dependencies check passed"
}

# Get latest release version
get_latest_version() {
    local version=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$version" ]; then
        print_error "Failed to get latest version"
        exit 1
    fi
    
    echo "$version"
}

# Download and install binary
install_binary() {
    local platform=$(detect_platform)
    local version=$(get_latest_version)
    local url="https://github.com/$REPO/releases/download/$version/${BINARY_NAME}-${platform}"
    
    print_info "Downloading Claude Auto-Commit $version for $platform..."
    
    # Create temporary file
    local tmp_file=$(mktemp)
    
    # Download binary
    if ! curl -L -o "$tmp_file" "$url"; then
        print_error "Failed to download binary"
        rm -f "$tmp_file"
        exit 1
    fi
    
    # Make executable
    chmod +x "$tmp_file"
    
    # Install to system
    if [ -w "$INSTALL_DIR" ]; then
        mv "$tmp_file" "$INSTALL_DIR/$BINARY_NAME"
    else
        print_info "Installing to $INSTALL_DIR (requires sudo)..."
        sudo mv "$tmp_file" "$INSTALL_DIR/$BINARY_NAME"
    fi
    
    print_success "Binary installed to $INSTALL_DIR/$BINARY_NAME"
}

# Create configuration directory
create_config() {
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        print_info "Created config directory: $CONFIG_DIR"
    fi
    
    # Create default config if it doesn't exist
    local config_file="$CONFIG_DIR/config.yml"
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << EOF
auto_update:
  enabled: true
  frequency: daily
  silent: false

defaults:
  language: en
  branch: main
  emoji: false
  conventional: false

git:
  auto_stage: true
  auto_push: true
EOF
        print_info "Created default config: $config_file"
    fi
}

# Check if binary is in PATH
check_installation() {
    if command_exists "$BINARY_NAME"; then
        local version=$($BINARY_NAME --version 2>/dev/null || echo "unknown")
        print_success "Installation successful! Version: $version"
        echo ""
        echo "Usage:"
        echo "  $BINARY_NAME --help"
        echo "  $BINARY_NAME"
        echo ""
        echo "Documentation: https://claude-auto-commit.0xkaz.com"
    else
        print_warning "Binary installed but not in PATH"
        echo "Add $INSTALL_DIR to your PATH or run: export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
}

# Main installation process
main() {
    echo "🤖 Claude Auto-Commit Installer"
    echo "================================"
    echo ""
    
    check_dependencies
    install_binary
    create_config
    check_installation
    
    echo ""
    print_success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Ensure Claude CLI is configured: claude --help"
    echo "2. Navigate to a git repository"
    echo "3. Run: claude-auto-commit"
    echo ""
    echo "For help: claude-auto-commit --help"
}

# Run main function
main "$@"