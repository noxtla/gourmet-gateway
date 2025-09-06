# Arquitectura del Proyecto: Noxtla Gourmet Suite

## 1. Resumen y Objetivo

El propósito de este proyecto es construir una aplicación integral y nativa de la nube para un servicio ficticio de entrega de comida, "Noxtla Gourmet Suite".

El objetivo técnico principal es servir como un proyecto de portafolio que demuestre el dominio de principios y tecnologías de ingeniería de software moderna para construir sistemas distribuidos que sean robustos, escalables, mantenibles y observables.

## 2. Filosofía Arquitectónica: ¿Por qué Microservicios?

Si bien una arquitectura de microservicios introduce una mayor complejidad operativa en comparación con un monolito tradicional, su elección para este proyecto es deliberada. El objetivo es demostrar habilidades en áreas específicas que son altamente valoradas en la industria del software actual.

Las justificaciones clave son:

*   **Separación de Incumbencias (Separation of Concerns):** Cada microservicio tiene una única y bien definida responsabilidad de negocio (identidad, catálogo, órdenes, etc.). Esto fomenta un código más limpio y fácil de entender.
*   **Autonomía y Escalabilidad Independiente:** Los servicios pueden ser desarrollados, desplegados y escalados de forma independiente. Por ejemplo, si el servicio de pagos recibe una carga alta, puede ser escalado sin afectar al resto de la aplicación.
*   **Resiliencia:** Un fallo en un servicio no crítico (ej. el servicio de catálogo deja de responder) no debería derribar todo el sistema. La aplicación puede seguir funcionando de manera degradada (ej. no se pueden buscar productos, pero sí ver órdenes existentes).

## 3. Componentes Clave y sus Justificaciones

A continuación se detallan los componentes arquitectónicos principales y el problema que resuelve cada uno:

*   **API Gateway (`Spring Cloud Gateway`):**
    *   **Problema que resuelve:** Evita la necesidad de que los clientes (aplicaciones web/móviles) conozcan y se comuniquen con docenas de servicios individuales. Proporciona una única fachada de seguridad y enrutamiento.
    *   **Función en el proyecto:** Actúa como el único punto de entrada para todo el tráfico. Gestiona el enrutamiento a los servicios correspondientes, centraliza la seguridad (validación de tokens JWT de Keycloak) y puede manejar tareas como el `rate limiting`.

*   **Gestión de Identidad y Acceso (`Keycloak`):**
    *   **Problema que resuelve:** Construir un sistema de autenticación y autorización desde cero es extremadamente complejo, propenso a errores y arriesgado. Delegar esta tarea es una práctica estándar de la industria.
    *   **Función en el proyecto:** Externaliza toda la lógica de gestión de usuarios, roles y permisos. Actúa como un servidor de autorización (OAuth2/OIDC) que emite tokens para asegurar tanto las APIs públicas como la comunicación interna entre servicios.

*   **Servidor de Configuración (`Spring Cloud Config`):**
    *   **Problema que resuelve:** En un sistema con muchos servicios, gestionar archivos de configuración individuales para cada uno y para cada entorno (local, dev, prod) es inmanejable y una fuente común de errores.
    *   **Función en el proyecto:** Centraliza toda la configuración de la aplicación en un repositorio de Git. Los servicios obtienen su configuración de este servidor al arrancar, permitiendo una gestión centralizada, versionada y auditable.

*   **Comunicación Asíncrona (`Apache Kafka`):**
    *   **Problema que resuelve:** La comunicación síncrona (ej. REST) entre servicios crea un acoplamiento fuerte. Si el `order-service` llama directamente al `inventory-service`, un fallo en el segundo impactará directamente al primero.
    *   **Función en el proyecto:** Permite una arquitectura orientada a eventos que desacopla los servicios. El `order-service` produce un evento `PedidoRealizado`, y los servicios `inventory` y `payment` reaccionan a él de forma asíncrona. Esto aumenta la resiliencia y permite implementar patrones complejos como las Sagas para gestionar la consistencia de datos a través de múltiples servicios.

*   **Contenerización (`Docker` & `Docker Compose`):**
    *   **Problema que resuelve:** Elimina el clásico problema de "funciona en mi máquina". Asegura que el entorno de desarrollo sea idéntico para todos los desarrolladores y lo más parecido posible a producción.
    *   **Función en el proyecto:** Cada microservicio se empaqueta como una imagen de Docker. `Docker Compose` se utiliza para orquestar el despliegue de toda la pila de la aplicación (todos los servicios, bases de datos, Kafka, Keycloak, etc.) en un entorno local con un solo comando.

*   **Observabilidad (`Prometheus`, `Grafana`, `Jaeger`):**
    *   **Problema que resuelve:** Monitorear y depurar un sistema distribuido es notoriamente difícil. Es imposible saber qué está pasando sin las herramientas adecuadas.
    *   **Función en el proyecto:** Implementa los tres pilares de la observabilidad:
        *   **Métricas (Prometheus):** Para monitorear la salud y el rendimiento de cada servicio.
        *   **Visualización (Grafana):** Para crear paneles y alertas a partir de las métricas.
        *   **Trazado Distribuido (Jaeger):** Para seguir el rastro de una solicitud a medida que viaja a través de los diferentes microservicios, permitiendo identificar cuellos de botella y puntos de fallo.

## 4. Pila Tecnológica (Technology Stack)

*   **Lenguaje de Programación:** Java 17+
*   **Framework Principal:** Spring Boot 3+
*   **Orquestación de Microservicios:** Spring Cloud
*   **Gestión de Identidad:** Keycloak
*   **Broker de Mensajería:** Apache Kafka
*   **Contenerización:** Docker, Docker Compose
*   **Bases de Datos:** PostgreSQL (por servicio)
*   **Herramienta de Build:** Apache Maven
*   **Pila de Observabilidad:** Prometheus, Grafana, Jaeger
