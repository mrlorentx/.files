export DOTFILES_DIR="${HOME}/.files"
secrets_out_path="${DOTFILES_DIR}/zsh/secrets-out.zsh"

# Step 1: Parse keys from secrets-in.zsh
keys=$(awk -F= '/^export / {gsub(/export |"/, "", $1); print $1}' "${DOTFILES_DIR}/zsh/secrets-in.zsh")

all_keys_present=true
if [ -f "${secrets_out_path}" ]; then
  # Step 2: For each key, check secrets-out.zsh for a non-empty value
  for key in $keys; do
    if ! grep -qE "^export $key=\"[^\"]+\"" "${secrets_out_path}"; then
      all_keys_present=false
      break
    fi
  done
fi

# Step 3: If all keys are present and valid, just source secrets-out.zsh
# else, run the 1Password injection
if [ "$all_keys_present" = true ] && [ -f "${secrets_out_path}" ]; then
  echo "All secrets are up to date. Sourcing secrets-out.zsh."
  source "${secrets_out_path}"
else
  op --account "my.1password.com" inject --in-file "${DOTFILES_DIR}/zsh/secrets-in.zsh"  --out-file "${secrets_out_path}" && source "${secrets_out_path}"
fi

