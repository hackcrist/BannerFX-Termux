# BannerFX-Termux - v2.0.0
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

import random
import subprocess

STYLES = [
    "neon", "matrix", "clean", "retro",
    "fire", "ocean", "glitch", "minimal-dark",
    "cowsay",
]

import shutil
from pathlib import Path

_COWFILES_DIR = None
_REPO_COW = Path(__file__).resolve().parent.parent / "core" / "banners"
_PREFIX_COW = Path(shutil.which("bannerfx") or "/").resolve().parent.parent / "share" / "bannerfx" / "banners" if shutil.which("bannerfx") else None

for _p in [_REPO_COW, _PREFIX_COW]:
    if _p and _p.is_dir() and any(_p.glob("*.cow")):
        _COWFILES_DIR = _p
        break

GREEN = "\033[32m"
GRAY = "\033[90m"
RESET = "\033[0m"

_RAINBOW_COLORS = [
    196, 202, 208, 214, 220, 226, 190, 154, 118, 82, 46,
    47, 48, 49, 50, 51, 45, 39, 33, 27, 21, 57, 93, 129, 165, 200,
]


def _rainbow(text: str, offset: int = 0) -> str:
    out = []
    for i, c in enumerate(text):
        if c == "\n":
            out.append(c)
        else:
            out.append(f"\033[38;5;{_RAINBOW_COLORS[(i + offset) % len(_RAINBOW_COLORS)]}m{c}")
    out.append(RESET)
    return "".join(out)


def _gradient(text: str, colors: list, speed: float = 1.0) -> str:
    out = []
    for i, c in enumerate(text):
        if c == "\n":
            out.append(c)
        else:
            out.append(f"\033[38;5;{colors[int((i * speed) % len(colors))]}m{c}")
    out.append(RESET)
    return "".join(out)


def _color_lines(text: str, code: str) -> str:
    return "".join(f"{code}{l}{RESET}\n" for l in text.split("\n")).rstrip("\n")


def _figlet(name: str, font: str = "standard") -> str:
    try:
        import pyfiglet
        return pyfiglet.figlet_format(name, font=font)
    except ImportError:
        try:
            r = subprocess.run(
                ["figlet", "-f", font, name],
                capture_output=True, text=True, check=True,
            )
            return r.stdout.rstrip("\n")
        except Exception:
            return name


def _cowsay(name: str) -> str:
    if _COWFILES_DIR:
        cow_files = list(_COWFILES_DIR.glob("*.cow"))
        if cow_files:
            cow = random.choice(cow_files)
            try:
                r = subprocess.run(
                    ["cowsay", "-f", str(cow), name],
                    capture_output=True, text=True, check=True, timeout=5,
                )
                return _rainbow(r.stdout.rstrip("\n"))
            except Exception:
                pass
    try:
        r = subprocess.run(
            ["cowsay", name], capture_output=True, text=True, check=True, timeout=5,
        )
        return _rainbow(r.stdout.rstrip("\n"))
    except Exception:
        return _figlet(name, "standard")


COWFILES_DIR = _COWFILES_DIR


def render_banner(nombre: str, estilo: str) -> str:
    if estilo == "neon":
        return _rainbow(_figlet(nombre, "slant"))
    elif estilo == "matrix":
        return _color_lines(_figlet(nombre, "standard"), GREEN)
    elif estilo == "clean":
        return _figlet(nombre, "small")
    elif estilo == "retro":
        return _gradient(_figlet(nombre, "big"), [214, 202, 196, 166, 130, 94], 0.5)
    elif estilo == "fire":
        return _gradient(_figlet(nombre, "standard"), [226, 220, 214, 208, 202, 196, 160], 0.3)
    elif estilo == "ocean":
        return _gradient(_figlet(nombre, "slant"), [51, 45, 39, 33, 27, 21, 20])
    elif estilo == "glitch":
        t = _figlet(nombre, "big")
        return (_rainbow(t, offset=random.randint(0, 50))
                + "\n" + " " + _rainbow(t, offset=random.randint(100, 200)))
    elif estilo == "minimal-dark":
        return _color_lines(_figlet(nombre, "small"), GRAY)
    elif estilo == "cowsay":
        return _cowsay(nombre)
    else:
        return _rainbow(_figlet(nombre, "slant"))


def estilo_aleatorio() -> str:
    return random.choice(STYLES)
