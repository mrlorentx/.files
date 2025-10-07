export DOTFILES_DIR="${HOME}/projects/.files"
secrets_out_path="${DOTFILES_DIR}/zsh/secrets-out.zsh"

if [ -f "${secrets_out_path}" ]; then
  rm "${secrets_out_path}"
fi

op --account "my.1password.com" inject --in-file "${DOTFILES_DIR}/zsh/secrets-in.zsh"  --out-file "${secrets_out_path}" && source "${secrets_out_path}"

