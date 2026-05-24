#!/data/data/com.termux/files/usr/bin/bash
# BannerFX-Termux - Instalador
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

set -euo pipefail

readonly VERSION="2.0.0"

if ! command -v pkg >/dev/null 2>&1; then
  echo "Error: este instalador es para Termux (pkg no encontrado)." >&2
  exit 1
fi

SCRIPT_SRC="${BASH_SOURCE[0]:-$0}"
REPO_DIR="$(cd "$(dirname "$SCRIPT_SRC")" && pwd)"
cd "$REPO_DIR"

if [ ! -f "banner-hacker.sh" ] || [ ! -f "banner-hacker.py" ]; then
  echo "Error: No se encuentran banner-hacker.sh o banner-hacker.py en $REPO_DIR" >&2
  exit 1
fi

echo "[1/6] Actualizando paquetes..."
pkg update -y
pkg upgrade -y

echo "[2/8] Instalando dependencias del sistema..."
pkg install -y figlet ruby python bash cowsay

echo "[3/8] Instalando dependencias Python..."
if ! python3 -c "import pyfiglet" 2>/dev/null; then
  pip install pyfiglet --quiet 2>/dev/null || pkg install python-pyfiglet -y 2>/dev/null || echo "  (pyfiglet no disponible, se usara figlet del sistema)"
fi
if ! command -v lolcat >/dev/null 2>&1; then
  gem install lolcat --no-document 2>/dev/null || true
fi

echo "[4/8] Instalando fuentes FIGlet adicionales..."
FIGLET_DIR="${PREFIX:-/data/data/com.termux/files/usr}/share/figlet"
FONT_COUNT=0
if [ -d "core/fonts" ]; then
  mkdir -p "$FIGLET_DIR"
  for f in core/fonts/*.flf; do
    [ -f "$f" ] && cp "$f" "$FIGLET_DIR/" && FONT_COUNT=$((FONT_COUNT + 1))
  done
  echo "  $FONT_COUNT fuentes instaladas en $FIGLET_DIR"
fi

echo "[5/8] Preparando scripts..."
chmod +x banner-hacker.sh banner-hacker.py uninstall.sh

echo "[6/8] Creando comandos globales..."
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"

cat > "$PREFIX_DIR/bin/bannerfx" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# BannerFX v$VERSION - Wrapper Python
set -e
exec python3 "$REPO_DIR/banner-hacker.py" "\$@"
EOF
chmod +x "$PREFIX_DIR/bin/bannerfx"

cat > "$PREFIX_DIR/bin/bannerfx-sh" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# BannerFX v$VERSION - Wrapper Bash
set -e
exec bash "$REPO_DIR/banner-hacker.sh" "\$@"
EOF
chmod +x "$PREFIX_DIR/bin/bannerfx-sh"

if [ -f ".object/.banner.sh" ]; then
  cat > "$PREFIX_DIR/bin/bannerfx-zsh" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# BannerFX v$VERSION - Tema ZSH (h4ck3r0)
set -e
exec bash "$REPO_DIR/.object/.banner.sh" "\$@"
EOF
  chmod +x "$PREFIX_DIR/bin/bannerfx-zsh"
  echo "  Creado 'bannerfx-zsh' (tema ZSH alternativo)"
fi

echo "[7/8] Instalando assets adicionales..."
if [ -d "core/bnr" ]; then
  ASSETS_DIR="$PREFIX_DIR/share/bannerfx"
  mkdir -p "$ASSETS_DIR/bnr" "$ASSETS_DIR/banners" "$ASSETS_DIR/fontxx"
  cp -r core/bnr/* "$ASSETS_DIR/bnr/" 2>/dev/null && echo "  Banners ANSI: $(ls core/bnr | wc -l) instalados"
  cp -r core/banners/* "$ASSETS_DIR/banners/" 2>/dev/null && echo "  Cowsay banners: $(ls core/banners | wc -l) instalados"
  cp -r core/fontxx/* "$ASSETS_DIR/fontxx/" 2>/dev/null && echo "  Fuentes pre-coloreadas: $(ls core/fontxx | wc -l) instaladas"
fi

echo "[8/8] Guardando metadatos de instalacion..."
CONFIG_DIR="$HOME/.config/crist_banner"
mkdir -p "$CONFIG_DIR"
echo "$REPO_DIR" > "$CONFIG_DIR/install_path"
echo "$VERSION" > "$CONFIG_DIR/version"

echo ""
echo "Instalacion completada."
echo ""
echo "  bannerfx        Menu principal (Python)"
echo "  bannerfx-sh     Menu alternativo (Bash)"
if [ -f "$PREFIX_DIR/bin/bannerfx-zsh" ]; then
  echo "  bannerfx-zsh    Tema ZSH alternativo (.object/)"
fi
