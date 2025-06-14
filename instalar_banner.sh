#!/data/data/com.termux/files/usr/bin/bash

# ───── Colores ─────
verde="\e[32m"
azul="\e[34m"
amarillo="\e[33m"
rojo="\e[31m"
reset="\e[0m"

# ───── Variables por defecto ─────
NOMBRE_BANNER="Crist'Hack"

# ───── Función para mostrar menú ─────
mostrar_menu() {
    clear
    echo -e "${azul}╔═════════════════════════════╗"
    echo -e "║    ${amarillo}Menu del Banner Crist${azul}    ║"
    echo -e "╚═════════════════════════════╝${reset}"
    echo ""
    echo -e "${verde}1.${reset} Cambiar nombre del banner (actual: ${amarillo}${NOMBRE_BANNER}${reset})"
    echo -e "${verde}2.${reset} Vista previa del banner"
    echo -e "${verde}3.${reset} Instalar banner"
    echo -e "${verde}4.${reset} Salir"
    echo ""
    read -p "Elige una opción: " OPCION
}

# ───── Función para mostrar preview ─────
vista_previa() {
    command -v figlet >/dev/null 2>&1 || pkg install figlet -y
    command -v lolcat >/dev/null 2>&1 || gem install lolcat
    clear
    echo -e "${amarillo}🔰 Vista previa del banner 🔰${reset}"
    echo "============================" | lolcat
    figlet "$NOMBRE_BANNER" | lolcat
    echo "============================" | lolcat
    echo -e "📅 Fecha : $(date '+%A, %d %B %Y')"
    echo -e "⏰ Hora  : $(date '+%I:%M %p')"
    echo -e "🌐 IP Pública: $(curl -s ifconfig.me)"
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

# ───── Función para instalar el banner ─────
instalar_banner() {
    cat > ~/.crist_banner.sh << EOF
#!/data/data/com.termux/files/usr/bin/bash
verde="\e[32m"
azul="\e[34m"
cyan="\e[36m"
reset="\e[0m"
clear
echo -e "\${verde}🔰 Bienvenido a tu terminal, $NOMBRE_BANNER 🔰\${reset}"
echo "============================" | lolcat
figlet "$NOMBRE_BANNER" | lolcat
echo "============================" | lolcat
echo -e "📅 Fecha : \$(date '+%A, %d %B %Y')"
echo -e "⏰ Hora  : \$(date '+%I:%M %p')"
echo -e "🌐 IP Pública: \$(curl -s ifconfig.me)"
echo ""
EOF

    chmod +x ~/.crist_banner.sh
    if ! grep -q "crist_banner.sh" ~/.bashrc; then
        echo "bash ~/.crist_banner.sh" >> ~/.bashrc
    fi
    echo -e "\n${verde}✅ Banner instalado correctamente con nombre '${NOMBRE_BANNER}'${reset}"
    read -p "Presiona Enter para volver al menú..."
}

# ───── Bucle del menú ─────
while true; do
    mostrar_menu
    case $OPCION in
        1)
            read -p "📝 Escribe el nuevo nombre para el banner: " NOMBRE_BANNER
            ;;
        2)
            vista_previa
            ;;
        3)
            instalar_banner
            ;;
        4)
            echo -e "${rojo}👋 Saliendo...${reset}"
            exit
            ;;
        *)
            echo -e "${rojo}❌ Opción inválida.${reset}"
            sleep 1
            ;;
    esac
done
