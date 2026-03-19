# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/Users/joakimlorentz/bin

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

source ~/projects/.files/.aliases

# Prefer brew git over apple git
export PATH=/opt/homebrew/bin:$PATH

#Better ls
alias ls='lsd'
alias l='ls -l -1'
alias la='ls -a -1'
alias lla='ls -la -1'
alias lt='ls --tree'

# pnpm
export PNPM_HOME="/Users/joakimlorentz/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mrlorentx/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mrlorentx/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mrlorentx/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/home/mrlorentx/gcloud/google-cloud-sdk/completion.bash.inc'; fi
