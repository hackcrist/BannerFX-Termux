#!/data/data/com.termux/files/usr/bin/env python3
import sys, os, json, random, subprocess, time, textwrap, shutil
from pathlib import Path

VERSION = "2.0.0"

GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
CYAN = "\033[36m"
GRAY = "\033[90m"
RESET = "\033[0m"

STYLES = ["neon", "matrix", "clean", "retro", "fire", "ocean", "glitch", "minimal-dark"]

HOME = Path.home()
CONFIG_DIR = HOME / ".config" / "crist_banner"
SETTINGS_FILE = CONFIG_DIR / "settings.json"
PROFILES_FILE = CONFIG_DIR / "profiles.json"
BANNER_SCRIPT = HOME / ".crist_banner.py"
BASHRC = HOME / ".bashrc"
BASHRC_HOOK = (
    '[ -f "' + str(BANNER_SCRIPT) + '" ] && python3 "' + str(BANNER_SCRIPT) + '"'
)

NOMBRE_BANNER = "CRISTHACK"
ESTILO_BANNER = "neon"
MODO_ALEATORIO = False


def info(m): print(f"{CYAN}{m}{RESET}")
def ok(m): print(f"{GREEN}{m}{RESET}")
def warn(m): print(f"{YELLOW}{m}{RESET}")
def err(m): print(f"{RED}{m}{RESET}", file=sys.stderr)
def clear(): os.system("clear")


def require_termux():
    if not shutil.which("pkg"):
        err("Este script esta pensado para Termux ('pkg' no encontrado).")
        sys.exit(1)


def ensure_config():
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    if not PROFILES_FILE.exists():
        PROFILES_FILE.write_text("[]")
    if not SETTINGS_FILE.exists():
        save_settings()


def load_settings():
    global NOMBRE_BANNER, ESTILO_BANNER, MODO_ALEATORIO
    try:
        if SETTINGS_FILE.exists():
            d = json.loads(SETTINGS_FILE.read_text())
            NOMBRE_BANNER = d.get("nombre", "CRISTHACK")
            ESTILO_BANNER = d.get("estilo", "neon")
            MODO_ALEATORIO = d.get("aleatorio", False)
    except Exception:
        pass
    if ESTILO_BANNER not in STYLES:
        ESTILO_BANNER = "neon"
    if not isinstance(MODO_ALEATORIO, bool):
        MODO_ALEATORIO = False


def save_settings():
    SETTINGS_FILE.write_text(json.dumps(
        {"nombre": NOMBRE_BANNER, "estilo": ESTILO_BANNER, "aleatorio": MODO_ALEATORIO}, indent=2))


def instalar_dependencias():
    fallo = False
    try:
        import pyfiglet  # noqa
    except ImportError:
        warn("Instalando pyfiglet...")
        if subprocess.run([sys.executable, "-m", "pip", "install", "pyfiglet", "--quiet"],
                          capture_output=True).returncode != 0:
            if subprocess.run(["pkg", "install", "python-pyfiglet", "-y"],
                              capture_output=True).returncode != 0:
                err("No se pudo instalar pyfiglet. Usando figlet del sistema como fallback.")
                fallo = True
    if fallo and not shutil.which("figlet"):
        err("No hay figlet ni pyfiglet. Instala figlet con: pkg install figlet")
        sys.exit(1)
    ok("Dependencias listas.")


def normalizar_nombre(entrada):
    entrada = "".join(c for c in entrada if ord(c) >= 32 and ord(c) != 127)
    entrada = entrada.strip()
    entrada = "".join(c for c in entrada if c.isalnum() or c in " _-")
    entrada = " ".join(entrada.split())
    return entrada


def estilo_aleatorio():
    return random.choice(STYLES)


def estilo_efectivo():
    return estilo_aleatorio() if MODO_ALEATORIO else ESTILO_BANNER


def rainbow(text, speed=1.0, offset=0):
    cols = [196, 202, 208, 214, 220, 226, 190, 154, 118, 82, 46,
            47, 48, 49, 50, 51, 45, 39, 33, 27, 21, 57, 93, 129, 165, 200]
    out = []
    for i, c in enumerate(text):
        if c == "\n":
            out.append(c)
        else:
            out.append(f"\033[38;5;{cols[(i + offset) % len(cols)]}m{c}")
    out.append(RESET)
    return "".join(out)


def gradient(text, cols, speed=1.0):
    out = []
    for i, c in enumerate(text):
        if c == "\n":
            out.append(c)
        else:
            out.append(f"\033[38;5;{cols[int((i * speed) % len(cols))]}m{c}")
    out.append(RESET)
    return "".join(out)


def figlet_render(name, font="standard"):
    try:
        import pyfiglet
        return pyfiglet.figlet_format(name, font=font)
    except ImportError:
        try:
            r = subprocess.run(["figlet", "-f", font, name],
                               capture_output=True, text=True, check=True)
            return r.stdout.rstrip("\n")
        except Exception:
            return name


def render_banner(nombre, estilo):
    if estilo == "neon":
        return rainbow(figlet_render(nombre, "slant"))
    elif estilo == "matrix":
        return "".join(f"{GREEN}{l}{RESET}\n" for l in figlet_render(nombre, "standard").split("\n")).rstrip("\n")
    elif estilo == "clean":
        return figlet_render(nombre, "small")
    elif estilo == "retro":
        return gradient(figlet_render(nombre, "big"), [214, 202, 196, 166, 130, 94], 0.5)
    elif estilo == "fire":
        return gradient(figlet_render(nombre, "standard"), [226, 220, 214, 208, 202, 196, 160], 0.3)
    elif estilo == "ocean":
        return gradient(figlet_render(nombre, "slant"), [51, 45, 39, 33, 27, 21, 20])
    elif estilo == "glitch":
        t = figlet_render(nombre, "big")
        return rainbow(t, offset=random.randint(0, 50)) + "\n" + " " + rainbow(t, offset=random.randint(100, 200))
    elif estilo == "minimal-dark":
        return "".join(f"{GRAY}{l}{RESET}\n" for l in figlet_render(nombre, "small").split("\n")).rstrip("\n")
    else:
        return rainbow(figlet_render(nombre, "slant"))


def mostrar_estilos():
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
    for i, d in enumerate(descs, 1):
        print(f"{GREEN}{i}.{RESET} {d}")


def seleccionar_estilo():
    global ESTILO_BANNER
    while True:
        clear()
        info("Selecciona un estilo de banner")
        print()
        mostrar_estilos()
        print()
        try:
            o = input("Elige estilo [1-8]: ").strip()
            idx = int(o) - 1
            if 0 <= idx < len(STYLES):
                ESTILO_BANNER = STYLES[idx]
                break
        except ValueError:
            pass
        err("Opcion de estilo invalida.")
        time.sleep(1)
    save_settings()
    ok(f"Estilo actualizado a '{ESTILO_BANNER}'.")
    time.sleep(1)


def cambiar_nombre():
    global NOMBRE_BANNER
    n = input("Escribe el nuevo nombre para el banner: ")
    n = normalizar_nombre(n)
    if not n:
        err("Nombre invalido. Usa letras, numeros, espacios, guion o guion bajo.")
        time.sleep(1)
        return
    NOMBRE_BANNER = n
    ok(f"Nombre actualizado a '{NOMBRE_BANNER}'.")
    time.sleep(1)


def guardar_perfil():
    nombre = normalizar_nombre(input("Nombre del perfil: "))
    if not nombre:
        err("Nombre de perfil invalido.")
        time.sleep(1)
        return
    perfiles = [p for p in load_profiles() if p.get("perfil") != nombre]
    perfiles.append({"perfil": nombre, "nombre": NOMBRE_BANNER, "estilo": ESTILO_BANNER})
    save_profiles(perfiles)
    ok(f"Perfil '{nombre}' guardado.")
    time.sleep(1)


def cargar_perfil():
    perfiles = load_profiles()
    if not perfiles:
        err("No hay perfiles guardados.")
        time.sleep(1)
        return
    clear()
    info("Perfiles disponibles")
    print()
    for i, p in enumerate(perfiles, 1):
        print(f"[{i}] {p['perfil']} -> nombre: {p['nombre']}, estilo: {p['estilo']}")
    print()
    try:
        idx = int(input("Elige numero de perfil: ")) - 1
        if idx < 0 or idx >= len(perfiles):
            raise ValueError
    except ValueError:
        err("Perfil no valido.")
        time.sleep(1)
        return
    p = perfiles[idx]
    global NOMBRE_BANNER, ESTILO_BANNER
    NOMBRE_BANNER = p["nombre"]
    ESTILO_BANNER = p["estilo"] if p["estilo"] in STYLES else "neon"
    save_settings()
    ok(f"Perfil '{p['perfil']}' cargado.")
    time.sleep(1)


def toggle_aleatorio():
    global MODO_ALEATORIO
    MODO_ALEATORIO = not MODO_ALEATORIO
    ok(f"Modo aleatorio {'activado' if MODO_ALEATORIO else 'desactivado'}.")
    save_settings()
    time.sleep(1)


def vista_previa():
    clear()
    info("Vista previa del banner")
    print()
    print(render_banner(NOMBRE_BANNER, estilo_efectivo()))
    print()
    info(f"Estilo en vista previa: {estilo_efectivo()}")
    input("Presiona Enter para volver al menu...")


def instalar_banner():
    script = textwrap.dedent(f"""\
    #!/data/data/com.termux/files/usr/bin/env python3
    import sys, random, subprocess, json
    from pathlib import Path

    HOME = Path.home()
    CONFIG_DIR = HOME / ".config" / "crist_banner"
    SETTINGS_FILE = CONFIG_DIR / "settings.json"

    VERSION = "{VERSION}"
    GREEN = "\\033[32m"
    GRAY = "\\033[90m"
    RESET = "\\033[0m"

    def rainbow(text, offset=0):
        cols = [196,202,208,214,220,226,190,154,118,82,46,47,48,49,50,51,45,39,33,27,21,57,93,129,165,200]
        out = []
        for i,c in enumerate(text):
            if c == "\\n": out.append(c)
            else: out.append(f"\\033[38;5;{{cols[(i+offset)%len(cols)]}}m{{c}}")
        out.append(RESET)
        return "".join(out)

    def figlet_render(name, font="standard"):
        try:
            import pyfiglet
            return pyfiglet.figlet_format(name, font=font)
        except ImportError:
            try:
                r = subprocess.run(["figlet","-f",font,name],capture_output=True,text=True,check=True)
                return r.stdout.rstrip("\\n")
            except: return name

    def render(nombre, estilo):
        if estilo == "neon": return rainbow(figlet_render(nombre,"slant"))
        elif estilo == "matrix": return "".join(f"{{GREEN}}{{l}}{{RESET}}\\n" for l in figlet_render(nombre,"standard").split("\\n")).rstrip("\\n")
        elif estilo == "clean": return figlet_render(nombre,"small")
        elif estilo == "glitch": t=figlet_render(nombre,"big"); return rainbow(t,offset=random.randint(0,50))+"\\n "+rainbow(t,offset=random.randint(100,200))
        elif estilo == "minimal-dark": return "".join(f"{{GRAY}}{{l}}{{RESET}}\\n" for l in figlet_render(nombre,"small").split("\\n")).rstrip("\\n")
        else: return rainbow(figlet_render(nombre,"slant"))

    data = {{}}
    try:
        if SETTINGS_FILE.exists(): data = json.loads(SETTINGS_FILE.read_text())
    except: pass
    nombre = data.get("nombre","CRISTHACK")
    estilo_base = data.get("estilo","neon")
    aleatorio = data.get("aleatorio",False)
    if aleatorio:
        estilos = ["neon","matrix","clean","retro","fire","ocean","glitch","minimal-dark"]
        estilo = random.choice(estilos)
    else: estilo = estilo_base

    import os
    os.system("clear")
    print(f"{{GREEN}}Bienvenido Operador: {{nombre}}{{RESET}}")
    print()
    print(render(nombre, estilo))
    print()
    """)

    BANNER_SCRIPT.write_text(script)
    BANNER_SCRIPT.chmod(0o755)

    if not BASHRC.exists():
        BASHRC.touch()

    content = BASHRC.read_text() if BASHRC.exists() else ""
    if BASHRC_HOOK not in content:
        with BASHRC.open("a") as f:
            f.write(BASHRC_HOOK + "\n")

    ok(f"Banner instalado como '{NOMBRE_BANNER}'.")
    ok(f"Estilo base: '{ESTILO_BANNER}'. Modo aleatorio: {'activo' if MODO_ALEATORIO else 'inactivo'}.")
    input("Presiona Enter para volver al menu...")


def desinstalar_banner():
    if BANNER_SCRIPT.exists():
        BANNER_SCRIPT.unlink()
        ok(f"Archivo de banner eliminado: {BANNER_SCRIPT}")
    else:
        warn(f"No existe {BANNER_SCRIPT}")

    if BASHRC.exists():
        lines = BASHRC.read_text().splitlines()
        lines = [l for l in lines if BASHRC_HOOK not in l]
        BASHRC.write_text("\n".join(lines) + "\n")
        ok("Entrada del banner removida de .bashrc")

    if CONFIG_DIR.exists():
        warn(f"Se eliminara el directorio de configuracion: {CONFIG_DIR}")
        confirm = input("Confirmar? (s/N): ").strip().lower()
        if confirm == "s":
            shutil.rmtree(CONFIG_DIR)
            ok("Directorio de configuracion eliminado.")
        else:
            info("Configuracion conservada.")

    input("Presiona Enter para volver al menu...")


def mostrar_menu():
    clear()
    print(f"{GREEN}===================================={RESET}")
    print(f"{CYAN}     BannerFX v{VERSION} (Python){RESET}")
    print(f"{GREEN}===================================={RESET}")
    print()
    print(f"{GREEN}1.{RESET} Cambiar nombre (actual: {YELLOW}{NOMBRE_BANNER}{RESET})")
    print(f"{GREEN}2.{RESET} Elegir estilo (actual: {YELLOW}{ESTILO_BANNER}{RESET})")
    print(f"{GREEN}3.{RESET} Vista previa")
    print(f"{GREEN}4.{RESET} Guardar perfil")
    print(f"{GREEN}5.{RESET} Cargar perfil")
    print(f"{GREEN}6.{RESET} Modo aleatorio (actual: {YELLOW}{'activo' if MODO_ALEATORIO else 'inactivo'}{RESET})")
    print(f"{GREEN}7.{RESET} Instalar banner")
    print(f"{GREEN}8.{RESET} Desinstalar banner")
    print(f"{GREEN}0.{RESET} Salir")
    print()
    return input("Elige una opcion: ").strip()


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]

    if "--help" in sys.argv or "-h" in sys.argv:
        print(textwrap.dedent(f"""\
        BannerFX v{VERSION} - Personaliza tu banner de Termux (Python)
        Uso: bannerfx [opcion]

        Opciones:
          --help, -h     Muestra esta ayuda
          --version, -v  Muestra la version

        Sin argumentos: abre el menu interactivo
        Estilos: {', '.join(STYLES)}
        """))
        return

    if "--version" in sys.argv or "-v" in sys.argv:
        print(f"BannerFX v{VERSION}")
        return

    require_termux()
    ensure_config()
    load_settings()
    instalar_dependencias()

    while True:
        opc = mostrar_menu()
        if opc == "1": cambiar_nombre()
        elif opc == "2": seleccionar_estilo()
        elif opc == "3": vista_previa()
        elif opc == "4": guardar_perfil()
        elif opc == "5": cargar_perfil()
        elif opc == "6": toggle_aleatorio()
        elif opc == "7": instalar_banner()
        elif opc == "8": desinstalar_banner()
        elif opc == "0":
            info("Saliendo...")
            break
        else:
            err("Opcion invalida. Intenta de nuevo.")
            time.sleep(1)


if __name__ == "__main__":
    main()
