# 🎨 BannerFX-Termux

Script interactivo para crear un banner visual en Termux con nombre personalizado, efectos visuales (`figlet + lolcat`) y bienvenida automática. Diseñado por [Crist'Hack](https://github.com/hackcrist).

---

## 🚀 Funciones principales

✅ Cambia el nombre que aparece en el banner  
✅ Vista previa antes de instalar  
✅ Muestra IP, fecha y hora  
✅ Se ejecuta automáticamente al iniciar Termux  
✅ Interfaz de menú sencilla y visual  

---

## 📦 Instalación paso a paso (funcional)

### 🔧 Requisitos previos

1. Tener **Termux actualizado**
   ```bash
   pkg update -y && pkg upgrade -y
   ```

2. Instalar herramientas necesarias
   ```bash
   pkg install git figlet ruby -y
   gem install lolcat
   ```

---

### 🔽 Clonar el repositorio

```bash
git clone https://github.com/hackcrist/BannerFX-Termux.git
cd BannerFX-Termux
```

---

### 🚀 Ejecutar el instalador

```bash
chmod +x instalar_banner.sh
bash instalar_banner.sh
```

---

## 🧪 Cómo funciona el menú

Una vez ejecutado, verás un menú con estas opciones:

1. 📝 Cambiar el nombre que aparece en el banner  
2. 🔍 Ver cómo se verá (vista previa)  
3. ✅ Instalar el banner (se agrega a `.bashrc`)  
4. ❌ Salir del instalador

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

---

## 🧑 Autor

- 🔧 Proyecto hecho por [Crist'Hack](https://github.com/hackcrist)
- 🛠️ Ideal para terminales personalizadas y herramientas de presentación
- 💬 Aporta o clona libremente

---

## 📄 Licencia

Este proyecto está bajo la **Licencia Apache 2.0**  
Consulta el archivo [`LICENSE`](./LICENSE) para más detalles.

## 👤 Autor 

Hecho con ❤️ por **Crist**