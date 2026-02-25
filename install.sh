#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
  echo "Error: este instalador es para Termux (pkg no encontrado)." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "[1/5] Actualizando paquetes..."
pkg update -y
pkg upgrade -y

echo "[2/5] Instalando dependencias del sistema..."
pkg install -y figlet ruby bash

echo "[3/5] Instalando lolcat (si falta)..."
if ! command -v lolcat >/dev/null 2>&1; then
  gem install lolcat --no-document
fi

echo "[4/5] Preparando script principal..."
chmod +x banner-hacker.sh

echo "[5/5] Creando comando global..."
PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
TARGET="$PREFIX_DIR/bin/bannerfx"

cat > "$TARGET" << EOF
#!/data/data/com.termux/files/usr/bin/bash
set -e
exec bash "$REPO_DIR/banner-hacker.sh" "\$@"
EOF

chmod +x "$TARGET"

echo "Instalacion completada."
echo "Ejecuta: bannerfx"
