#!/usr/bin/env bash
set -euo pipefail

if command -v mise >/dev/null 2>&1; then
  mise install
else
  echo "mise not found on PATH; check that arch.txt installed it" >&2
  exit 1
fi
