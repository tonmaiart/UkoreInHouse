#!/usr/bin/env bash
# git release [commit message]
# Stages all changes, commits, pushes to the current branch, and watches
# the GitHub Actions workflow build + deploy the MkDocs site to GitHub Pages.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

git add -A

if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

message="${*:-}"
if [ -z "$message" ]; then
    read -r -p "Commit message: " message
    if [ -z "$message" ]; then
        message="Update docs $(date '+%Y-%m-%d %H:%M')"
    fi
fi

git commit -m "$message"

branch="$(git rev-parse --abbrev-ref HEAD)"
git push origin "$branch"

echo "Pushed to origin/$branch."

if command -v gh >/dev/null 2>&1; then
    echo "Watching GitHub Actions deployment..."
    sleep 5
    run_id="$(gh run list --branch "$branch" --limit 1 --json databaseId -q '.[0].databaseId')"
    if [ -n "$run_id" ]; then
        gh run watch "$run_id" --exit-status
    fi
else
    echo "Install GitHub CLI (gh) to auto-watch the deploy: https://cli.github.com/"
fi

echo "Done. Site: https://tonmaiart.github.io/UkoreInHouse/"
