#!/usr/bin/env bash
set -euo pipefail

# TPM (Tmux Plugin Manager) — required for the @plugin lines in ~/.tmux.conf.
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install/update any plugins declared in ~/.tmux.conf. Safe to run when tmux isn't active.
"$TPM_DIR/bin/install_plugins" >/dev/null || true
"$TPM_DIR/bin/update_plugins" all >/dev/null || true
