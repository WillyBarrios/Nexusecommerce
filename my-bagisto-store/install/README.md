# Bagisto / Laravel - Proyecto con Automatización CI, Scripts y Entorno

## 📦 Introducción

Este repositorio contiene una implementación de **Bagisto (Laravel +
PHP + Tailwind)** con un entorno automatizado para el equipo de
desarrollo. Incluye:

-   Scripts de instalación para **Linux/macOS** y **Windows**
-   Pipeline de **CI en GitHub Actions**
-   Entorno local con **MySQL**
-   Configuración unificada para que cada desarrollador pueda arrancar
    el proyecto automáticamente

------------------------------------------------------------------------

## 🚀 Requisitos del Entorno

  Herramienta     Versión recomendada
  --------------- ---------------------
  PHP             8.2+
  Composer        2.x
  Node.js         18+
  NPM             9+
  MySQL           8+
  PowerShell 7+   (solo Windows)

------------------------------------------------------------------------

## 📥 Instalación del Proyecto

### 🐧 Linux y 🍎 macOS

``` bash
git clone https://github.com/tu-org/tu-proyecto.git
cd tu-proyecto
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 🪟 Windows

``` powershell
git clone https://github.com/tu-org/tu-proyecto.git
cd tu-proyecto
powershell -File scripts/setup.ps1
```

------------------------------------------------------------------------

## 🔧 Scripts Automáticos

### 📜 `scripts/setup.sh` (Linux/macOS)

Instala dependencias, copia `.env`, genera llave, ejecuta migraciones,
limpia cachés y compila.

### 📜 `scripts/setup.ps1` (Windows)

Hace la misma automatización adaptada al entorno Windows.

------------------------------------------------------------------------

## ⚙️ Variables de Entorno

Los scripts crean automáticamente este archivo si no existe:

    APP_NAME=BagistoProject
    APP_ENV=local
    APP_KEY=
    APP_DEBUG=true

    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=bagisto
    DB_USERNAME=root
    DB_PASSWORD=

------------------------------------------------------------------------

## 🤖 CI/CD --- GitHub Actions

El repositorio incluye:

`.github/workflows/ci.yaml`

El pipeline ejecuta automáticamente:

-   Composer install
-   NPM install
-   Artisan key:generate
-   Cachés: clear, config, route, view
-   Migraciones
-   Tests
-   Build frontend

Se ejecuta en:

-   Push a `main` o `develop`
-   Pull Requests

------------------------------------------------------------------------

## 🏗️ Estructura del Proyecto

    📦 proyecto
     ┣ 📁 app
     ┣ 📁 bootstrap
     ┣ 📁 config
     ┣ 📁 database
     ┣ 📁 scripts
     ┃ ┣ setup.sh
     ┃ ┗ setup.ps1
     ┣ 📁 resources
     ┣ 📁 routes
     ┣ .env
     ┣ composer.json
     ┣ package.json
     ┣ vite.config.js
     ┗ README.md

------------------------------------------------------------------------

## 🏃 Iniciar el Proyecto

### Backend

``` bash
php artisan serve
```

### Frontend

``` bash
npm run dev
```

------------------------------------------------------------------------

## 🧑‍🤝‍🧑 Flujo de Trabajo Recomendado

1.  Crear rama:

``` bash
git checkout -b feature/nombre
```

2.  Hacer commits limpios:

``` bash
git commit -m "feat: nueva funcionalidad"
```

3.  Subir:

``` bash
git push origin feature/nombre
```

4.  Abrir Pull Request → CI se ejecuta automáticamente.

------------------------------------------------------------------------

## 📄 Licencia

La licencia será definida por el ingeniero jefe del proyecto.

------------------------------------------------------------------------

¡Proyecto listo para que el equipo desarrolle sin complicaciones! 🚀
