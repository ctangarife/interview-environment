#!/bin/bash
# docker_scout_container.sh
# Script para análisis de vulnerabilidades en contenedores Docker en ejecución
# Uso: ./docker_scout_container.sh container_id

if [ "$#" -lt 1 ]; then
    echo "Uso: $0 container_id"
    echo "Ejemplo: $0 e36c385d8a7b"
    exit 1
fi

CONTAINER_ID=$1

# Verificar si el contenedor existe y está en ejecución
if ! docker container inspect "$CONTAINER_ID" &>/dev/null; then
    echo "❌ ERROR: El contenedor $CONTAINER_ID no existe."
    exit 1
fi

# Obtener información sobre el contenedor
CONTAINER_INFO=$(docker container inspect "$CONTAINER_ID" --format '{{.Config.Image}}')
echo "================================"
echo "🔍 Analizando contenedor: $CONTAINER_ID"
echo "🖼️ Basado en imagen: $CONTAINER_INFO"
echo "================================"

# Extraer la imagen del contenedor para analizarla sin usar Docker Hub
echo "📥 Obteniendo información de la imagen del contenedor..."
IMAGE_ID=$(docker container inspect "$CONTAINER_ID" --format '{{.Image}}')
IMAGE_NAME="container-image-$CONTAINER_ID:latest"

echo "🏷️ Etiquetando imagen para análisis: $IMAGE_NAME"
docker commit "$CONTAINER_ID" "$IMAGE_NAME"

echo -e "\n\n📊 VISIÓN GENERAL DE LA IMAGEN DEL CONTENEDOR"
echo "================================"
docker scout quickview "$IMAGE_NAME"

echo -e "\n\n🔒 ANÁLISIS DETALLADO DE VULNERABILIDADES"
echo "================================"
docker scout cves "$IMAGE_NAME"

echo -e "\n\n🔧 RECOMENDACIONES DE MEJORA"
echo "================================"
docker scout recommendations "$IMAGE_NAME"

echo -e "\n\n✅ ANÁLISIS COMPLETO"
echo "Los resultados del análisis de seguridad para el contenedor $CONTAINER_ID están arriba."
echo "================================"

# Preguntar si se desea eliminar la imagen temporal
echo -e "\n¿Desea eliminar la imagen temporal creada para el análisis? (s/n)"
read -r limpiar
if [[ "$limpiar" == "s" || "$limpiar" == "S" ]]; then
    echo "🧹 Eliminando imagen temporal $IMAGE_NAME..."
    docker rmi "$IMAGE_NAME"
    echo "✅ Imagen temporal eliminada."
fi