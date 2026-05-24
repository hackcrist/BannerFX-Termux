#!/data/data/com.termux/files/usr/bin/bash
# BannerFX-Termux - Desinstalador
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

set -euo pipefail

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
CMD_FILE="$PREFIX_DIR/bin/bannerfx"
CMD_FILE_SH="$PREFIX_DIR/bin/bannerfx-sh"
BANNER_SCRIPT_SH="$HOME/.crist_banner.sh"
BANNER_SCRIPT_PY="$HOME/.crist_banner.py"
BASHRC_FILE="$HOME/.bashrc"
CONFIG_DIR="$HOME/.config/crist_banner"

for f in "$CMD_FILE" "$CMD_FILE_SH"; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "Comando eliminado: $f"
  fi
done

for f in "$BANNER_SCRIPT_SH" "$BANNER_SCRIPT_PY"; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "Banner de inicio eliminado: $f"
  fi
done

if [ -f "$BASHRC_FILE" ]; then
  tmp="$(mktemp)"
  grep -Fv "crist_banner.sh" "$BASHRC_FILE" | grep -Fv "crist_banner.py" > "$tmp" || true
  mv "$tmp" "$BASHRC_FILE"
  echo "Entradas de banner removidas de .bashrc"
fi

if [ -d "$CONFIG_DIR" ]; then
  rm -rf "$CONFIG_DIR"
  echo "Directorio de configuracion eliminado: $CONFIG_DIR"
fi

echo "Desinstalacion completada."
