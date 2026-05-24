# BannerFX-Termux

BannerFX-Termux es un script para Termux que personaliza tu terminal con un banner estilo hacker usando `figlet` y `lolcat`.

## Caracteristicas

- Menu interactivo.
- Personalizacion del nombre del banner.
- 8 estilos modernos: neon, matrix, clean, retro, fire, ocean, glitch, minimal-dark.
- Python y Bash: version principal en Python, fallback en Bash (`bannerfx-sh`).
- Vista previa antes de instalar.
- Modo aleatorio opcional.
- Guardar/cargar perfiles.
- Instalar y desinstalar banner de inicio en `.bashrc`.
- CLI: `bannerfx --help` y `bannerfx --version`.

## Requisitos (Termux)

- Termux
- `figlet`
- `ruby` (para `gem`)
- `lolcat`

*(El instalador los descarga automaticamente)*

## Instalacion rapida

```bash
pkg update -y && pkg upgrade -y && pkg install -y git && ( [ -d BannerFX-Termux/.git ] && cd BannerFX-Termux && git pull || git clone https://github.com/hackcrist/BannerFX-Termux.git && cd BannerFX-Termux ) && sed -i 's/\r$//' install.sh uninstall.sh banner-hacker.sh && chmod +x install.sh && bash install.sh
```

## Instalacion paso a paso

```bash
pkg update && pkg upgrade -y
pkg install -y git

git clone https://github.com/hackcrist/BannerFX-Termux.git
cd BannerFX-Termux
sed -i 's/\r$//' install.sh uninstall.sh banner-hacker.sh
chmod +x install.sh
bash install.sh
```

## Uso

Ejecutar desde cualquier carpeta:

```bash
bannerfx              # Version Python (principal)
bannerfx-sh           # Version Bash (fallback)
```

CLI:

```bash
bannerfx --help      # Muestra ayuda
bannerfx --version   # Muestra la version
```

O directamente desde el repositorio:

```bash
python3 banner-hacker.py   # Version Python
bash banner-hacker.sh      # Version Bash
```

## Actualizar

```bash
cd ~/BannerFX-Termux
git pull
chmod +x install.sh
bash install.sh
```

## Desinstalar

```bash
cd ~/BannerFX-Termux
bash uninstall.sh
```

*(El `uninstall.sh` ya tiene permisos de ejecucion si usaste el instalador. Elimina el comando global, el banner de inicio y toda la configuracion).*

## Solucion de problemas

Si obtienes `syntax error: unexpected end of file`, convierte los saltos de linea a LF:

```bash
sed -i 's/\r$//' install.sh uninstall.sh banner-hacker.sh
chmod +x install.sh uninstall.sh banner-hacker.sh
bash install.sh
```

Si `bannerfx` no se encuentra despues de instalar:

```bash
hash -r
source ~/.bashrc
bannerfx
```

## Archivos

- `banner-hacker.sh`: script principal (v2.0.0).
- `install.sh`: instalador para Termux.
- `uninstall.sh`: elimina comando global, banner y configuracion.

## Autor

hackcrist

## Licencia

Este proyecto esta licenciado bajo Apache License 2.0.
Ver `LICENSE` y `NOTICE` para detalles.

