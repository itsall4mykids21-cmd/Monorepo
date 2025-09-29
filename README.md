# Monorepo Migration Tool & Slot Game App

This repository contains a comprehensive migration script for combining multiple repositories into a single monorepo using `git-filter-repo`, plus a complete slot game application with Supabase integration.

## 🎰 Slot Game App

A modern slot machine game built with Next.js, React, TypeScript, and Supabase. 

### Quick Start

```bash
# Run the slot game app
./run-slot-game.sh
```

Open [http://localhost:3000](http://localhost:3000) to play!

### Features

- 🎰 Interactive 3-reel slot machine
- 🎨 Beautiful UI with animations
- 🏆 Score tracking and leaderboards
- 👤 User authentication (optional - can play as guest)
- 📊 Game analytics with Supabase
- 📱 Responsive design

See `apps/slot-game-app/README.md` for detailed setup instructions.

## 📁 Repository Structure

```
monorepo/
├── apps/
│   └── slot-game-app/           # Next.js slot game application
├── database-schema.sql          # Supabase database schema
├── run-slot-game.sh            # Quick start script for slot game
├── migrate-to-monorepo.sh      # Migration script
└── README.md                   # This file
```

## 🚀 Migration Tool

## Features

- **Automated Migration**: Uses `git-filter-repo` with `--force` and `--to-subdirectory-filter` to migrate source repositories
- **Conflict Resolution**: Handles merge conflicts automatically with fallback strategies (HEAD → main → master)
- **Git Resilience**: Configures git settings for robust operation:
  - `pull.rebase=false`
  - `merge.names=true` 
  - `rerere.enabled=true`
- **Idempotent Operation**: Safe to re-run, cleans up existing remotes and branches
- **Empty Initial Commit**: Creates proper initial commit before merging unrelated histories
- **Comprehensive Logging**: Color-coded output for easy monitoring

## Prerequisites

Install `git-filter-repo`:

```bash
# Using pip
pip install git-filter-repo

# Using package manager (Ubuntu/Debian)
sudo apt install git-filter-repo

# Using package manager (macOS)
brew install git-filter-repo
```

## Usage

### Automatic Migration

Run the migration script from the monorepo root:

```bash
./migrate-to-monorepo.sh
```

### Manual Migration Commands

For reference, the original manual commands:

```bash
( cd next.js && git filter-repo --force --to-subdirectory-filter apps/next.js-from-scratch )
( cd nextjs-with-supabase && git filter-repo --force --to-subdirectory-filter apps/nextjs-with-supabase )
( cd itsall4mykids21-cmd.github.io && git filter-repo --force --to-subdirectory-filter apps/site )
```

## Repository Structure

After migration, repositories will be organized as:

```
monorepo/
├── apps/
│   ├── next.js-from-scratch/    # from next.js repo
│   ├── nextjs-with-supabase/    # from nextjs-with-supabase repo
│   └── site/                    # from itsall4mykids21-cmd.github.io repo
├── migrate-to-monorepo.sh       # Migration script
└── README.md                    # This file
```

## Configuration

The script can be configured by modifying the `SOURCE_REPOS` array in `migrate-to-monorepo.sh`:

```bash
declare -A SOURCE_REPOS=(
    ["source-repo-name"]="target/subdirectory/path"
    # Add more repositories as needed
)
```

## Error Handling

The script includes comprehensive error handling:

- **Missing Repositories**: Warns and continues if source repositories are not found
- **Branch Fallback**: Tries HEAD, main, then master branches automatically
- **Merge Conflicts**: Automatically stages all files and commits with "chore: resolve merge conflicts"
- **Failed Operations**: Logs errors and continues with remaining repositories

## Safety Features

- **Set Strict Mode**: Uses `set -euo pipefail` for robust error handling
- **Cleanup on Exit**: Automatically cleans up temporary files
- **Idempotent**: Safe to run multiple times
- **Backup**: Creates temporary copies before filtering

## Troubleshooting

### git-filter-repo not found
Install git-filter-repo using the instructions in Prerequisites section.

### Permission denied
Make sure the script is executable:
```bash
chmod +x migrate-to-monorepo.sh
```

### Source repository not found
Ensure source repositories are present in the same directory as the script, or update the `SOURCE_REPOS` configuration.

## Development

To modify the migration for different repositories:

1. Update the `SOURCE_REPOS` array with your repository mappings
2. Adjust the `find_best_branch()` function if you have different default branch names
3. Modify conflict resolution strategy in `merge_filtered_repo()` if needed

## License

This migration tool is provided as-is for repository management purposes.
