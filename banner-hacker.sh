#!/data/data/com.termux/files/usr/bin/bash
# BannerFX-Termux - v2.0.0
# Creado por hackcrist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

readonly VERSION="2.0.0"

set -u
set -o pipefail

TEMP_FILES=""
cleanup() {
    if [ -n "$TEMP_FILES" ]; then
        rm -f "$TEMP_FILES"
    fi
}
trap cleanup EXIT

# Colors
verde="\e[32m"
rojo="\e[31m"
amarillo="\e[33m"
cyan="\e[36m"
gris="\e[90m"
reset="\e[0m"

# Defaults
NOMBRE_BANNER="CRISTHACK"
ESTILO_BANNER="neon"
MODO_ALEATORIO=0

BANNER_SCRIPT="$HOME/.crist_banner.sh"
BASHRC_FILE="$HOME/.bashrc"
BASHRC_HOOK='[ -f "$HOME/.crist_banner.sh" ] && bash "$HOME/.crist_banner.sh"'

CONFIG_DIR="$HOME/.config/crist_banner"
SETTINGS_FILE="$CONFIG_DIR/settings.conf"
PROFILES_FILE="$CONFIG_DIR/profiles.db"

info() {
    echo -e "${cyan}$1${reset}"
}

ok() {
    echo -e "${verde}$1${reset}"
}

warn() {
    echo -e "${amarillo}$1${reset}"
}

err() {
    echo -e "${rojo}$1${reset}" >&2
}

require_termux() {
    if ! command -v pkg >/dev/null 2>&1; then
        err "Este script esta pensado para Termux (comando 'pkg' no encontrado)."
        exit 1
    fi
}

ensure_config() {
    mkdir -p "$CONFIG_DIR"
    [ -f "$PROFILES_FILE" ] || touch "$PROFILES_FILE"
}

estilo_valido() {
    case "$1" in
        neon|matrix|clean|retro|fire|ocean|glitch|minimal-dark)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

cargar_ajustes() {
    if [ -f "$SETTINGS_FILE" ]; then
        # shellcheck disable=SC1090
        . "$SETTINGS_FILE"
    fi

    if ! estilo_valido "${ESTILO_BANNER:-neon}"; then
        ESTILO_BANNER="neon"
    fi

    case "${MODO_ALEATORIO:-0}" in
        0|1) ;;
        *) MODO_ALEATORIO=0 ;;
    esac
}

guardar_ajustes() {
    cat > "$SETTINGS_FILE" << EOF
ESTILO_BANNER=$(printf '%q' "$ESTILO_BANNER")
MODO_ALEATORIO=$MODO_ALEATORIO
EOF
}

instalar_dependencias() {
    local fallo=0

    if ! command -v figlet >/dev/null 2>&1; then
        warn "Instalando figlet..."
        if ! pkg install figlet -y; then
            err "No se pudo instalar figlet."
            fallo=1
        fi
    fi

    if ! command -v gem >/dev/null 2>&1; then
        warn "Instalando ruby para usar gem..."
        if ! pkg install ruby -y; then
            err "No se pudo instalar ruby."
            fallo=1
        fi
    fi

    if ! command -v lolcat >/dev/null 2>&1; then
        warn "Instalando lolcat..."
        if ! gem install lolcat --no-document; then
            err "No se pudo instalar lolcat."
            fallo=1
        fi
    fi

    if [ "$fallo" -ne 0 ]; then
        err "Faltan dependencias. Revisa tu conexion y permisos, luego intenta de nuevo."
        exit 1
    fi

    if ! command -v figlet >/dev/null 2>&1 || ! command -v lolcat >/dev/null 2>&1; then
        err "Dependencias incompletas: se requiere figlet y lolcat."
        exit 1
    fi
}

normalizar_nombre() {
    local entrada="$1"

    entrada="$(printf '%s' "$entrada" | tr -d '\000-\037\177')"
    entrada="$(printf '%s' "$entrada" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    entrada="$(printf '%s' "$entrada" | tr -cd '[:alnum:] _-')"
    entrada="$(printf '%s' "$entrada" | tr -s ' ')"

    printf '%s' "$entrada"
}

estado_aleatorio() {
    if [ "$MODO_ALEATORIO" -eq 1 ]; then
        printf '%s' 'activo'
    else
        printf '%s' 'inactivo'
    fi
}

estilo_aleatorio() {
    local estilos=("neon" "matrix" "clean" "retro" "fire" "ocean" "glitch" "minimal-dark")
    local idx=$((RANDOM % ${#estilos[@]}))
    printf '%s' "${estilos[$idx]}"
}

estilo_efectivo() {
    if [ "$MODO_ALEATORIO" -eq 1 ]; then
        estilo_aleatorio
    else
        printf '%s' "$ESTILO_BANNER"
    fi
}

render_banner() {
    local nombre="$1"
    local estilo="$2"

    case "$estilo" in
        neon)
            figlet -f slant "$nombre" | lolcat -p 1.0
            ;;
        matrix)
            figlet -f standard "$nombre" | sed "s/^/${verde}/; s/$/${reset}/"
            ;;
        clean)
            figlet -f small "$nombre"
            ;;
        retro)
            figlet -f big "$nombre" | lolcat -S 45
            ;;
        fire)
            figlet -f standard "$nombre" | lolcat -S 15
            ;;
        ocean)
            figlet -f slant "$nombre" | lolcat -S 180
            ;;
        glitch)
            figlet -f big "$nombre" | lolcat -S 300
            figlet -f big "$nombre" | sed 's/^/ /' | lolcat -S 20
            ;;
        minimal-dark)
            figlet -f small "$nombre" | sed "s/^/${gris}/; s/$/${reset}/"
            ;;
        *)
            figlet -f slant "$nombre" | lolcat
            ;;
    esac
}

mostrar_estilos() {
    echo -e "${verde}1.${reset} neon         (slant + color dinamico)"
    echo -e "${verde}2.${reset} matrix       (verde fijo)"
    echo -e "${verde}3.${reset} clean        (minimal)"
    echo -e "${verde}4.${reset} retro        (big + color)"
    echo -e "${verde}5.${reset} fire         (tono calido)"
    echo -e "${verde}6.${reset} ocean        (tono frio)"
    echo -e "${verde}7.${reset} glitch       (doble capa)"
    echo -e "${verde}8.${reset} minimal-dark (gris tenue)"
}

seleccionar_estilo() {
    local opcion_estilo

    while true; do
        clear
        info "Selecciona un estilo de banner"
        echo
        mostrar_estilos
        echo
        read -r -p "Elige estilo [1-8]: " opcion_estilo

        case "$opcion_estilo" in
            1) ESTILO_BANNER="neon" ; break ;;
            2) ESTILO_BANNER="matrix" ; break ;;
            3) ESTILO_BANNER="clean" ; break ;;
            4) ESTILO_BANNER="retro" ; break ;;
            5) ESTILO_BANNER="fire" ; break ;;
            6) ESTILO_BANNER="ocean" ; break ;;
            7) ESTILO_BANNER="glitch" ; break ;;
            8) ESTILO_BANNER="minimal-dark" ; break ;;
            *)
                err "Opcion de estilo invalida."
                sleep 1
                ;;
        esac
    done

    guardar_ajustes
    ok "Estilo actualizado a '$ESTILO_BANNER'."
    sleep 1
}

cambiar_nombre() {
    local nuevo_nombre normalizado

    read -r -p "Escribe el nuevo nombre para el banner: " nuevo_nombre
    normalizado="$(normalizar_nombre "$nuevo_nombre")"

    if [ -z "$normalizado" ]; then
        err "Nombre invalido. Usa letras, numeros, espacios, guion o guion bajo."
        sleep 1
        return
    fi

    NOMBRE_BANNER="$normalizado"
    ok "Nombre actualizado a '$NOMBRE_BANNER'."
    sleep 1
}

guardar_perfil() {
    local nombre_perfil limpio tmp

    read -r -p "Nombre del perfil: " nombre_perfil
    limpio="$(normalizar_nombre "$nombre_perfil")"

    if [ -z "$limpio" ]; then
        err "Nombre de perfil invalido."
        sleep 1
        return
    fi

    tmp="$(mktemp)"
    grep -Fv "${limpio}|" "$PROFILES_FILE" > "$tmp" || true
    printf '%s|%s|%s\n' "$limpio" "$NOMBRE_BANNER" "$ESTILO_BANNER" >> "$tmp"
    mv "$tmp" "$PROFILES_FILE"

    ok "Perfil '$limpio' guardado."
    sleep 1
}

listar_perfiles_numerados() {
    awk -F'|' 'NF>=3 { printf "%d|%s|%s|%s\n", NR, $1, $2, $3 }' "$PROFILES_FILE"
}

cargar_perfil() {
    local listado opcion linea perfil nombre estilo

    if [ ! -s "$PROFILES_FILE" ]; then
        err "No hay perfiles guardados."
        sleep 1
        return
    fi

    clear
    info "Perfiles disponibles"
    echo
    listado="$(listar_perfiles_numerados)"
    printf '%s\n' "$listado" | awk -F'|' '{ printf "[%s] %s -> nombre: %s, estilo: %s\n", $1, $2, $3, $4 }'
    echo

    read -r -p "Elige numero de perfil: " opcion
    linea="$(printf '%s\n' "$listado" | awk -F'|' -v n="$opcion" '$1==n { print; exit }')"

    if [ -z "$linea" ]; then
        err "Perfil no valido."
        sleep 1
        return
    fi

    perfil="$(printf '%s' "$linea" | awk -F'|' '{print $2}')"
    nombre="$(printf '%s' "$linea" | awk -F'|' '{print $3}')"
    estilo="$(printf '%s' "$linea" | awk -F'|' '{print $4}')"

    if ! estilo_valido "$estilo"; then
        estilo="neon"
    fi

    NOMBRE_BANNER="$nombre"
    ESTILO_BANNER="$estilo"
    guardar_ajustes

    ok "Perfil '$perfil' cargado."
    sleep 1
}

toggle_aleatorio() {
    if [ "$MODO_ALEATORIO" -eq 1 ]; then
        MODO_ALEATORIO=0
        ok "Modo aleatorio desactivado."
    else
        MODO_ALEATORIO=1
        ok "Modo aleatorio activado."
    fi
    guardar_ajustes
    sleep 1
}

vista_previa() {
    local estilo_actual

    clear
    info "Vista previa del banner"
    echo
    estilo_actual="$(estilo_efectivo)"
    render_banner "$NOMBRE_BANNER" "$estilo_actual"
    echo
    info "Estilo en vista previa: $estilo_actual"
    read -r -p "Presiona Enter para volver al menu..."
}

instalar_banner() {
    local banner_escapado estilo_escapado

    printf -v banner_escapado '%q' "$NOMBRE_BANNER"
    printf -v estilo_escapado '%q' "$ESTILO_BANNER"

    cat > "$BANNER_SCRIPT" << EOF
#!/data/data/com.termux/files/usr/bin/bash
verde="\\e[32m"
gris="\\e[90m"
reset="\\e[0m"
NOMBRE_BANNER=${banner_escapado}
ESTILO_BANNER=${estilo_escapado}
MODO_ALEATORIO=$MODO_ALEATORIO

estilo_aleatorio() {
    local estilos=("neon" "matrix" "clean" "retro" "fire" "ocean" "glitch" "minimal-dark")
    local idx=\$((RANDOM % \${#estilos[@]}))
    printf '%s' "\${estilos[\$idx]}"
}

render_banner() {
    local nombre="\$1"
    local estilo="\$2"

    case "\$estilo" in
        neon)
            figlet -f slant "\$nombre" | lolcat -p 1.0
            ;;
        matrix)
            figlet -f standard "\$nombre" | sed "s/^/\${verde}/; s/\$/\${reset}/"
            ;;
        clean)
            figlet -f small "\$nombre"
            ;;
        retro)
            figlet -f big "\$nombre" | lolcat -S 45
            ;;
        fire)
            figlet -f standard "\$nombre" | lolcat -S 15
            ;;
        ocean)
            figlet -f slant "\$nombre" | lolcat -S 180
            ;;
        glitch)
            figlet -f big "\$nombre" | lolcat -S 300
            figlet -f big "\$nombre" | sed 's/^/ /' | lolcat -S 20
            ;;
        minimal-dark)
            figlet -f small "\$nombre" | sed "s/^/\${gris}/; s/\$/\${reset}/"
            ;;
        *)
            figlet -f slant "\$nombre" | lolcat
            ;;
    esac
}

if [ "\$MODO_ALEATORIO" -eq 1 ]; then
    ESTILO_ACTIVO="\$(estilo_aleatorio)"
else
    ESTILO_ACTIVO="\$ESTILO_BANNER"
fi

clear
echo -e "\${verde}Bienvenido Operador: \${NOMBRE_BANNER}\${reset}"
echo
render_banner "\${NOMBRE_BANNER}" "\${ESTILO_ACTIVO}"
echo
EOF

    chmod +x "$BANNER_SCRIPT"

    if [ ! -f "$BASHRC_FILE" ]; then
        touch "$BASHRC_FILE"
    fi

    if ! grep -Fqx "$BASHRC_HOOK" "$BASHRC_FILE"; then
        printf '%s\n' "$BASHRC_HOOK" >> "$BASHRC_FILE"
    fi

    ok "Banner instalado como '$NOMBRE_BANNER'."
    ok "Estilo base: '$ESTILO_BANNER'. Modo aleatorio: $(estado_aleatorio)."
    read -r -p "Presiona Enter para volver al menu..."
}

desinstalar_banner() {
    local tmp confirm

    if [ -f "$BANNER_SCRIPT" ]; then
        rm -f "$BANNER_SCRIPT"
        ok "Archivo de banner eliminado: $BANNER_SCRIPT"
    else
        warn "No existe $BANNER_SCRIPT"
    fi

    if [ -f "$BASHRC_FILE" ]; then
        tmp="$(mktemp)"; TEMP_FILES="$TEMP_FILES $tmp"
        grep -Fv "$BASHRC_HOOK" "$BASHRC_FILE" > "$tmp" || true
        mv "$tmp" "$BASHRC_FILE"
        ok "Entrada del banner removida de $BASHRC_FILE"
    fi

    if [ -d "$CONFIG_DIR" ]; then
        warn "Se eliminara el directorio de configuracion: $CONFIG_DIR"
        read -r -p "Confirmar? (s/N): " confirm
        if [ "$confirm" = "s" ] || [ "$confirm" = "S" ]; then
            rm -rf "$CONFIG_DIR"
            ok "Directorio de configuracion eliminado."
        else
            info "Configuracion conservada."
        fi
    fi

    read -r -p "Presiona Enter para volver al menu..."
}

mostrar_menu() {
    clear
    echo -e "${verde}====================================${reset}"
    echo -e "${cyan}     BannerFX v${VERSION}${reset}"
    echo -e "${verde}====================================${reset}"
    echo
    echo -e "${verde}1.${reset} Cambiar nombre (actual: ${amarillo}${NOMBRE_BANNER}${reset})"
    echo -e "${verde}2.${reset} Elegir estilo (actual: ${amarillo}${ESTILO_BANNER}${reset})"
    echo -e "${verde}3.${reset} Vista previa"
    echo -e "${verde}4.${reset} Guardar perfil"
    echo -e "${verde}5.${reset} Cargar perfil"
    echo -e "${verde}6.${reset} Modo aleatorio (actual: ${amarillo}$(estado_aleatorio)${reset})"
    echo -e "${verde}7.${reset} Instalar banner"
    echo -e "${verde}8.${reset} Desinstalar banner"
    echo -e "${verde}0.${reset} Salir"
    echo
    read -r -p "Elige una opcion: " OPCION
}

main() {
    case "${1:-}" in
        --help|-h)
            echo "BannerFX v$VERSION - Personaliza tu banner de Termux"
            echo "Uso: bannerfx [opcion]"
            echo
            echo "Opciones:"
            echo "  --help, -h     Muestra esta ayuda"
            echo "  --version, -v  Muestra la version"
            echo
            echo "Sin argumentos: abre el menu interactivo"
            echo "Estilos disponibles: neon, matrix, clean, retro, fire, ocean, glitch, minimal-dark"
            exit 0
            ;;
        --version|-v)
            echo "BannerFX v$VERSION"
            exit 0
            ;;
    esac

    require_termux
    ensure_config
    cargar_ajustes
    instalar_dependencias

    while true; do
        mostrar_menu
        case "$OPCION" in
            1)
                cambiar_nombre
                ;;
            2)
                seleccionar_estilo
                ;;
            3)
                vista_previa
                ;;
            4)
                guardar_perfil
                ;;
            5)
                cargar_perfil
                ;;
            6)
                toggle_aleatorio
                ;;
            7)
                instalar_banner
                ;;
            8)
                desinstalar_banner
                ;;
            0)
                info "Saliendo..."
                exit 0
                ;;
            *)
                err "Opcion invalida. Intenta de nuevo."
                sleep 1
                ;;
        esac
    done
}

main
