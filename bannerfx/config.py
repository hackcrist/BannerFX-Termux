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
import sys
from pathlib import Path
from typing import Optional


class Config:
    HOME = Path.home()
    CONFIG_DIR = HOME / ".config" / "crist_banner"
    SETTINGS_FILE = CONFIG_DIR / "settings.json"
    PROFILES_FILE = CONFIG_DIR / "profiles.json"
    BANNER_SCRIPT = HOME / ".crist_banner.py"
    BASHRC = HOME / ".bashrc"

    def __init__(self):
        self.nombre: str = "CRISTHACK"
        self.estilo: str = "neon"
        self.aleatorio: bool = False

    @property
    def bashrc_hook(self) -> str:
        return (
            '[ -f "' + str(self.BANNER_SCRIPT) + '" ] && python3 "'
            + str(self.BANNER_SCRIPT) + '"'
        )

    @property
    def estado_aleatorio(self) -> str:
        return "activo" if self.aleatorio else "inactivo"

    def ensure_dirs(self):
        self.CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        if not self.PROFILES_FILE.exists():
            self.PROFILES_FILE.write_text("[]")

    def require_termux(self):
        if not shutil.which("pkg"):
            print("\033[31mEste script esta pensado para Termux ('pkg' no encontrado).\033[0m",
                  file=sys.stderr)
            sys.exit(1)

    def load(self):
        try:
            if self.SETTINGS_FILE.exists():
                d = json.loads(self.SETTINGS_FILE.read_text())
                self.nombre = d.get("nombre", "CRISTHACK")
                self.estilo = d.get("estilo", "neon")
                self.aleatorio = d.get("aleatorio", False)
        except Exception:
            pass
        from .styles import STYLES
        if self.estilo not in STYLES:
            self.estilo = "neon"
        if not isinstance(self.aleatorio, bool):
            self.aleatorio = False

    def save(self):
        self.SETTINGS_FILE.write_text(json.dumps(
            {"nombre": self.nombre, "estilo": self.estilo, "aleatorio": self.aleatorio},
            indent=2))

    def load_profiles(self) -> list:
        try:
            if self.PROFILES_FILE.exists():
                return json.loads(self.PROFILES_FILE.read_text())
        except Exception:
            pass
        return []

    def save_profiles(self, profiles: list):
        self.PROFILES_FILE.write_text(json.dumps(profiles, indent=2))
