<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.0-brightgreen" alt="Version">
  <img src="https://img.shields.io/badge/python-3.8+-blue" alt="Python">
  <img src="https://img.shields.io/badge/platform-Termux-red" alt="Termux">
  <img src="https://img.shields.io/badge/license-Apache%202.0-yellow" alt="License">
</p>

<pre align="center">
  ____                  _   __  __ _   _____
 | __ )  __ _ _ __   __| | |  \/  | | |__   |
 |  _ \ / _` | '_ \ / _` | | |\/| | |   / /
 | |_) | (_| | | | | (_| | | |  | | |_ / /_
 |____/ \__,_|_| |_|\__,_| |_|  |_|_(_)____|

     BannerFX - Personaliza tu terminal Termux
</pre>

**BannerFX** es una herramienta para Termux que genera banners personalizados con estilo hacker usando `figlet` y colores animados. Disponible en **Python** (principal) y **Bash** (fallback).

---

## Caracteristicas

- Menu interactivo con 8 estilos visuales
- Vista previa en vivo antes de instalar
- Modo aleatorio para sorpresa cada vez que abres la terminal
- Sistema de perfiles: guarda y carga configuraciones
- CLI con `--help` y `--version`
- Instalacion y desinstalacion limpia en `.bashrc`

### Estilos disponibles

| #  | Estilo       | Descripcion                 |
|----|--------------|-----------------------------|
| 1  | `neon`       | slant + arcoiris dinamico   |
| 2  | `matrix`     | verde fijo                  |
| 3  | `clean`      | minimalista                 |
| 4  | `retro`      | big + tono calido           |
| 5  | `fire`       | tono fuego                  |
| 6  | `ocean`      | tono azul profundo          |
| 7  | `glitch`     | doble capa con offset       |
| 8  | `minimal-dark` | gris tenue                |
| 9  | `cowsay`       | arte ASCII animal aleatorio (71 animales) |

---

## Instalacion

### Requisitos

| Paquete     | Como se instala     |
|-------------|---------------------|
| Termux      | F-Droid / GitHub    |
| Python      | Automatico          |
| figlet      | Automatico          |
| pyfiglet    | Automatico          |
| cowsay      | Automatico          |

> El instalador resuelve todas las dependencias automaticamente.

### Rapida (una linea)

```bash
pkg update -y && pkg upgrade -y && pkg install -y git && ( [ -d BannerFX-Termux/.git ] && cd BannerFX-Termux && git pull || git clone https://github.com/hackcrist/BannerFX-Termux.git && cd BannerFX-Termux ) && chmod +x install.sh && bash install.sh
```

### Paso a paso

```bash
pkg update && pkg upgrade -y
pkg install -y git

git clone https://github.com/hackcrist/BannerFX-Termux.git
cd BannerFX-Termux
chmod +x install.sh
bash install.sh
```

---

## Uso

Una vez instalado, ejecuta desde cualquier carpeta:

```bash
bannerfx              # Version Python (recomendada)
bannerfx-sh           # Version Bash (alternativa)
bannerfx-zsh          # Tema ZSH alternativo (.object/)
```

### Opciones CLI

```bash
bannerfx --help       # Muestra la ayuda
bannerfx --version    # Muestra la version
```

### Ejecucion directa (sin instalar)

```bash
python3 banner-hacker.py   # Version Python
bash banner-hacker.sh      # Version Bash
```

---

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

Elimina el comando global, el banner de inicio y toda la configuracion.

---

## Solucion de problemas

| Problema                        | Solucion                          |
|---------------------------------|-----------------------------------|
| `bannerfx: command not found`   | `hash -r; source ~/.bashrc`       |
| El banner no aparece al abrir   | Verifica que `~/.crist_banner.py` exista y tenga permisos |
| Error de dependencias           | `pkg install -y figlet python; pip install pyfiglet` |

---

## Assets incluidos

Ademas de los scripts, el proyecto incluye recursos adicionales:

| Recurso           | Cantidad | Descripcion                          |
|-------------------|----------|--------------------------------------|
| `core/fonts/`     | 358      | Fuentes FIGlet adicionales           |
| `core/fontxx/`    | 270      | Fuentes pre-coloreadas con ANSI      |
| `core/bnr/`       | 48       | Banners ANSI artisticos              |
| `core/banners/`   | 71       | Cowsay animales (tux, dragon, skull) |
| `.object/`        | 13       | Temas ZSH alternativos (h4ck3r0)     |

Los assets se instalan automaticamente en `$PREFIX/share/bannerfx/`.

---

## Estructura del proyecto

```
BannerFX-Termux/
├── banner-hacker.py          # Entry point Python
├── banner-hacker.sh          # Version Bash
├── bannerfx/                 # Paquete Python
│   ├── __init__.py
│   ├── _version.py
│   ├── config.py             # Configuracion y perfiles
│   ├── styles.py             # Motor de estilos y colores
│   ├── menu.py               # Menu interactivo
│   └── installer.py          # Instalacion y dependencias
├── install.sh                # Instalador
├── uninstall.sh              # Desinstalador
├── .gitattributes            # Normalizacion de saltos de linea
├── LICENSE                   # Apache 2.0
└── NOTICE                    # Avisos de licencia
```

---

## Autor

**hackcrist** — Creador y mantenedor del proyecto.

## Licencia

Distribuido bajo **Apache License 2.0**. Ver [LICENSE](LICENSE) y [NOTICE](NOTICE) para mas informacion.
