# ✨ Reset HWMonitor Trial Script ✨

![PowerShell](https://img.shields.io/badge/PowerShell-7.0%2B-blue?style=for-the-badge&logo=powershell)
![License](https://img.shields.io/badge/License-Educational-red?style=for-the-badge)

## 📝 Descripción

**Reset HWMonitor Trial Script** es un script de PowerShell diseñado para rastrear y eliminar archivos, claves de registro y procesos relacionados con **HWMonitor Pro**, con el objetivo de restablecer su período de prueba.  
⚠️ **Este script debe ser utilizado exclusivamente en entornos controlados y con fines educativos.**

## 📋 Características

- 🚀 **Búsqueda exhaustiva** de rastros en el sistema (archivos y claves de registro) relacionados con HWMonitor.
- 🛠️ **Crea respaldos** antes de eliminar archivos o claves del registro.
- 🔍 **Detección automática** de procesos en ejecución relacionados con HWMonitor y los detiene de manera segura.
- 🧹 **Eliminación segura** de todos los rastros encontrados.
- 📜 **Registro detallado** de la ejecución, para que puedas auditar todos los pasos realizados por el script.

## 🚨 Aviso Legal

Este script fue desarrollado con fines educativos. El autor no se responsabiliza del uso indebido del mismo. Utilízalo bajo tu propia responsabilidad y siempre con autorización en los sistemas donde lo ejecutes.

---

## 📦 Requisitos

Antes de ejecutar este script, asegúrate de contar con los siguientes requisitos:

- **PowerShell 7.0 o superior**.
- **Permisos de administrador**: Este script necesita privilegios elevados para acceder al registro y eliminar archivos protegidos.
- **Acceso controlado**: Ejecutar en un entorno de pruebas o controlado.

---

## 🛠️ Cómo Usar el Script

### 1️⃣ Descargar el Script
Descarga el archivo `Reset-HWMonitorTrial.ps1` en tu sistema.

### 2️⃣ Configuración Previa
Asegúrate de que PowerShell permita la ejecución de scripts. Si no estás seguro, ejecuta este comando para habilitarlo:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
