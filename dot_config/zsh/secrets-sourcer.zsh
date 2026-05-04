secrets_in_path="${HOME}/.config/zsh/secrets-in.zsh"
secrets_out_path="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/secrets.zsh"

mkdir -p "$(dirname "$secrets_out_path")"

# Parse keys from secrets-in.zsh
keys=$(awk -F= '/^export / {gsub(/export |"/, "", $1); print $1}' "$secrets_in_path")

all_keys_present=true
if [ -f "$secrets_out_path" ]; then
  for key in $keys; do
    if ! grep -qE "^export $key=\"[^\"]+\"" "$secrets_out_path"; then
      all_keys_present=false
      break
    fi
  done
else
  all_keys_present=false
fi

if [ "$all_keys_present" = true ]; then
  source "$secrets_out_path"
else
  op --account "my.1password.com" inject --in-file "$secrets_in_path" --out-file "$secrets_out_path" && source "$secrets_out_path"
fi
