# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Omarchy defaults
source ~/.local/share/omarchy/default/bash/rc

# Personal config
source ~/.config/zsh/secrets-sourcer.zsh
source ~/.aliases.sh

# Tool integrations
complete -C '/usr/local/bin/aws_completer' aws
eval "$(mise activate bash)"

export CLIPSSH_HOST=mrlorentx@forge

# gcloud SDK
[ -f "$HOME/gcloud/google-cloud-sdk/path.bash.inc" ] && . "$HOME/gcloud/google-cloud-sdk/path.bash.inc"
[ -f "$HOME/gcloud/google-cloud-sdk/completion.bash.inc" ] && . "$HOME/gcloud/google-cloud-sdk/completion.bash.inc"

