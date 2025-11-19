#!/usr/bin/env bash

# ==============================================================================
# Script de Configuración Automática para Laravel/Bagisto en Linux/macOS (Bash)
#
# Propósito:
# Este script automatiza la configuración inicial de un proyecto Laravel/Bagisto
# en un entorno de desarrollo local que utilice Bash (Linux, macOS).
# Ejecuta tareas como la validación de dependencias, configuración del entorno,
# instalación de paquetes, y preparación de la base de datos.
# ==============================================================================

echo "🚀 Inicio de configuración automática para Laravel/Bagisto"

# ---------------------------
# VALIDACIÓN DE HERRAMIENTAS
# ---------------------------
# Se verifica que las herramientas esenciales para el desarrollo estén instaladas y
# disponibles en el PATH del sistema. Si alguna falta, el script se detiene.
# 'command -v' es una forma robusta de verificar si un comando existe.
# '>/dev/null 2>&1' redirige toda la salida (estándar y de error) a la "nada"
# para que la verificación sea silenciosa.
# '||' ejecuta el comando siguiente solo si el anterior falla.

command -v php >/dev/null 2>&1 || { echo "❌ PHP no está instalado."; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "❌ Composer no está instalado."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "❌ Node/NPM no están instalados."; exit 1; }

# Si todas las herramientas están presentes, se muestra un mensaje de confirmación.
echo "✔ PHP, Composer y NPM detectados."

# ---------------------------
# ENVIRONMENT
# ---------------------------
# Laravel utiliza un archivo '.env' para gestionar las variables de entorno.

# Comprueba si el archivo .env NO existe ('! -f').
if [ ! -f ".env" ]; then
    # Si no existe, lo crea copiando el archivo de ejemplo '.env.example'.
    echo "📄 Creando archivo .env..."
    cp .env.example .env
else
    # Si ya existe, lo respeta para no sobrescribir una configuración existente.
    echo "✔ .env ya existe, no se sobrescribe."
fi

# La APP_KEY es una clave única y aleatoria que Laravel usa para encriptar
# sesiones y otros datos sensibles. Es crucial para la seguridad.
# '--quiet' suprime el mensaje de éxito para mantener la salida del script limpia.
echo "🔑 Generando APP_KEY..."
php artisan key:generate --quiet

# ---------------------------
# COMPOSER
# ---------------------------
# Composer es el gestor de dependencias para PHP. Este comando lee el archivo
# 'composer.json' e instala todas las librerías de backend necesarias.
# --no-interaction: Evita preguntas interactivas.
# --prefer-dist: Descarga las versiones empaquetadas (zip), que es más rápido.
echo "📦 Instalando dependencias de PHP..."
composer install --no-interaction --prefer-dist

# ---------------------------
# NPM
# ---------------------------
# NPM (Node Package Manager) es el gestor de dependencias para JavaScript.
# Este comando lee 'package.json' e instala las librerías de frontend.
echo "📦 Instalando dependencias de NPM..."
npm install

# 'npm run build' ejecuta un script definido en 'package.json' que compila
# los assets de frontend (CSS, JS) usando Vite para producción.
echo "🔧 Compilando frontend..."
npm run build

# ---------------------------
# BASE DE DATOS
# ---------------------------
# Esta sección prepara la base de datos para la aplicación.

# Comprueba si el cliente de línea de comandos de MySQL está disponible.
if command -v mysql >/dev/null 2>&1; then
    echo "🗄  MySQL detectado. Creando base de datos si no existe..."
    # Extrae el nombre de la base de datos del archivo .env.
    # 'grep' busca la línea, y 'cut' la divide por el '=' para obtener el valor.
    DB_NAME=$(grep DB_DATABASE .env | cut -d '=' -f2)

    # Ejecuta un comando SQL para crear la base de datos si aún no existe.
    # -u root: Se conecta como usuario 'root'.
    # -p: Solicitará la contraseña de forma interactiva.
    # -e: Ejecuta el comando SQL proporcionado.
    # '2>/dev/null' suprime mensajes de error (p. ej., si el usuario cancela la contraseña).
    mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};" 2>/dev/null
    echo "✔ Base de datos '${DB_NAME}' lista."
else
    # Si MySQL no está instalado o en el PATH, omite este paso.
    echo "⚠ MySQL no está instalado. Saltando creación de DB."
fi

# Las migraciones son scripts que construyen la estructura de la base de datos.
# '--force' es necesario para ejecutar migraciones en un entorno no interactivo.
echo "🔁 Ejecutando migraciones..."
php artisan migrate --force

# ---------------------------
# CACHE / OPTIMIZACIÓN
# ---------------------------
# Laravel utiliza varias cachés para mejorar el rendimiento. Es una buena
# práctica limpiarlas después de una instalación o actualización importante.
echo "🧹 Limpiando cachés..."
php artisan optimize:clear

# Mensaje final que indica que el proceso ha terminado con éxito.
echo "🏁 Finalizado. Proyecto listo para trabajar 💪"
