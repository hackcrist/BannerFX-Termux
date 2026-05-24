#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

readonly VERSION="2.0.0"

if ! command -v pkg >/dev/null 2>&1; then
  echo "Error: este instalador es para Termux (pkg no encontrado)." >&2
  exit 1
fi

SCRIPT_SRC="${BASH_SOURCE[0]:-$0}"
REPO_DIR="$(cd "$(dirname "$SCRIPT_SRC")" && pwd)"
cd "$REPO_DIR"

if [ ! -f "banner-hacker.sh" ]; then
  echo "Error: No se encuentra banner-hacker.sh en $REPO_DIR" >&2
  exit 1
fi

echo "[1/6] Actualizando paquetes..."
pkg update -y
pkg upgrade -y

echo "[2/6] Instalando dependencias del sistema..."
pkg install -y figlet ruby bash

echo "[3/6] Instalando lolcat (si falta)..."
if ! command -v lolcat >/dev/null 2>&1; then
  gem install lolcat --no-document
fi

echo "[4/6] Preparando scripts..."
chmod +x banner-hacker.sh
chmod +x uninstall.sh

echo "[5/6] Creando comando global..."
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
TARGET="$PREFIX_DIR/bin/bannerfx"

cat > "$TARGET" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# BannerFX v$VERSION - Wrapper generado por install.sh
set -e
exec bash "$REPO_DIR/banner-hacker.sh" "\$@"
EOF

chmod +x "$TARGET"

echo "[6/6] Guardando metadatos de instalacion..."
CONFIG_DIR="$HOME/.config/crist_banner"
mkdir -p "$CONFIG_DIR"
echo "$REPO_DIR" > "$CONFIG_DIR/install_path"
echo "$VERSION" > "$CONFIG_DIR/version"

echo "Instalacion completada."
echo "Ejecuta: bannerfx"
