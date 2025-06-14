# 🎨 Banner Personalizable para Termux by Crist'Hack

Bienvenido al **instalador de banners personalizados para Termux** creado por [Crist'Hack](https://github.com/hackcrist). Este script te permite cambiar el nombre del banner y verlo cada vez que abres Termux, con estilo profesional. 🔥

---

## 🚀 Características

- Banner visual con `figlet` y `lolcat`
- Muestra IP pública, hora y fecha
- Menú interactivo para personalizar el nombre
- Instalación automática al iniciar Termux
- Fácil de usar y personalizar

---

## 📦 Instalación paso a paso

### 🔹 En Termux

1. 📦 **Actualiza los paquetes**
   ```bash
   pkg update -y
   ```

2. 🛠️ **Instala Git**
   ```bash
   pkg install git -y
   ```

3. 📥 **Clona el repositorio**
   ```bash
   git clone https://github.com/hackcrist/Banner-Crist-Termux.git
   ```

4. 📁 **Entra a la carpeta del proyecto**
   ```bash
   cd Banner-Crist-Termux
   ```

5. ✅ **Da permisos de ejecución al instalador**
   ```bash
   chmod +x instalar_banner.sh
   ```

6. 🚀 **Ejecuta el instalador**
   ```bash
   bash instalar_banner.sh
   ```

---

## 🖼️ Vista previa del banner

```bash
============================
       Crist'Hack
============================
📅 Fecha : Lunes, 10 Junio 2025
⏰ Hora  : 09:00 AM
🌐 IP Pública: 190.140.xx.xx
```

---

## 🧠 Cómo personalizar el nombre del banner

Al ejecutar el instalador, verás un **menú interactivo** con opciones para:

- Cambiar el nombre que aparece en el banner
- Ver una vista previa
- Instalar o salir

También puedes editar manualmente el archivo `~/.crist_banner.sh`.

---

## 👨‍💻 Autor

- Hecho con 💻 por [Crist'Hack](https://github.com/hackcrist)
- Sígueme en GitHub para más herramientas y scripts 🧪

---

## 📄 Licencia

Este proyecto está bajo la **Licencia Apache 2.0**. Consulta el archivo [`LICENSE`](./LICENSE) para más detalles.
