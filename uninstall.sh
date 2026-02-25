#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
CMD_FILE="$PREFIX_DIR/bin/bannerfx"
BANNER_SCRIPT="$HOME/.crist_banner.sh"
BASHRC_FILE="$HOME/.bashrc"
BASHRC_HOOK='[ -f "$HOME/.crist_banner.sh" ] && bash "$HOME/.crist_banner.sh"'

if [ -f "$CMD_FILE" ]; then
  rm -f "$CMD_FILE"
  echo "Comando global eliminado: bannerfx"
else
  echo "No existe comando global bannerfx"
fi

if [ -f "$BANNER_SCRIPT" ]; then
  rm -f "$BANNER_SCRIPT"
  echo "Banner de inicio eliminado: $BANNER_SCRIPT"
fi

if [ -f "$BASHRC_FILE" ]; then
  tmp="$(mktemp)"
  grep -Fvx "$BASHRC_HOOK" "$BASHRC_FILE" > "$tmp" || true
  mv "$tmp" "$BASHRC_FILE"
  echo "Entrada del banner removida de $BASHRC_FILE"
fi

echo "Desinstalacion completada."
