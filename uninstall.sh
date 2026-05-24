#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
CMD_FILE="$PREFIX_DIR/bin/bannerfx"
BANNER_SCRIPT="$HOME/.crist_banner.sh"
BASHRC_FILE="$HOME/.bashrc"
CONFIG_DIR="$HOME/.config/crist_banner"
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
else
  echo "No existe archivo de banner"
fi

if [ -f "$BASHRC_FILE" ]; then
  # Usar grep sin -x para tolerar espacios al final de la linea
  tmp="$(mktemp)"
  grep -Fv "$BASHRC_HOOK" "$BASHRC_FILE" > "$tmp" || true
  mv "$tmp" "$BASHRC_FILE"
  echo "Entrada del banner removida de $BASHRC_FILE"
fi

if [ -d "$CONFIG_DIR" ]; then
  rm -rf "$CONFIG_DIR"
  echo "Directorio de configuracion eliminado: $CONFIG_DIR"
fi

echo "Desinstalacion completada."
