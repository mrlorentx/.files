#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# install_plugins reads TMUX_PLUGIN_MANAGER_PATH from a tmux server environment.
# When chezmoi apply runs outside tmux, no server has sourced ~/.config/tmux/tmux.conf yet,
# so we start one, seed the variable, and source the conf so @plugin lines are
# visible to TPM.
tmux start-server
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true

"$TPM_DIR/bin/install_plugins" || true
"$TPM_DIR/bin/update_plugins" all || true

# Re-source so any active sessions pick up the freshly-installed plugins.
tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
