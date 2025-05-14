#!/bin/bash
# docker_build_and_scan.sh
# Script para construir una imagen desde un Dockerfile y analizarla con Docker Scout
# Uso: ./docker_build_and_scan.sh ruta_dockerfile nombre_imagen [tag]

if [ "$#" -lt 2 ]; then
    echo "Uso: $0 ruta_dockerfile nombre_imagen [tag]"
    echo "Ejemplo: $0 ./build/interview/Dockerfile interviews"
    exit 1
fi

DOCKERFILE_PATH=$1
IMAGE_NAME=$2
TAG=${3:-latest}  # Si no se proporciona un tag, se usa 'latest' por defecto
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

# Verificar si el Dockerfile existe
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ ERROR: El Dockerfile no existe en la ruta especificada: $DOCKERFILE_PATH"
    exit 1
fi

# Obtener el directorio del Dockerfile para usar como contexto de construcción
DOCKER_CONTEXT=$(dirname "$DOCKERFILE_PATH")

echo "================================"
echo "🏗️ Construyendo imagen: $FULL_IMAGE_NAME"
echo "📄 Usando Dockerfile: $DOCKERFILE_PATH"
echo "📁 Contexto de construcción: $DOCKER_CONTEXT"
echo "================================"

# Crear un Dockerfile temporal con rutas relativas corregidas
TEMP_DOCKERFILE="${DOCKER_CONTEXT}/Dockerfile.temp"
cat "$DOCKERFILE_PATH" | sed 's|ADD \./build/interview/|ADD |g' > "$TEMP_DOCKERFILE"

echo "📝 Dockerfile modificado para contexto correcto:"
echo "--------------------------------"
cat "$TEMP_DOCKERFILE"
echo "--------------------------------"

# Construir la imagen desde el Dockerfile temporal
if docker build -f "$TEMP_DOCKERFILE" -t "$FULL_IMAGE_NAME" "$DOCKER_CONTEXT"; then
    echo "✅ Imagen construida exitosamente: $FULL_IMAGE_NAME"
    # Eliminar el Dockerfile temporal
    rm "$TEMP_DOCKERFILE"
else
    echo "❌ ERROR: No se pudo construir la imagen desde el Dockerfile"
    # Eliminar el Dockerfile temporal
    rm "$TEMP_DOCKERFILE"
    exit 1
fi

echo -e "\n\n📊 VISIÓN GENERAL DE LA IMAGEN"
echo "================================"
docker scout quickview "$FULL_IMAGE_NAME"

echo -e "\n\n🔒 ANÁLISIS DETALLADO DE VULNERABILIDADES"
echo "================================"
docker scout cves "$FULL_IMAGE_NAME"

echo -e "\n\n🔧 RECOMENDACIONES DE MEJORA"
echo "================================"
docker scout recommendations "$FULL_IMAGE_NAME"

echo -e "\n\n✅ ANÁLISIS COMPLETO"
echo "Los resultados del análisis de seguridad para $FULL_IMAGE_NAME están arriba."
echo "================================"