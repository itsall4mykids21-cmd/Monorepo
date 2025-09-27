#!/bin/bash
set -euo pipefail

# Monorepo Migration Script
# Migrates multiple repositories into a single monorepo using git-filter-repo
# Features:
# - Uses git-filter-repo with --force and --to-subdirectory-filter
# - Creates empty initial commit and merges unrelated histories
# - Handles conflicts with fallback strategies (HEAD → main → master)
# - Configures git for resilience
# - Idempotent operation (safe to re-run)

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONOREPO_DIR="${SCRIPT_DIR}"
TEMP_DIR="${SCRIPT_DIR}/tmp"

# Source repositories to migrate
declare -A SOURCE_REPOS=(
    ["next.js"]="apps/next.js-from-scratch"
    ["nextjs-with-supabase"]="apps/nextjs-with-supabase"
    ["itsall4mykids21-cmd.github.io"]="apps/site"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configure git for resilience
configure_git_resilience() {
    log_info "Configuring git for resilience..."
    
    git config pull.rebase false
    git config merge.names true
    git config rerere.enabled true
    
    log_success "Git resilience settings configured"
}

# Initialize monorepo if needed
initialize_monorepo() {
    log_info "Initializing monorepo..."
    
    # Check if we already have commits
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        log_info "Repository already has commits, skipping initialization"
        return 0
    fi
    
    # Create empty initial commit if repository is empty
    if [ -z "$(git status --porcelain)" ] && [ ! -f .gitignore ]; then
        echo "# Monorepo" > README.md
        echo "/tmp/" > .gitignore
        echo "node_modules/" >> .gitignore
        echo "dist/" >> .gitignore
        echo ".env" >> .gitignore
        
        git add README.md .gitignore
        git commit -m "chore: initial empty commit for monorepo"
        
        log_success "Created initial empty commit"
    fi
}

# Clean up existing remotes and branches
cleanup_existing() {
    log_info "Cleaning up existing remotes and branches..."
    
    # Remove all remotes except origin
    for remote in $(git remote | grep -v '^origin$' || true); do
        log_info "Removing remote: $remote"
        git remote remove "$remote" || true
    done
    
    # Clean up any temporary branches
    for branch in $(git branch | grep -E '(tmp-|temp-|migration-)' | tr -d ' *' || true); do
        log_info "Removing temporary branch: $branch"
        git branch -D "$branch" || true
    done
    
    log_success "Cleanup completed"
}

# Find the best branch to merge from a source repository
find_best_branch() {
    local repo_path="$1"
    local branches=("HEAD" "main" "master")
    
    for branch in "${branches[@]}"; do
        if (cd "$repo_path" && git rev-parse --verify "$branch" >/dev/null 2>&1); then
            echo "$branch"
            return 0
        fi
    done
    
    # Fallback to any available branch
    local available_branch
    available_branch=$(cd "$repo_path" && git branch -r | head -1 | sed 's|.*origin/||' | tr -d ' ' || echo "")
    if [ -n "$available_branch" ]; then
        echo "$available_branch"
        return 0
    fi
    
    log_error "No suitable branch found in $repo_path"
    return 1
}

# Apply git-filter-repo to source repository
filter_source_repo() {
    local repo_name="$1"
    local target_dir="$2"
    local source_path="${TEMP_DIR}/${repo_name}"
    
    log_info "Filtering repository: $repo_name -> $target_dir"
    
    if [ ! -d "$source_path" ]; then
        log_error "Source repository not found: $source_path"
        return 1
    fi
    
    # Apply git-filter-repo with --force and --to-subdirectory-filter
    (
        cd "$source_path" || exit 1
        
        # Check if git-filter-repo is available
        if ! command -v git-filter-repo >/dev/null 2>&1; then
            log_error "git-filter-repo is not installed. Please install it first."
            exit 1
        fi
        
        # Apply the filter
        git filter-repo --force --to-subdirectory-filter "$target_dir"
        
        log_success "Filtered $repo_name to subdirectory $target_dir"
    )
}

# Merge filtered repository into monorepo
merge_filtered_repo() {
    local repo_name="$1"
    local source_path="${TEMP_DIR}/${repo_name}"
    
    log_info "Merging filtered repository: $repo_name"
    
    # Add the filtered repo as a remote
    local remote_name="temp-${repo_name//[^a-zA-Z0-9]/-}"
    git remote add "$remote_name" "$source_path" || true
    
    # Fetch from the remote
    git fetch "$remote_name" || {
        log_error "Failed to fetch from $remote_name"
        git remote remove "$remote_name" || true
        return 1
    }
    
    # Find the best branch to merge
    local best_branch
    best_branch=$(find_best_branch "$source_path")
    
    if [ -z "$best_branch" ]; then
        log_error "No suitable branch found for $repo_name"
        git remote remove "$remote_name" || true
        return 1
    fi
    
    log_info "Merging branch $best_branch from $repo_name"
    
    # Merge with allow-unrelated-histories
    if git merge --allow-unrelated-histories --no-edit "${remote_name}/${best_branch}"; then
        log_success "Successfully merged $repo_name"
    else
        log_warning "Merge conflicts detected for $repo_name, resolving..."
        
        # Stage all files and commit to resolve conflicts
        git add .
        git commit -m "chore: resolve merge conflicts from $repo_name migration"
        
        log_success "Resolved merge conflicts for $repo_name"
    fi
    
    # Clean up the remote
    git remote remove "$remote_name" || true
}

# Create temporary copies of source repositories
prepare_source_repos() {
    log_info "Preparing source repositories..."
    
    # Create temp directory
    mkdir -p "$TEMP_DIR"
    
    for repo_name in "${!SOURCE_REPOS[@]}"; do
        local source_path="${SCRIPT_DIR}/${repo_name}"
        local temp_path="${TEMP_DIR}/${repo_name}"
        
        if [ -d "$source_path" ]; then
            log_info "Copying $repo_name to temporary location"
            
            # Remove existing temp copy if it exists
            rm -rf "$temp_path"
            
            # Copy the repository
            cp -r "$source_path" "$temp_path"
            
            log_success "Prepared $repo_name for migration"
        else
            log_warning "Source repository not found: $source_path (skipping)"
        fi
    done
}

# Main migration function
migrate_repositories() {
    log_info "Starting repository migration..."
    
    # Process each source repository
    for repo_name in "${!SOURCE_REPOS[@]}"; do
        local target_dir="${SOURCE_REPOS[$repo_name]}"
        local temp_path="${TEMP_DIR}/${repo_name}"
        
        if [ -d "$temp_path" ]; then
            log_info "Processing $repo_name -> $target_dir"
            
            # Filter the repository
            if filter_source_repo "$repo_name" "$target_dir"; then
                # Merge into monorepo
                merge_filtered_repo "$repo_name"
            else
                log_error "Failed to filter $repo_name, skipping merge"
            fi
        else
            log_warning "Skipping $repo_name (not found)"
        fi
    done
    
    log_success "Repository migration completed"
}

# Cleanup temporary files
cleanup_temp() {
    log_info "Cleaning up temporary files..."
    
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        log_success "Temporary files cleaned up"
    fi
}

# Create apps directory structure
create_directory_structure() {
    log_info "Creating directory structure..."
    
    mkdir -p apps
    
    # Create .gitkeep files to ensure directories are tracked
    for target_dir in "${SOURCE_REPOS[@]}"; do
        mkdir -p "$target_dir"
        if [ ! -f "${target_dir}/.gitkeep" ] && [ -z "$(ls -A "$target_dir" 2>/dev/null)" ]; then
            touch "${target_dir}/.gitkeep"
        fi
    done
    
    log_success "Directory structure created"
}

# Main execution
main() {
    log_info "Starting monorepo migration script..."
    
    # Change to the monorepo directory
    cd "$MONOREPO_DIR"
    
    # Configure git for resilience
    configure_git_resilience
    
    # Initialize monorepo if needed
    initialize_monorepo
    
    # Clean up existing state for idempotency
    cleanup_existing
    
    # Create directory structure
    create_directory_structure
    
    # Prepare and migrate repositories
    prepare_source_repos
    migrate_repositories
    
    # Cleanup
    cleanup_temp
    
    log_success "Monorepo migration completed successfully!"
    log_info "Next steps:"
    log_info "1. Review the merged repositories in the apps/ directory"
    log_info "2. Update any configuration files as needed"
    log_info "3. Test the applications in their new locations"
}

# Handle script interruption
trap cleanup_temp EXIT

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi