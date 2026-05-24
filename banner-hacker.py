#!/data/data/com.termux/files/usr/bin/env python3
# BannerFX-Termux - v2.0.0
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

import sys
import textwrap

from bannerfx import VERSION, Config, Menu
from bannerfx.installer import Installer


def main():
    if "--help" in sys.argv or "-h" in sys.argv:
        print(textwrap.dedent(f"""\
        BannerFX v{VERSION} - Personaliza tu banner de Termux
        Uso: bannerfx [opcion]

        Opciones:
          --help, -h     Muestra esta ayuda
          --version, -v  Muestra la version

        Sin argumentos: abre el menu interactivo
        Estilos: neon, matrix, clean, retro, fire, ocean, glitch, minimal-dark
        """))
        return

    if "--version" in sys.argv or "-v" in sys.argv:
        print(f"BannerFX v{VERSION}")
        return

    cfg = Config()
    cfg.require_termux()
    cfg.ensure_dirs()
    cfg.load()
    Installer.instalar_dependencias()

    menu = Menu(cfg)
    menu.loop()


if __name__ == "__main__":
    main()
