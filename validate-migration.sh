#!/bin/bash
set -euo pipefail

# Validation Script for Monorepo Migration
# Tests the migration script functionality and validates requirements

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[VALIDATE]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[VALIDATE]${NC} $1"
}

log_error() {
    echo -e "${RED}[VALIDATE]${NC} $1"
}

# Test git resilience configuration
test_git_resilience() {
    log_info "Testing git resilience configuration..."
    
    local pull_rebase=$(git config --get pull.rebase || echo "")
    local merge_names=$(git config --get merge.names || echo "")
    local rerere_enabled=$(git config --get rerere.enabled || echo "")
    
    if [ "$pull_rebase" = "false" ]; then
        log_success "pull.rebase=false ✓"
    else
        log_error "pull.rebase should be false, got: $pull_rebase"
        return 1
    fi
    
    if [ "$merge_names" = "true" ]; then
        log_success "merge.names=true ✓"
    else
        log_error "merge.names should be true, got: $merge_names"
        return 1
    fi
    
    if [ "$rerere_enabled" = "true" ]; then
        log_success "rerere.enabled=true ✓"
    else
        log_error "rerere.enabled should be true, got: $rerere_enabled"
        return 1
    fi
}

# Test script exists and is executable
test_script_executable() {
    log_info "Testing migration script..."
    
    if [ -f "${SCRIPT_DIR}/migrate-to-monorepo.sh" ]; then
        log_success "Migration script exists ✓"
    else
        log_error "Migration script not found"
        return 1
    fi
    
    if [ -x "${SCRIPT_DIR}/migrate-to-monorepo.sh" ]; then
        log_success "Migration script is executable ✓"
    else
        log_error "Migration script is not executable"
        return 1
    fi
}

# Test script structure and required functions
test_script_structure() {
    log_info "Testing script structure..."
    
    local script="${SCRIPT_DIR}/migrate-to-monorepo.sh"
    
    # Check for required functions and features
    local required_patterns=(
        "set -euo pipefail"
        "git filter-repo --force --to-subdirectory-filter"
        "pull.rebase false"
        "merge.names true"
        "rerere.enabled true"
        "allow-unrelated-histories"
        "chore: resolve merge conflicts"
        "SOURCE_REPOS"
        "configure_git_resilience"
        "merge_filtered_repo"
    )
    
    for pattern in "${required_patterns[@]}"; do
        if grep -q -F "$pattern" "$script"; then
            log_success "Found required pattern: $pattern ✓"
        else
            log_error "Missing required pattern: $pattern"
            return 1
        fi
    done
}

# Test .gitignore exists with proper entries
test_gitignore() {
    log_info "Testing .gitignore configuration..."
    
    if [ -f "${SCRIPT_DIR}/.gitignore" ]; then
        log_success ".gitignore exists ✓"
        
        local required_entries=("/tmp/" "node_modules/" "dist/" ".env")
        
        for entry in "${required_entries[@]}"; do
            if grep -q "$entry" "${SCRIPT_DIR}/.gitignore"; then
                log_success "Found .gitignore entry: $entry ✓"
            else
                log_error "Missing .gitignore entry: $entry"
                return 1
            fi
        done
    else
        log_error ".gitignore not found"
        return 1
    fi
}

# Test documentation exists
test_documentation() {
    log_info "Testing documentation..."
    
    if [ -f "${SCRIPT_DIR}/README.md" ]; then
        log_success "README.md exists ✓"
        
        local required_sections=(
            "Monorepo Migration Tool"
            "git-filter-repo"
            "Idempotent Operation"
            "Git Resilience"
            "Prerequisites"
            "Usage"
        )
        
        for section in "${required_sections[@]}"; do
            if grep -q "$section" "${SCRIPT_DIR}/README.md"; then
                log_success "Found documentation section: $section ✓"
            else
                log_error "Missing documentation section: $section"
                return 1
            fi
        done
    else
        log_error "README.md not found"
        return 1
    fi
}

# Test directory structure expectations
test_directory_structure() {
    log_info "Testing expected directory structure..."
    
    # Check that apps directory can be created
    mkdir -p "${SCRIPT_DIR}/test-apps"
    if [ -d "${SCRIPT_DIR}/test-apps" ]; then
        log_success "Can create directory structure ✓"
        rmdir "${SCRIPT_DIR}/test-apps"
    else
        log_error "Cannot create directory structure"
        return 1
    fi
}

# Run all validation tests
main() {
    log_info "Starting validation of monorepo migration setup..."
    
    cd "$SCRIPT_DIR"
    
    local tests=(
        "test_script_executable"
        "test_script_structure"
        "test_git_resilience"
        "test_gitignore"
        "test_documentation"
        "test_directory_structure"
    )
    
    local passed=0
    local failed=0
    
    for test in "${tests[@]}"; do
        log_info "Running test: $test"
        
        if $test 2>/dev/null; then
            ((passed++))
        else
            ((failed++))
            log_error "Test failed: $test"
        fi
        
        echo
    done
    
    log_info "Validation Results:"
    log_success "Passed: $passed tests"
    
    if [ $failed -gt 0 ]; then
        log_error "Failed: $failed tests"
        return 1
    else
        log_success "All validation tests passed! ✓"
        return 0
    fi
}

# Run validation if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi