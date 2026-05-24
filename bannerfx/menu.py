# BannerFX-Termux - v2.0.0
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

import os
import time
from typing import List

from ._version import VERSION
from .config import Config
from .styles import STYLES, render_banner, estilo_aleatorio, COWFILES_DIR

GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
CYAN = "\033[36m"
RESET = "\033[0m"
GRAY = "\033[90m"


class IO:
    @staticmethod
    def info(m): print(f"{CYAN}{m}{RESET}")

    @staticmethod
    def ok(m): print(f"{GREEN}{m}{RESET}")

    @staticmethod
    def warn(m): print(f"{YELLOW}{m}{RESET}")

    @staticmethod
    def err(m): print(f"{RED}{m}{RESET}", file=__import__("sys").stderr)

    @staticmethod
    def clear(): os.system("clear")

    @staticmethod
    def pause(msg="Presiona Enter para volver al menu..."):
        input(msg)

    @staticmethod
    def input_int(prompt: str, min_val: int, max_val: int) -> int:
        while True:
            try:
                v = int(input(prompt).strip())
                if min_val <= v <= max_val:
                    return v
            except ValueError:
                pass
            IO.err(f"Numero invalido. Ingresa un valor entre {min_val} y {max_val}.")
            time.sleep(1)

    @staticmethod
    def input_str(prompt: str) -> str:
        return input(prompt).strip()


class Menu:
    def __init__(self, cfg: Config):
        self.cfg = cfg

    def mostrar_estilos(self):
        descs = [
            "neon         (slant + color dinamico)",
            "matrix       (verde fijo)",
            "clean        (minimal)",
            "retro        (big + color)",
            "fire         (tono calido)",
            "ocean        (tono frio)",
            "glitch       (doble capa)",
            "minimal-dark (gris tenue)",
        ]
        if COWFILES_DIR:
            descs.append("cowsay       (arte ASCII animal)")
        for i, d in enumerate(descs, 1):
            print(f"{GREEN}{i}.{RESET} {d}")

    def seleccionar_estilo(self):
        while True:
            IO.clear()
            IO.info("Selecciona un estilo de banner")
            print()
            self.mostrar_estilos()
            print()
            max_s = len(STYLES) - (0 if COWFILES_DIR else 1)
            try:
                idx = int(IO.input_str(f"Elige estilo [1-{len(STYLES)}]: ")) - 1
                if 0 <= idx < len(STYLES):
                    if STYLES[idx] == "cowsay" and not COWFILES_DIR:
                        IO.err("Estilo no disponible (sin cowfiles).")
                        time.sleep(1)
                        continue
                    self.cfg.estilo = STYLES[idx]
                    break
            except ValueError:
                pass
            IO.err("Opcion de estilo invalida.")
            time.sleep(1)
        self.cfg.save()
        IO.ok(f"Estilo actualizado a '{self.cfg.estilo}'.")
        time.sleep(1)

    def cambiar_nombre(self):
        n = self._normalizar(IO.input_str("Escribe el nuevo nombre para el banner: "))
        if not n:
            IO.err("Nombre invalido. Usa letras, numeros, espacios, guion o guion bajo.")
            time.sleep(1)
            return
        self.cfg.nombre = n
        IO.ok(f"Nombre actualizado a '{self.cfg.nombre}'.")
        time.sleep(1)

    def vista_previa(self):
        IO.clear()
        IO.info("Vista previa del banner")
        print()
        estilo = estilo_aleatorio() if self.cfg.aleatorio else self.cfg.estilo
        print(render_banner(self.cfg.nombre, estilo))
        print()
        IO.info(f"Estilo en vista previa: {estilo}")
        IO.pause()

    def guardar_perfil(self):
        nombre = self._normalizar(IO.input_str("Nombre del perfil: "))
        if not nombre:
            IO.err("Nombre de perfil invalido.")
            time.sleep(1)
            return
        perfiles = [p for p in self.cfg.load_profiles() if p.get("perfil") != nombre]
        perfiles.append({"perfil": nombre, "nombre": self.cfg.nombre, "estilo": self.cfg.estilo})
        self.cfg.save_profiles(perfiles)
        IO.ok(f"Perfil '{nombre}' guardado.")
        time.sleep(1)

    def cargar_perfil(self):
        perfiles = self.cfg.load_profiles()
        if not perfiles:
            IO.err("No hay perfiles guardados.")
            time.sleep(1)
            return
        IO.clear()
        IO.info("Perfiles disponibles")
        print()
        for i, p in enumerate(perfiles, 1):
            print(f"[{i}] {p['perfil']} -> nombre: {p['nombre']}, estilo: {p['estilo']}")
        print()
        try:
            idx = int(IO.input_str("Elige numero de perfil: ")) - 1
            if idx < 0 or idx >= len(perfiles):
                raise ValueError
        except ValueError:
            IO.err("Perfil no valido.")
            time.sleep(1)
            return
        p = perfiles[idx]
        self.cfg.nombre = p["nombre"]
        self.cfg.estilo = p["estilo"] if p["estilo"] in STYLES else "neon"
        self.cfg.save()
        IO.ok(f"Perfil '{p['perfil']}' cargado.")
        time.sleep(1)

    def toggle_aleatorio(self):
        self.cfg.aleatorio = not self.cfg.aleatorio
        IO.ok(f"Modo aleatorio {self.cfg.estado_aleatorio}.")
        self.cfg.save()
        time.sleep(1)

    def _normalizar(self, entrada: str) -> str:
        entrada = "".join(c for c in entrada if ord(c) >= 32 and ord(c) != 127)
        entrada = entrada.strip()
        entrada = "".join(c for c in entrada if c.isalnum() or c in " _-")
        return " ".join(entrada.split())

    def loop(self):
        while True:
            IO.clear()
            self._print_header()
            opc = IO.input_str("Elige una opcion: ")
            if opc == "1": self.cambiar_nombre()
            elif opc == "2": self.seleccionar_estilo()
            elif opc == "3": self.vista_previa()
            elif opc == "4": self.guardar_perfil()
            elif opc == "5": self.cargar_perfil()
            elif opc == "6": self.toggle_aleatorio()
            elif opc == "7": self._instalar()
            elif opc == "8": self._desinstalar()
            elif opc == "0":
                IO.info("Saliendo...")
                break
            else:
                IO.err("Opcion invalida. Intenta de nuevo.")
                time.sleep(1)

    def _print_header(self):
        print(f"{GREEN}===================================={RESET}")
        print(f"{CYAN}     BannerFX v{VERSION}{RESET}")
        print(f"{GREEN}===================================={RESET}")
        print()
        print(f"{GREEN}1.{RESET} Cambiar nombre (actual: {YELLOW}{self.cfg.nombre}{RESET})")
        print(f"{GREEN}2.{RESET} Elegir estilo (actual: {YELLOW}{self.cfg.estilo}{RESET})")
        print(f"{GREEN}3.{RESET} Vista previa")
        print(f"{GREEN}4.{RESET} Guardar perfil")
        print(f"{GREEN}5.{RESET} Cargar perfil")
        print(f"{GREEN}6.{RESET} Modo aleatorio (actual: {YELLOW}{self.cfg.estado_aleatorio}{RESET})")
        print(f"{GREEN}7.{RESET} Instalar banner")
        print(f"{GREEN}8.{RESET} Desinstalar banner")
        print(f"{GREEN}0.{RESET} Salir")
        print()

    def _instalar(self):
        from .installer import Installer
        Installer(self.cfg).instalar()
        IO.pause()

    def _desinstalar(self):
        from .installer import Installer
        Installer(self.cfg).desinstalar()
        IO.pause()
