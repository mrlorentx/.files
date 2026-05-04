#!/usr/bin/env bash
# Fresh-machine bootstrap for Arch/Omarchy.
# Run on a clean install:
#   curl -fsSL https://raw.githubusercontent.com/mrlorentx/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

GITHUB_USER="${GITHUB_USER:-mrlorentx}"

log()  { printf '\033[1;34m▸\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

[[ "$(uname -s)" == "Linux" ]] || die "Linux only"
have pacman || die "pacman not found (need Arch/Omarchy)"

log "Refreshing pacman databases"
sudo pacman -Sy --noconfirm

log "Installing chezmoi, 1Password CLI, build deps"
sudo pacman -S --needed --noconfirm git base-devel chezmoi 1password-cli

if ! have yay; then
  log "Installing yay (AUR helper)"
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

log "Installing 1Password desktop from AUR"
yay -S --needed --noconfirm 1password

cat <<'EOF'

  Open 1Password, sign in, then enable:
    Settings → Developer → Integrate with 1Password CLI

  Press Enter when ready (this is required for the secrets sourcer
  to inject env vars on first shell after bootstrap).
EOF
read -r _

log "Initializing chezmoi from github.com/${GITHUB_USER}/dotfiles"
chezmoi init --apply "$GITHUB_USER"

log "Done. Open a new shell to materialize secrets."
