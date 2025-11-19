# ==============================================================================
# Script de Configuración Automática para Laravel/Bagisto en Windows (PowerShell)
#
# Propósito:
# Este script automatiza la configuración inicial de un proyecto Laravel/Bagisto
# en un entorno de desarrollo local que utilice PowerShell (Windows).
# Ejecuta tareas como la validación de dependencias, configuración del entorno,
# instalación de paquetes, y preparación de la base de datos.
# ==============================================================================

Write-Host "🚀 Iniciando configuración automática para Laravel/Bagisto"

# ---------------------------
# VALIDACIÓN DE HERRAMIENTAS
# ---------------------------
# Se verifica que las herramientas esenciales para el desarrollo estén instaladas y
# disponibles en el PATH del sistema. Si alguna falta, el script se detiene.

# Verifica la existencia del comando 'php'.
if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "❌ PHP no está instalado o no está en PATH."
    exit 1
}

# Verifica la existencia del comando 'composer'.
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Composer no está instalado."
    exit 1
}

# Verifica la existencia del comando 'npm'.
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node/NPM no están instalados."
    exit 1
}

# Si todas las herramientas están presentes, se muestra un mensaje de confirmación.
Write-Host "✔ PHP, Composer y NPM detectados."

# ---------------------------
# ENVIRONMENT
# ---------------------------
# Laravel utiliza un archivo '.env' para gestionar las variables de entorno
# (credenciales de base de datos, claves de API, etc.).

# Comprueba si el archivo .env ya existe.
if (-not (Test-Path ".env")) {
    # Si no existe, lo crea copiando el archivo de ejemplo '.env.example'.
    Write-Host "📄 Creando .env..."
    Copy-Item ".env.example" ".env"
} else {
    # Si ya existe, lo respeta para no sobrescribir una configuración existente.
    Write-Host "✔ .env ya existe. No se sobrescribe."
}

# La APP_KEY es una clave única y aleatoria que Laravel usa para encriptar
# sesiones y otros datos sensibles. Es crucial para la seguridad.
Write-Host "🔑 Generando APP_KEY..."
php artisan key:generate

# ---------------------------
# COMPOSER
# ---------------------------
# Composer es el gestor de dependencias para PHP. Este comando lee el archivo
# 'composer.json' e instala todas las librerías de backend necesarias.
# --no-interaction: Evita preguntas interactivas.
# --prefer-dist: Descarga las versiones empaquetadas (zip), que es más rápido.
Write-Host "📦 Instalando dependencias de PHP..."
composer install --no-interaction --prefer-dist

# ---------------------------
# NPM
# ---------------------------
# NPM (Node Package Manager) es el gestor de dependencias para JavaScript.
# Este comando lee 'package.json' e instala las librerías de frontend.
Write-Host "📦 Instalando dependencias NPM..."
npm install

# 'npm run build' ejecuta un script definido en 'package.json' que compila
# los assets de frontend (como archivos Sass/SCSS a CSS y JavaScript moderno a
# una versión compatible con navegadores) usando Vite.
Write-Host "🔧 Construyendo frontend..."
npm run build

# ---------------------------
# BASE DE DATOS
# ---------------------------
# Esta sección prepara la base de datos para la aplicación.

# Lee el archivo .env para encontrar el nombre de la base de datos.
# NOTA: Este método es simple y asume el formato 'DB_DATABASE=nombre'.
$envFile = Get-Content .env | Where-Object { $_ -match "DB_DATABASE" }
$DB_NAME = $envFile.Split("=")[1]

# Comprueba si el cliente de línea de comandos de MySQL está disponible.
if (Get-Command mysql -ErrorAction SilentlyContinue) {
    Write-Host "🗄  MySQL detectado. Creando base si no existe..."
    # Ejecuta un comando SQL para crear la base de datos si aún no existe.
    # -u root: Se conecta como usuario 'root'.
    # -p: Solicitará la contraseña de forma interactiva.
    # -e: Ejecuta el comando SQL proporcionado.
    mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
} else {
    # Si MySQL no está instalado o en el PATH, omite este paso.
    Write-Host "⚠ MySQL no está instalado. Saltando DB."
}

# Las migraciones son scripts que construyen la estructura de la base de datos
# (tablas, columnas, índices).
# --force: Es necesario para ejecutar migraciones en un entorno no interactivo (como este script).
Write-Host "🔁 Ejecutando migraciones..."
php artisan migrate --force

# ---------------------------
# CACHE
# ---------------------------
# Laravel utiliza varias cachés (configuración, rutas, vistas) para mejorar el rendimiento.
# Es una buena práctica limpiarlas después de una instalación o actualización importante.
Write-Host "🧹 Limpiando cachés..."
php artisan optimize:clear

# Mensaje final que indica que el proceso ha terminado con éxito.
Write-Host "🏁 Listo! Proyecto configurado correctamente 💪"
