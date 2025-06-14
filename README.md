# 🎨 BannerFX-Termux

**Script profesional para personalizar tu terminal Termux**  
📛 Crea banners con tu nombre, colores animados (`figlet + lolcat`) y bienvenida automática.  

🔧 Diseñado por [Crist'Hack](https://github.com/hackcrist) para dar estilo único a tu terminal.

---

## 🚀 Funciones principales

- ✅ Cambia el nombre que aparece en el banner  
- ✅ Vista previa antes de instalar  
- ✅ Muestra IP pública, fecha y hora  
- ✅ Se ejecuta automáticamente al iniciar Termux  
- ✅ Interfaz con menú visual y clara  

---

## 📦 Instalación paso a paso

### 🔧 Requisitos previos

1. Actualizar Termux:

```bash
pkg update -y && pkg upgrade -y
```


2. Instalar dependencias necesarias:

```bash
pkg install git figlet ruby -y
```


```bash
gem install lolcat
```

---

### 🔽 Clonar el repositorio

```bash
git clone https://github.com/hackcrist/BannerFX-Termux.git
```


```bash
cd BannerFX-Termux
```

---

### 🚀 Ejecutar el instalador

```bash
chmod +x instalar_banner.sh
```


```bash
bash instalar_banner.sh
```

---

## 🧪 Menú interactivo

Al ejecutar el script, verás estas opciones:

1. 📝 Cambiar el nombre del banner  
2. 🔍 Ver vista previa (cómo se verá)  
3. ✅ Instalar el banner (se añade al `.bashrc`)  
4. ❌ Salir del menú

---

## 📸 Ejemplo visual del banner

```
============================
       CRIST'HACK
============================
📅 Fecha : Sábado, 14 Junio 2025
⏰ Hora  : 08:30 AM
🌐 IP Pública: 190.xxx.xxx.xx
```

✨ ¡El banner se mostrará automáticamente cada vez que abras Termux!

---

## ⭐ Apoya este proyecto

¿Te gusta esta herramienta?  
💖 Dale una estrella al repositorio y compártelo con tus amigos:

👉 https://github.com/hackcrist/BannerFX-Termux

---

## 👤 Autor

- 🧠 Hecho con pasión por [Crist'Hack](https://github.com/hackcrist)  
- 🛠️ Ideal para personalizar terminales y presentaciones  
- 💬 Se aceptan sugerencias y mejoras

---

## 👥 Colaboradores

- 🤝 **Hackabner** – Colaborador de código

---

## 📄 Licencia

Licencia **Apache 2.0** – Consulta el archivo [`LICENSE`](./LICENSE) para más detalles.