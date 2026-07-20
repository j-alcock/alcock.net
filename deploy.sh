#!/usr/bin/env bash
# deploy.sh — publish alcock.net and jason.alcock.net to the Dreamhost VPS.
#
# Usage:
#   ./deploy.sh            # deploy both sites, then curl post-checks
#   ./deploy.sh --dry-run  # show what would be transferred; change nothing
#
# SECURITY: this script NEVER reads, stores, or receives a password.
# ssh/rsync/scp prompt the Operator interactively. Do not add sshpass,
# SSHPASS, expect, or key-embedding to this file.

set -euo pipefail

# ----------------------------------------------------------------------
# OPERATOR CONFIG — fill these in (see DEPLOY.md for the assumptions).
# ----------------------------------------------------------------------
VPS_HOST="OPERATOR_VPS_HOST"          # e.g. vps12345.dreamhostps.com or an IP
VPS_USER="OPERATOR_VPS_USER"          # SSH account on the VPS
MAIN_ROOT="~/alcock.net"              # docroot for alcock.net
JASON_ROOT="~/jason.alcock.net"       # docroot for jason.alcock.net
MAIN_URL="https://alcock.net/"
JASON_URL="https://jason.alcock.net/"
# ----------------------------------------------------------------------

DRY_RUN=0
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY_RUN=1

cd "$(dirname "$0")"

if [[ "$VPS_HOST" == "OPERATOR_VPS_HOST" || "$VPS_USER" == "OPERATOR_VPS_USER" ]]; then
  echo "ERROR: edit deploy.sh and set VPS_HOST and VPS_USER first." >&2
  exit 1
fi

for d in site jason; do
  [[ -d "$d" ]] || { echo "ERROR: missing $d/ — run from the repo root." >&2; exit 1; }
done

DEST="${VPS_USER}@${VPS_HOST}"
RSYNC_FLAGS=(-avz --delete)
[[ $DRY_RUN -eq 1 ]] && RSYNC_FLAGS+=(--dry-run) && echo "==> DRY RUN: nothing will be transferred."

push() {
  local src="$1" root="$2"
  echo "==> Deploying ${src}/ to ${DEST}:${root}"
  if command -v rsync >/dev/null 2>&1; then
    rsync "${RSYNC_FLAGS[@]}" "${src}/" "${DEST}:${root}/"
  else
    [[ $DRY_RUN -eq 1 ]] && { echo "    (dry-run, scp fallback would copy ${src}/*)"; return; }
    scp "${src}"/* "${DEST}:${root}/"
  fi
}

push site "$MAIN_ROOT"
push jason "$JASON_ROOT"

if [[ $DRY_RUN -eq 0 ]]; then
  for url in "$MAIN_URL" "$JASON_URL"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$url" || echo "unreachable")
    echo "==> ${url} -> HTTP ${code}"
  done
fi

echo "==> Done."
