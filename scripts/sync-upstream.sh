#!/usr/bin/env bash
# sync-upstream.sh — Sync files from azure-agentic-infraops (source) to the workshop repo.
#
# Reads .sync-config.json at the workspace root, clones the source repo,
# and copies autoSync + reviewSync files into the current working tree.
# Generates a SYNC-MANIFEST.md with a diff report for use in issue bodies.
#
# Usage:
#   ./scripts/sync-upstream.sh [--dry-run] [--ref <tag-or-sha>]
#
# Options:
#   --dry-run   Show what would change without modifying any files
#   --ref       Checkout a specific tag, branch, or commit in the source repo
#
# Requires: git, jq, rsync

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG="$REPO_ROOT/.sync-config.json"
MANIFEST="$REPO_ROOT/SYNC-MANIFEST.md"
TMPDIR=""
DRY_RUN=false
SOURCE_REF=""

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

cleanup() {
  if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
    rm -rf "$TMPDIR"
  fi
}
trap cleanup EXIT

log()  { echo "  ℹ️  $*"; }
warn() { echo "  ⚠️  $*" >&2; }
err()  { echo "  ❌ $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --ref)     SOURCE_REF="$2"; shift 2 ;;
    *)         err "Unknown option: $1" ;;
  esac
done

# ---------------------------------------------------------------------------
# Validate prerequisites
# ---------------------------------------------------------------------------

for cmd in git jq rsync; do
  command -v "$cmd" >/dev/null 2>&1 || err "$cmd is required but not installed."
done

[[ -f "$CONFIG" ]] || err ".sync-config.json not found at $CONFIG"

# ---------------------------------------------------------------------------
# Read configuration
# ---------------------------------------------------------------------------

SOURCE_OWNER=$(jq -r '.source.owner' "$CONFIG")
SOURCE_REPO=$(jq -r '.source.repo' "$CONFIG")
DEFAULT_REF=$(jq -r '.source.defaultRef' "$CONFIG")
SOURCE_REF="${SOURCE_REF:-$DEFAULT_REF}"

SOURCE_URL="https://github.com/${SOURCE_OWNER}/${SOURCE_REPO}.git"

log "Source : $SOURCE_URL @ $SOURCE_REF"
log "Dry run: $DRY_RUN"

# ---------------------------------------------------------------------------
# Clone source repo
# ---------------------------------------------------------------------------

TMPDIR=$(mktemp -d)
log "Cloning source into $TMPDIR ..."
git clone --depth 1 --branch "$SOURCE_REF" "$SOURCE_URL" "$TMPDIR/source" 2>/dev/null \
  || git clone --depth 1 "$SOURCE_URL" "$TMPDIR/source" 2>/dev/null

if [[ -n "$SOURCE_REF" && "$SOURCE_REF" != "$DEFAULT_REF" ]]; then
  (cd "$TMPDIR/source" && git checkout "$SOURCE_REF" 2>/dev/null) || true
fi

SOURCE_SHA=$(cd "$TMPDIR/source" && git rev-parse --short HEAD)
log "Source commit: $SOURCE_SHA"

# ---------------------------------------------------------------------------
# Build rsync include / exclude lists from config
# ---------------------------------------------------------------------------

build_file_list() {
  local tier="$1"
  jq -r ".${tier}[]" "$CONFIG"
}

INCLUDE_FILE="$TMPDIR/includes.txt"
EXCLUDE_FILE="$TMPDIR/excludes.txt"
NEVERSYNC_FILE="$TMPDIR/neversync.txt"

# autoSync patterns — copy unconditionally
build_file_list "autoSync" > "$INCLUDE_FILE"

# reviewSync patterns — also copy (flagged in manifest)
build_file_list "reviewSync" >> "$INCLUDE_FILE"

# neverSync patterns — exclude
build_file_list "neverSync" > "$NEVERSYNC_FILE"

# ---------------------------------------------------------------------------
# Expand glob patterns into actual file lists
# ---------------------------------------------------------------------------

expand_patterns() {
  local base_dir="$1"
  local pattern_file="$2"
  while IFS= read -r pattern; do
    # Use find with glob matching via bash
    (cd "$base_dir" && eval "find . -path './$pattern' -type f 2>/dev/null") || true
  done < "$pattern_file" | sed 's|^\./||' | sort -u
}

SOURCE_DIR="$TMPDIR/source"
SYNC_FILES="$TMPDIR/sync-files.txt"
NEVER_FILES="$TMPDIR/never-files.txt"

expand_patterns "$SOURCE_DIR" "$INCLUDE_FILE" > "$SYNC_FILES"
expand_patterns "$SOURCE_DIR" "$NEVERSYNC_FILE" > "$NEVER_FILES"

# Remove any neverSync matches from the sync list
if [[ -s "$NEVER_FILES" ]]; then
  grep -Fxvf "$NEVER_FILES" "$SYNC_FILES" > "$TMPDIR/filtered.txt" || true
  mv "$TMPDIR/filtered.txt" "$SYNC_FILES"
fi

TOTAL_SYNC=$(wc -l < "$SYNC_FILES" | tr -d ' ')
log "Files to sync: $TOTAL_SYNC"

if [[ "$TOTAL_SYNC" -eq 0 ]]; then
  log "No files match sync patterns. Nothing to do."
  exit 0
fi

# ---------------------------------------------------------------------------
# Diff and copy
# ---------------------------------------------------------------------------

ADDED=()
MODIFIED=()
DELETED_CANDIDATES=()
REVIEW_FLAGS=()

# Load reviewSync patterns for flagging
REVIEW_PATTERNS=()
while IFS= read -r p; do
  REVIEW_PATTERNS+=("$p")
done < <(build_file_list "reviewSync")

is_review_file() {
  local file="$1"
  for pattern in "${REVIEW_PATTERNS[@]}"; do
    if [[ "$file" == $pattern ]]; then
      return 0
    fi
  done
  return 1
}

while IFS= read -r file; do
  src="$SOURCE_DIR/$file"
  dst="$REPO_ROOT/$file"

  if [[ ! -f "$src" ]]; then
    continue
  fi

  if [[ ! -f "$dst" ]]; then
    ADDED+=("$file")
    if [[ "$DRY_RUN" == "false" ]]; then
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
    fi
  elif ! diff -q "$src" "$dst" > /dev/null 2>&1; then
    MODIFIED+=("$file")
    if is_review_file "$file"; then
      REVIEW_FLAGS+=("$file")
    fi
    if [[ "$DRY_RUN" == "false" ]]; then
      cp "$src" "$dst"
    fi
  fi
done < "$SYNC_FILES"

TOTAL_CHANGES=$(( ${#ADDED[@]} + ${#MODIFIED[@]} ))

if [[ "$TOTAL_CHANGES" -eq 0 ]]; then
  log "All sync-safe files are already up to date. Nothing to do."
  rm -f "$MANIFEST"
  exit 0
fi

# ---------------------------------------------------------------------------
# Generate manifest
# ---------------------------------------------------------------------------

{
  echo "# Upstream Sync Manifest"
  echo ""
  echo "> Auto-generated by \`scripts/sync-upstream.sh\`"
  echo ""
  echo "**Source**: \`${SOURCE_OWNER}/${SOURCE_REPO}\` @ \`${SOURCE_SHA}\`"
  echo "**Date**: $(date -u +%Y-%m-%d)"
  echo "**Files changed**: $TOTAL_CHANGES"
  echo ""

  if [[ ${#ADDED[@]} -gt 0 ]]; then
    echo "## Added (${#ADDED[@]})"
    echo ""
    for f in "${ADDED[@]}"; do
      echo "- \`$f\`"
    done
    echo ""
  fi

  if [[ ${#MODIFIED[@]} -gt 0 ]]; then
    echo "## Modified (${#MODIFIED[@]})"
    echo ""
    for f in "${MODIFIED[@]}"; do
      local_flag=""
      if is_review_file "$f"; then
        local_flag=" ⚠️ **reviewSync** — check for workshop compatibility"
      fi
      echo "- \`$f\`${local_flag}"
    done
    echo ""
  fi

  if [[ ${#REVIEW_FLAGS[@]} -gt 0 ]]; then
    echo "## ⚠️ Files Needing Workshop Review"
    echo ""
    echo "These files are in the \`reviewSync\` tier. They were copied from"
    echo "upstream but may contain source-specific content (e.g. \`scenarios/\`"
    echo "references) that doesn't apply to the workshop."
    echo ""
    for f in "${REVIEW_FLAGS[@]}"; do
      echo "- \`$f\`"
    done
    echo ""
  fi

  echo "---"
  echo "*To preview changes locally: \`./scripts/sync-upstream.sh --dry-run\`*"
} > "$MANIFEST"

if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY RUN — no files were modified."
  echo ""
  echo "=== Changes that would be applied ==="
  echo ""
  [[ ${#ADDED[@]} -gt 0 ]] && echo "Added (${#ADDED[@]}):" && printf '  + %s\n' "${ADDED[@]}"
  [[ ${#MODIFIED[@]} -gt 0 ]] && echo "Modified (${#MODIFIED[@]}):" && printf '  ~ %s\n' "${MODIFIED[@]}"
  echo ""
  echo "Total: $TOTAL_CHANGES file(s)"
else
  log "Synced $TOTAL_CHANGES file(s). Manifest written to SYNC-MANIFEST.md."
fi
