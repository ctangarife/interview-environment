# Interview Transcription Infrastructure

## Descripción

Este repositorio contiene la infraestructura necesaria para desplegar y ejecutar una aplicación de transcripción de entrevistas utilizando Docker. El código fuente de la aplicación se encuentra en un repositorio independiente y se monta en tiempo de ejecución mediante volúmenes.

---

## Estructura de Carpetas

```
/
├── build/
│   └── app/
│       └── Dockerfile
├── docker-compose.yml
├── .env
└── README.md
```

-   **build/app/Dockerfile**: Imagen base para la aplicación de transcripción.
-   **docker-compose.yml**: Orquestador de servicios y volúmenes.
-   **.env**: Variables de entorno para la infraestructura.
-   **README.md**: Documentación técnica de la infraestructura.

---

## Estrategia de Dockerización

La infraestructura está diseñada para desacoplar el código fuente de la aplicación de la configuración y el entorno de ejecución. Esto permite una fácil migración, escalabilidad y portabilidad entre diferentes entornos (desarrollo, pruebas, producción).

**Principios clave:**
-   **Separación de código y entorno:** El código fuente de la aplicación reside fuera de este repositorio, en la carpeta `data/interview`, y se monta como volumen en el contenedor.
-   **Reproducibilidad:** El entorno de ejecución se define completamente mediante Docker y Docker Compose.
-   **Escalabilidad:** La infraestructura puede adaptarse para incluir otros servicios (por ejemplo, bases de datos, almacenamiento, etc.) según sea necesario.

---

## Uso

### 1. Variables de entorno

Configura el archivo `.env` en la raíz del repositorio con las variables necesarias para la infraestructura. Ejemplo:

```
APP_NAME=Interview Transcription Service
DEBUG=True
PORT=8000
```

### 2. Build de la imagen

Construye la imagen de la aplicación usando Docker Compose:

```bash
docker-compose build
```

### 3. Estructura esperada para el código fuente

El código fuente de la aplicación debe estar disponible en la ruta `./data/interview` y será montado automáticamente en el contenedor.

### 4. Levantar la infraestructura

Inicia los servicios definidos en el `docker-compose.yml`:

```bash
docker-compose up
```

Esto levantará el contenedor de la aplicación, montando el código fuente desde el volumen especificado.

---

## Notas

-   **El código fuente de la aplicación no está incluido en este repositorio.** Debe obtenerse y ubicarse en la carpeta `data/interview` antes de iniciar los servicios.
-   Puedes adaptar el `docker-compose.yml` para agregar otros servicios o modificar la configuración según tus necesidades.