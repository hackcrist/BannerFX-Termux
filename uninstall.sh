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
CONFIG_DIR="$HOME/.config/crist_banner"
ASSETS_DIR="$PREFIX_DIR/share/bannerfx"

for cmd in bannerfx bannerfx-sh bannerfx-zsh; do
  f="$PREFIX_DIR/bin/$cmd"
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "Comando eliminado: $f"
  fi
done

for f in "$HOME/.crist_banner.sh" "$HOME/.crist_banner.py"; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "Banner de inicio eliminado: $f"
  fi
done

if [ -f "$HOME/.bashrc" ]; then
  tmp="$(mktemp)"
  grep -Fv "crist_banner.sh" "$HOME/.bashrc" | grep -Fv "crist_banner.py" > "$tmp" || true
  mv "$tmp" "$HOME/.bashrc"
  echo "Entradas de banner removidas de .bashrc"
fi

if [ -d "$CONFIG_DIR" ]; then
  rm -rf "$CONFIG_DIR"
  echo "Directorio de configuracion eliminado: $CONFIG_DIR"
fi

if [ -d "$ASSETS_DIR" ]; then
  rm -rf "$ASSETS_DIR"
  echo "Assets eliminados: $ASSETS_DIR"
fi

echo "Desinstalacion completada."
