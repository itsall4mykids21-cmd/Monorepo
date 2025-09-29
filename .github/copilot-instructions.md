# Copilot Instructions for Monorepo Migration Tool

This repository contains a comprehensive migration script for combining multiple repositories into a single monorepo using `git-filter-repo`.

## Repository Context

This is a shell script-based tool that:
- Migrates multiple repositories into a single monorepo structure
- Uses `git-filter-repo` for history-preserving migrations
- Handles merge conflicts automatically
- Configures git settings for resilient operations
- Provides validation and testing scripts

## Key Files

- `migrate-to-monorepo.sh` - Main migration script
- `demo-migration.sh` - Demo/testing script  
- `validate-migration.sh` - Validation and testing script
- `README.md` - Comprehensive documentation
- `package.json` - Basic package configuration

## Architecture Overview

The tool follows a modular approach:
- **Configuration**: `SOURCE_REPOS` associative array maps source repos to target paths
- **Logging**: Color-coded output using standardized functions
- **Error Handling**: Robust with `set -euo pipefail` and comprehensive error checking
- **Git Operations**: Uses advanced git features for safe history rewriting
- **Validation**: Built-in testing framework for verification

## Development Guidelines

### Shell Script Best Practices
- Always use `set -euo pipefail` for robust error handling
- Use color-coded logging functions (log_info, log_success, log_warning, log_error)
- Follow the existing pattern for temporary file handling in `/tmp`
- Test scripts with the validation script before committing

### Git Operations
- The tool configures specific git settings for resilience:
  - `pull.rebase=false`
  - `merge.names=true`
  - `rerere.enabled=true`
- Uses `git filter-repo` with `--force` and `--to-subdirectory-filter`
- Handles merge conflicts with automatic resolution strategies

### Testing and Validation
- Run `./validate-migration.sh` to test script functionality
- Use `./demo-migration.sh` for testing with demo repositories
- Ensure all scripts remain executable (`chmod +x`)
- Test idempotent behavior (safe to run multiple times)

### Repository Structure
- Source repos are mapped to `apps/` subdirectories
- Temporary files go in `${SCRIPT_DIR}/tmp`
- Configuration is in the `SOURCE_REPOS` associative array

### Conflict Resolution
- Scripts handle conflicts automatically with fallback strategies
- Branch fallback order: HEAD → main → master
- Merge conflicts are staged and committed with "chore: resolve merge conflicts"

### Documentation
- Keep README.md updated with any changes to features or usage
- Include comprehensive error handling and troubleshooting sections
- Document all configuration options and prerequisites

## Common Tasks

When modifying this tool:

1. **Adding new source repositories**: Update the `SOURCE_REPOS` array in `migrate-to-monorepo.sh`
2. **Changing directory structure**: Modify target paths in `SOURCE_REPOS` and update validation tests
3. **Modifying git settings**: Update `configure_git_resilience()` function
4. **Adding validation**: Extend tests in `validate-migration.sh`

## Safety Considerations

- This tool modifies git history using `git-filter-repo --force`
- Always test changes with demo repositories first
- Ensure backup strategies are in place before running migrations
- The tool is designed to be idempotent and safe to re-run

## Dependencies

- `git-filter-repo` must be installed (via pip, apt, or brew)
- Standard bash utilities and git
- No Node.js dependencies despite having package.json

## Code Examples and Patterns

### Adding a New Source Repository

To add a new repository to the migration:

```bash
# In migrate-to-monorepo.sh, update SOURCE_REPOS array:
declare -A SOURCE_REPOS=(
    ["next.js"]="apps/next.js-from-scratch"
    ["nextjs-with-supabase"]="apps/nextjs-with-supabase"  
    ["itsall4mykids21-cmd.github.io"]="apps/site"
    ["new-repo"]="apps/new-app"  # Add new mapping here
)
```

### Logging Pattern

Always use the established logging functions:

```bash
log_info "Starting migration process..."
log_success "Migration completed successfully ✓"
log_warning "Source repository not found, skipping..."
log_error "Failed to merge repository"
```

### Error Handling Pattern

Follow the established error handling pattern:

```bash
if some_command; then
    log_success "Operation completed"
else
    log_error "Operation failed, continuing with next step"
    return 1
fi
```

### Testing New Features

Always test changes using the validation framework:

```bash
# Add new test functions to validate-migration.sh
test_new_feature() {
    log_info "Testing new feature..."
    
    if [[ condition ]]; then
        log_success "New feature test passed ✓"
    else
        log_error "New feature test failed"
        return 1
    fi
}
```

## Troubleshooting Guide

### Common Issues

1. **Script permissions**: Ensure scripts are executable with `chmod +x script.sh`
2. **git-filter-repo not found**: Install using package manager or pip
3. **Merge conflicts**: The tool handles these automatically with `--allow-unrelated-histories`
4. **Empty repositories**: Tool creates initial commit if repository is empty

### Development Workflow

1. Make changes to scripts
2. Run `./validate-migration.sh` to test
3. Use `./demo-migration.sh` for integration testing
4. Update documentation if needed
5. Commit changes with descriptive messages

## Best Practices for Contributors

- Preserve the idempotent nature of operations
- Always clean up temporary files and directories
- Use the established color-coded logging system
- Test with both empty and populated repositories
- Maintain backward compatibility with existing configurations
- Document any new configuration options in README.md