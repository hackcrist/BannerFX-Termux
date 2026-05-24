# BannerFX-Termux - v2.0.0
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

import json
import os
import shutil
import subprocess
import random
import textwrap
import sys

from ._version import VERSION
from .config import Config

GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
CYAN = "\033[36m"
RESET = "\033[0m"


class Installer:
    def __init__(self, cfg: Config):
        self.cfg = cfg

    @staticmethod
    def _info(m): print(f"{CYAN}{m}{RESET}")
    @staticmethod
    def _ok(m): print(f"{GREEN}{m}{RESET}")
    @staticmethod
    def _warn(m): print(f"{YELLOW}{m}{RESET}")
    @staticmethod
    def _err(m): print(f"{RED}{m}{RESET}", file=sys.stderr)

    @staticmethod
    def instalar_dependencias():
        fallo = False
        try:
            import pyfiglet  # noqa
        except ImportError:
            Installer._warn("Instalando pyfiglet...")
            r = subprocess.run(
                [sys.executable, "-m", "pip", "install", "pyfiglet", "--quiet"],
                capture_output=True,
            )
            if r.returncode != 0:
                r2 = subprocess.run(
                    ["pkg", "install", "python-pyfiglet", "-y"],
                    capture_output=True,
                )
                if r2.returncode != 0:
                    Installer._err(
                        "No se pudo instalar pyfiglet. Se usara figlet del sistema."
                    )
                    fallo = True
        if fallo and not shutil.which("figlet"):
            Installer._err("No hay figlet ni pyfiglet. Instala figlet: pkg install figlet")
            sys.exit(1)
        Installer._ok("Dependencias listas.")

    def instalar(self):
        script = self._generar_script()
        self.cfg.BANNER_SCRIPT.write_text(script)
        self.cfg.BANNER_SCRIPT.chmod(0o755)

        if not self.cfg.BASHRC.exists():
            self.cfg.BASHRC.touch()

        content = self.cfg.BASHRC.read_text() if self.cfg.BASHRC.exists() else ""
        if self.cfg.bashrc_hook not in content:
            with self.cfg.BASHRC.open("a") as f:
                f.write(self.cfg.bashrc_hook + "\n")

        self._ok(f"Banner instalado como '{self.cfg.nombre}'.")
        self._ok(
            f"Estilo base: '{self.cfg.estilo}'. "
            f"Modo aleatorio: {self.cfg.estado_aleatorio}."
        )

    def desinstalar(self):
        if self.cfg.BANNER_SCRIPT.exists():
            self.cfg.BANNER_SCRIPT.unlink()
            self._ok(f"Archivo de banner eliminado: {self.cfg.BANNER_SCRIPT}")
        else:
            self._warn(f"No existe {self.cfg.BANNER_SCRIPT}")

        if self.cfg.BASHRC.exists():
            lines = self.cfg.BASHRC.read_text().splitlines()
            lines = [l for l in lines if self.cfg.bashrc_hook not in l]
            self.cfg.BASHRC.write_text("\n".join(lines) + "\n")
            self._ok("Entrada del banner removida de .bashrc")

        if self.cfg.CONFIG_DIR.exists():
            self._warn(
                f"Se eliminara el directorio de configuracion: {self.cfg.CONFIG_DIR}"
            )
            confirm = input("Confirmar? (s/N): ").strip().lower()
            if confirm == "s":
                shutil.rmtree(self.cfg.CONFIG_DIR)
                self._ok("Directorio de configuracion eliminado.")
            else:
                self._info("Configuracion conservada.")

    def _generar_script(self) -> str:
        return textwrap.dedent(f"""\
        #!/data/data/com.termux/files/usr/bin/env python3
        import random, subprocess, json, sys
        from pathlib import Path

        HOME = Path.home()
        CONFIG_DIR = HOME / ".config" / "crist_banner"
        SETTINGS_FILE = CONFIG_DIR / "settings.json"

        VERSION = "{VERSION}"
        GREEN = "\\\\033[32m"
        GRAY = "\\\\033[90m"
        RESET = "\\\\033[0m"

        _COLS = [196,202,208,214,220,226,190,154,118,82,46,47,48,49,50,51,45,39,33,27,21,57,93,129,165,200]

        def _rainbow(text, offset=0):
            out = []
            for i,c in enumerate(text):
                if c == "\\\\n": out.append(c)
                else: out.append(f"\\\\033[38;5;{{_COLS[(i+offset)%len(_COLS)]}}m{{c}}")
            out.append(RESET)
            return "".join(out)

        def _figlet(name, font="standard"):
            try:
                import pyfiglet
                return pyfiglet.figlet_format(name, font=font)
            except ImportError:
                try:
                    r = subprocess.run(["figlet","-f",font,name],capture_output=True,text=True,check=True)
                    return r.stdout.rstrip("\\\\n")
                except: return name

        def _render(nombre, estilo):
            if estilo == "neon": return _rainbow(_figlet(nombre,"slant"))
            elif estilo == "matrix": return "".join(f"{{GREEN}}{{l}}{{RESET}}\\\\n" for l in _figlet(nombre,"standard").split("\\\\n")).rstrip("\\\\n")
            elif estilo == "clean": return _figlet(nombre,"small")
            elif estilo == "glitch": t=_figlet(nombre,"big"); return _rainbow(t,offset=random.randint(0,50))+"\\\\n "+_rainbow(t,offset=random.randint(100,200))
            elif estilo == "minimal-dark": return "".join(f"{{GRAY}}{{l}}{{RESET}}\\\\n" for l in _figlet(nombre,"small").split("\\\\n")).rstrip("\\\\n")
            else: return _rainbow(_figlet(nombre,"slant"))

        data = {{}}
        try:
            if SETTINGS_FILE.exists(): data = json.loads(SETTINGS_FILE.read_text())
        except: pass
        nombre = data.get("nombre","CRISTHACK")
        estilo_base = data.get("estilo","neon")
        aleatorio = data.get("aleatorio",False)
        if aleatorio:
            estilo = random.choice(["neon","matrix","clean","retro","fire","ocean","glitch","minimal-dark"])
        else: estilo = estilo_base

        os.system("clear")
        print(f"{{GREEN}}Bienvenido Operador: {{nombre}}{{RESET}}")
        print()
        print(_render(nombre, estilo))
        print()
        """)
