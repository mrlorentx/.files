# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/joakimlorentz/.zsh/completions:"* ]]; then export FPATH="/Users/joakimlorentz/.zsh/completions:$FPATH"; fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/Users/joakimlorentz/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH="/Users/joakimlorentz/Library/Python/3.9/bin:$PATH"
plugins=(
	git
	macos
	direnv
	fzf
	history
	autojump
	zsh-interactive-cd
      )

source $ZSH/oh-my-zsh.sh
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && \. "/usr/local/opt/nvm/etc/bash_completion"

source <(fzf --zsh)

source ~/projects/.files/.aliases

# Prefer brew git over apple git
export PATH=/opt/homebrew/bin:$PATH

#Better ls
alias ls='lsd'
alias l='ls -l -1'
alias la='ls -a -1'
alias lla='ls -la -1'
alias lt='ls --tree'


export PROJECTS="/users/joakimlorentz/Projects"

source ~/projects/.files/zsh/secrets-sourcer.zsh


export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_HOST_OVERRIDE=$(colima ls -j | jq -r '.address')
export DOCKER_HOST=unix:///$HOME/.colima/docker.sock

[[ -s "/Users/joakimlorentz/.gvm/scripts/gvm" ]] && source "/Users/joakimlorentz/.gvm/scripts/gvm"
export GPG_TTY=$(tty)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/joakimlorentz/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

eval "$(starship init zsh)"

go env -w GOPRIVATE='github.com/TV4\/*'
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

export GPG_TTY=$(tty)
