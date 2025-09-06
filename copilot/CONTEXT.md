# Contexto del Proyecto: Noxtla Gourmet Suite

## 1. Objetivo Principal

El objetivo fundamental de este proyecto es servir como una pieza de portafolio de alto impacto. Su propósito es demostrar, de manera práctica, la capacidad de diseñar, construir y orquestar un sistema distribuido complejo utilizando patrones y tecnologías modernas estándar en la industria.

## 2. Razón de ser de los Componentes

*   **Arquitectura de Microservicios (`/services`):** Demuestra la habilidad de aplicar el principio de Separación de Incumbencias a nivel de arquitectura. Cada servicio (`identity`, `catalog`, `order`, `inventory`, `payment`, `api-gateway`, `config-service`) representa un dominio de negocio o una capacidad de infraestructura acotada.

*   **Proyectos Maven Independientes (`pom.xml`):** Establece la base para la construcción, prueba y despliegue independiente de cada componente.

*   **Aplicaciones Spring Boot (`*Application.java`):** Utiliza el estándar de facto para el desarrollo de microservicios en Java, proveyendo una base robusta para crear aplicaciones autocontenidas.

*   **Contenerización (`Dockerfile`):** Demuestra la habilidad de crear imágenes de contenedor optimizadas, seguras y ligeras, utilizando builds multi-etapa.

*   **Orquestación Local (`docker-compose.yml`):** Demuestra la capacidad de definir y ejecutar un entorno multi-contenedor complejo con un solo comando.

*   **API Gateway (`api-gateway-service`):** Centraliza el tráfico y las políticas transversales (como la seguridad), actuando como único punto de entrada al sistema y simplificando la topología de la red de cara al cliente.

*   **Servidor de Configuración (`config-service`):** Externaliza la configuración de todos los servicios, demostrando una solución al problema de la dispersión de la configuración en sistemas distribuidos. Permite una gestión centralizada, versionada y auditable.

*   **Servidor de Identidad (`keycloak`):** Delega la autenticación y autorización a una solución estándar del mercado (Identity and Access Management - IAM). Demuestra el conocimiento de la integración con sistemas de seguridad robustos y evita reinventar la rueda en un área crítica.

## 3. Próximos Pasos

La base actual está diseñada para soportar la siguiente evolución:

*   **Integración de Seguridad:** Conectar los servicios con Keycloak para asegurar los endpoints.
*   **Comunicación Asíncrona:** Integrar Kafka para desacoplar los servicios y aumentar la resiliencia.
*   **Observabilidad:** Añadir una pila de monitoreo para entender el comportamiento del sistema en tiempo de ejecución.