#!/data/data/com.termux/files/usr/bin/bash

# ───── Colores ─────
verde="\e[32m"
rojo="\e[31m"
amarillo="\e[33m"
cyan="\e[36m"
reset="\e[0m"

# ───── Nombre por defecto ─────
NOMBRE_BANNER="CRISTHACK"

# ───── Instalar dependencias ─────
instalar_dependencias() {
    if ! command -v figlet >/dev/null 2>&1; then
        echo -e "${amarillo}⚙️ Instalando figlet...${reset}"
        pkg install figlet -y
    fi
    if ! command -v lolcat >/dev/null 2>&1; then
        echo -e "${amarillo}⚙️ Instalando lolcat...${reset}"
        gem install lolcat
    fi
}

# ───── Mostrar menú principal ─────
mostrar_menu() {
    clear
    echo -e "${verde}╔════════════════════════════════════╗"
    echo -e "║   ${cyan}Menu del Banner Hacker Inclinado${verde}  ║"
    echo -e "╚════════════════════════════════════╝${reset}"
    echo ""
    echo -e "${verde}1.${reset} Cambiar nombre del banner (actual: ${amarillo}${NOMBRE_BANNER}${reset})"
    echo -e "${verde}2.${reset} Vista previa del banner"
    echo -e "${verde}3.${reset} Instalar banner"
    echo -e "${verde}0.${reset} Salir"
    echo ""
    read -p "➡️  Elige una opción: " OPCION
}

# ───── Vista previa del banner ─────
vista_previa() {
    clear
    echo -e "${cyan}🔰 Vista previa Hacker Inclinado 🔰${reset}"
    echo "" | lolcat
    figlet -f slant "$NOMBRE_BANNER" | lolcat
    echo "" | lolcat
    read -p "Presiona Enter para volver al menú..."
}

# ───── Instalar el banner ─────
instalar_banner() {
    cat > ~/.crist_banner.sh << EOF
#!/data/data/com.termux/files/usr/bin/bash
verde="\e[32m"
cyan="\e[36m"
reset="\e[0m"
clear
echo -e "\${verde}🔰 Bienvenido Operador: ${NOMBRE_BANNER} 🔰\${reset}"
echo "" | lolcat
figlet -f slant "${NOMBRE_BANNER}" | lolcat
echo "" | lolcat
EOF

    chmod +x ~/.crist_banner.sh

    if ! grep -q "crist_banner.sh" ~/.bashrc; then
        echo "bash ~/.crist_banner.sh" >> ~/.bashrc
    fi

    echo -e "\n${verde}✅ Banner hacker inclinado instalado como '${NOMBRE_BANNER}'${reset}"
    read -p "Presiona Enter para volver al menú..."
}

# ───── Inicio ─────
instalar_dependencias

while true; do
    mostrar_menu
    case $OPCION in
        1)
            read -p "📝 Escribe el nuevo nombre para el banner: " nuevo_nombre
            if [ -n "$nuevo_nombre" ]; then
                NOMBRE_BANNER="$nuevo_nombre"
                echo -e "${verde}✔️ Nombre actualizado a '${NOMBRE_BANNER}'${reset}"
                sleep 1
            else
                echo -e "${rojo}❌ Nombre inválido. Intenta de nuevo.${reset}"
                sleep 1
            fi
            ;;
        2)
            vista_previa
            ;;
        3)
            instalar_banner
            ;;
        4)
            echo -e "${rojo}👋 Saliendo...${reset}"
            exit 0
            ;;
        *)
            echo -e "${rojo}❌ Opción inválida. Intenta de nuevo.${reset}"
            sleep 1
            ;;
    esac
done
