# Dotfiles

Personal Arch / Omarchy setup, managed with [chezmoi](https://chezmoi.io).

## Bootstrap a fresh machine

After Omarchy is installed:

```sh
curl -fsSL https://raw.githubusercontent.com/mrlorentx/dotfiles/main/bootstrap.sh | bash
```

That installs chezmoi, 1Password (app + CLI), yay, then runs
`chezmoi init --apply` which clones this repo and applies it. The
chezmoi `run_once_` scripts then install everything else via pacman,
yay, and mise.

You'll be prompted once to enable 1Password's CLI integration —
required for the secrets sourcer.

## Layout

```
bootstrap.sh                  fresh-machine bootstrap (Arch/Omarchy)
dot_bashrc                    → ~/.bashrc (sources omarchy defaults + personal)
dot_aliases.sh                → ~/.aliases.sh
dot_tmux.conf                 → ~/.tmux.conf
dot_claude/skills/            → ~/.claude/skills/ (Claude Code skills)
dot_config/
  hypr/                       → ~/.config/hypr/ (Hyprland personal layer)
  mise/config.toml            → ~/.config/mise/config.toml (tool versions)
  nvim/                       → ~/.config/nvim/ (LazyVim config)
  zsh/secrets-{in,sourcer}.zsh → ~/.config/zsh/ (1Password-backed env)
dot_local/bin/                → ~/.local/bin/ (personal scripts)
packages/
  arch.txt                    pacman packages beyond omarchy baseline
  aur.txt                     yay/AUR packages
run_once_before_10-install-system-packages.sh.tmpl
run_once_after_20-install-mise-tools.sh
keymaps/                      ZMK firmware (not deployed, just stored)
```

## Tool layers

- **chezmoi** deploys config files to `$HOME`
- **mise** (`dot_config/mise/config.toml`) installs CLI binaries and
  language runtimes — node, go, gh, chezmoi self-host, golangci-lint,
  stripe-cli, uv, yq, yt-dlp, opencode, zola, bitwarden, pnpm, httpie
- **pacman / yay** (`packages/*.txt`) install daemons, GUI apps, and
  anything that doesn't fit mise's binary-only model
- **Omarchy** provides the base Hyprland desktop and most of its
  package list — these dotfiles only layer extras on top

## Secrets

Schema lives in git at `dot_config/zsh/secrets-in.zsh` as
`op://vault/item/field` references. On the first shell of a new
machine, `secrets-sourcer.zsh` runs `op inject` once to materialize
values into `~/.cache/zsh/secrets.zsh`. Subsequent shells just
`source` the cached file — no per-shell `op` overhead.

## Making changes

```sh
chezmoi edit ~/.bashrc        # edit source, get auto-deploy on save
# or edit ~/.local/share/chezmoi/ directly, then:
chezmoi apply

chezmoi diff                  # preview pending changes
chezmoi cd                    # cd into the source dir
```

To add a tool, edit `dot_config/mise/config.toml` and run
`mise install`. To add a system package, edit `packages/arch.txt` or
`packages/aur.txt` — the next `chezmoi apply` re-runs the install
script (idempotent thanks to `--needed`).
