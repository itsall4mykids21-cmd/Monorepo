#!/bin/bash
set -euo pipefail

# Demo Migration Script
# Demonstrates the monorepo migration functionality with mock repositories
# This script creates sample repositories and runs the migration to test functionality

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="${SCRIPT_DIR}/demo"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[DEMO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[DEMO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[DEMO]${NC} $1"
}

# Create sample repositories for demonstration
create_demo_repos() {
    log_info "Creating demo repositories..."
    
    mkdir -p "$DEMO_DIR"
    cd "$DEMO_DIR"
    
    # Create sample repos
    local repos=("next.js" "nextjs-with-supabase" "itsall4mykids21-cmd.github.io")
    
    for repo in "${repos[@]}"; do
        if [ ! -d "$repo" ]; then
            log_info "Creating demo repository: $repo"
            
            mkdir -p "$repo"
            cd "$repo"
            
            git init
            git config user.email "demo@example.com"
            git config user.name "Demo User"
            
            # Create some sample files
            echo "# $repo" > README.md
            echo "console.log('Hello from $repo');" > index.js
            echo "node_modules/" > .gitignore
            
            git add .
            git commit -m "Initial commit for $repo"
            
            # Create a few more commits for history
            echo "// Updated code" >> index.js
            git add index.js
            git commit -m "Update index.js"
            
            echo "# Documentation" > docs.md
            git add docs.md
            git commit -m "Add documentation"
            
            cd ..
            log_success "Created demo repository: $repo"
        else
            log_info "Demo repository already exists: $repo"
        fi
    done
    
    cd "$SCRIPT_DIR"
}

# Test the migration script functionality
test_migration() {
    log_info "Testing migration functionality..."
    
    # Copy demo repos to the main directory for migration
    cd "$SCRIPT_DIR"
    
    for repo in next.js nextjs-with-supabase itsall4mykids21-cmd.github.io; do
        if [ -d "${DEMO_DIR}/${repo}" ] && [ ! -d "$repo" ]; then
            log_info "Copying demo repo: $repo"
            cp -r "${DEMO_DIR}/${repo}" "$repo"
        fi
    done
    
    # Test git resilience configuration
    log_info "Testing git resilience configuration..."
    
    # Check current git config
    log_info "Current git configuration:"
    git config --get pull.rebase || echo "  pull.rebase: not set"
    git config --get merge.names || echo "  merge.names: not set"
    git config --get rerere.enabled || echo "  rerere.enabled: not set"
    
    # Apply resilience settings
    git config pull.rebase false
    git config merge.names true
    git config rerere.enabled true
    
    log_success "Git resilience settings applied"
    
    # Verify settings
    log_info "Updated git configuration:"
    echo "  pull.rebase: $(git config --get pull.rebase)"
    echo "  merge.names: $(git config --get merge.names)"
    echo "  rerere.enabled: $(git config --get rerere.enabled)"
}

# Create directory structure test
test_directory_structure() {
    log_info "Testing directory structure creation..."
    
    # Create apps directory and subdirectories
    mkdir -p apps/next.js-from-scratch
    mkdir -p apps/nextjs-with-supabase
    mkdir -p apps/site
    
    # Create .gitkeep files
    touch apps/next.js-from-scratch/.gitkeep
    touch apps/nextjs-with-supabase/.gitkeep
    touch apps/site/.gitkeep
    
    log_success "Directory structure created"
    
    # Show the structure
    log_info "Created directory structure:"
    tree apps 2>/dev/null || find apps -type d | sed 's/^/  /'
}

# Simulate git-filter-repo functionality (for demo purposes)
simulate_filter_repo() {
    local repo_name="$1"
    local target_dir="$2"
    
    log_info "Simulating git-filter-repo for $repo_name -> $target_dir"
    
    if [ -d "$repo_name" ]; then
        # Copy files to target directory structure
        mkdir -p "$target_dir"
        cp -r "$repo_name"/* "$target_dir/" 2>/dev/null || true
        cp -r "$repo_name"/.git* "$target_dir/" 2>/dev/null || true
        
        log_success "Simulated filtering of $repo_name to $target_dir"
    else
        log_warning "Repository $repo_name not found for simulation"
    fi
}

# Test the complete migration process
test_complete_migration() {
    log_info "Testing complete migration process..."
    
    # Simulate the migration for each repository
    declare -A repos=(
        ["next.js"]="apps/next.js-from-scratch"
        ["nextjs-with-supabase"]="apps/nextjs-with-supabase"
        ["itsall4mykids21-cmd.github.io"]="apps/site"
    )
    
    for repo in "${!repos[@]}"; do
        simulate_filter_repo "$repo" "${repos[$repo]}"
    done
    
    # Add and commit the changes
    git add apps/
    
    if git diff --staged --quiet; then
        log_info "No changes to commit"
    else
        git commit -m "demo: simulate monorepo migration"
        log_success "Committed simulated migration changes"
    fi
}

# Cleanup demo files
cleanup_demo() {
    log_info "Cleaning up demo files..."
    
    # Remove demo repositories from main directory
    for repo in next.js nextjs-with-supabase itsall4mykids21-cmd.github.io; do
        if [ -d "$repo" ]; then
            rm -rf "$repo"
            log_info "Removed demo repo: $repo"
        fi
    done
    
    # Remove demo directory
    if [ -d "$DEMO_DIR" ]; then
        rm -rf "$DEMO_DIR"
        log_info "Removed demo directory"
    fi
    
    log_success "Demo cleanup completed"
}

# Main demo function
main() {
    log_info "Starting monorepo migration demo..."
    
    cd "$SCRIPT_DIR"
    
    # Create demo repositories
    create_demo_repos
    
    # Test migration functionality
    test_migration
    
    # Test directory structure creation
    test_directory_structure
    
    # Test complete migration process
    test_complete_migration
    
    # Show results
    log_info "Demo migration results:"
    if [ -d "apps" ]; then
        find apps -type f | head -10 | sed 's/^/  /'
        if [ $(find apps -type f | wc -l) -gt 10 ]; then
            echo "  ... and $(( $(find apps -type f | wc -l) - 10 )) more files"
        fi
    fi
    
    log_success "Demo completed successfully!"
    
    # Ask if user wants to cleanup
    read -p "Do you want to clean up demo files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cleanup_demo
    else
        log_info "Demo files preserved for inspection"
    fi
}

# Handle script interruption
trap cleanup_demo EXIT

# Run demo if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi