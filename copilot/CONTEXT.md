# Contexto del Proyecto: Noxtla Gourmet Suite

## 1. Objetivo Principal

El objetivo fundamental de este proyecto es servir como una pieza de portafolio de alto impacto. Su propósito es demostrar, de manera práctica, la capacidad de diseñar, construir y orquestar un sistema distribuido complejo utilizando patrones y tecnologías modernas estándar en la industria.

El propósito de este proyecto es construir una aplicación integral y nativa de la nube para un servicio ficticio de entrega de comida, "Noxtla Gourmet Suite".

El objetivo técnico principal es servir como un proyecto de portafolio que demuestre el dominio de principios y tecnologías de ingeniería de software moderna. 
+ El enfoque no es solo utilizar tecnologías complejas por sí mismas, sino demostrar la capacidad de integrarlas para resolver problemas específicos de los sistemas distribuidos, como la seguridad centralizada, la configuración externa y la comunicación resiliente.

## 2. Razón de ser de los Componentes

*   **Arquitectura de Microservicios (`/services`):** Demuestra la habilidad de aplicar el principio de Separación de Incumbencias a nivel de arquitectura. Cada servicio (`identity`, `catalog`, `order`, `inventory`, `payment`, `api-gateway`, `config-service`) representa un dominio de negocio o una capacidad de infraestructura acotada.

*   **Proyectos Maven Independientes (`pom.xml`):** Establece la base para la construcción, prueba y despliegue independiente de cada componente.

*   **Aplicaciones Spring Boot (`*Application.java`):** Utiliza el estándar de facto para el desarrollo de microservicios en Java, proveyendo una base robusta para crear aplicaciones autocontenidas.

*   **Contenerización (`Dockerfile`):** Demuestra la habilidad de crear imágenes de contenedor optimizadas, seguras y ligeras, utilizando builds multi-etapa.

*   **Orquestación Local (`docker-compose.yml`):** Demuestra la capacidad de definir y ejecutar un entorno multi-contenedor complejo con un solo comando.

*   **API Gateway (`api-gateway-service`):** Centraliza el tráfico y las políticas transversales (como la seguridad), actuando como único punto de entrada al sistema y simplificando la topología de la red de cara al cliente.

*   **Servidor de Configuración (`config-service`):** Externaliza la configuración de todos los servicios, demostrando una solución al problema de la dispersión de la configuración en sistemas distribuidos. Permite una gestión centralizada, versionada y auditable.

*   **Servidor de Identidad (`keycloak`):** Delega la autenticación y autorización a una solución estándar del mercado (Identity and Access Management - IAM). Demuestra el conocimiento de la integración con sistemas de seguridad robustos y evita reinventar la rueda en un área crítica.

*   Si bien una arquitectura de microservicios introduce una mayor complejidad operativa en comparación con un monolito, su elección para este proyecto es deliberada y consciente de sus inconvenientes. 
+ No se presenta como la solución universal, sino como un medio para abordar y demostrar soluciones a los desafíos inherentes de los sistemas distribuidos.

Las justificaciones clave para esta elección son:

*   **Separación de Incumbencias (Separation of Concerns):** Cada microservicio encapsula una única responsabilidad de negocio (identidad, catálogo, órdenes, etc.), forzando un diseño de software modular y con límites claros.
*   **Autonomía y Escalabilidad Independiente:** Los servicios pueden ser desarrollados, desplegados y escalados de forma independiente. Esto permite, por ejemplo, que el servicio de pagos sea escalado para una alta demanda sin impactar al resto del sistema.
*   **Resiliencia (Potencial):** Un fallo en un servicio no crítico (ej. el servicio de catálogo) no debería derribar todo el sistema. La aplicación puede seguir funcionando de manera degradada.

+ ### Trade-offs Reconocidos
+ La elección de esta arquitectura no está exenta de costos, que son reconocidos y gestionados en el proyecto:
+ *   **Complejidad Operativa:** Levantar y gestionar múltiples servicios, bases de datos y componentes de infraestructura es intrínsecamente más complejo que manejar un único monolito. Se mitiga parcialmente con `Docker Compose` para el entorno local.
+ *   **Consistencia de Datos:** Mantener la consistencia de los datos a través de múltiples bases de datos es un desafío. Se abordará con patrones como Sagas a través de comunicación asíncrona.
+ *   **Coste de la Observabilidad:** No es una opción, sino una necesidad. Monitorear, registrar y trazar peticiones en un sistema distribuido requiere una pila de herramientas dedicada.

## 3. Componentes Clave y sus Justificaciones

A continuación se detallan los componentes arquitectónicos principales y el problema que resuelve cada uno:

*   **API Gateway (`Spring Cloud Gateway`):**
    *   **Problema que resuelve:** Evita que los clientes (web/móvil) conozcan la topología interna de microservicios. Proporciona una única fachada para enrutamiento, seguridad y políticas transversales.
    *   **Función en el proyecto:** Actúa como el único punto de entrada (`Single Point of Entry`). Gestiona el enrutamiento a los servicios, centraliza la validación de tokens JWT de Keycloak y puede manejar tareas como el `rate limiting`.

*   **Gestión de Identidad y Acceso (`Keycloak`):**
    *   **Problema que resuelve:** Construir un sistema de autenticación/autorización es complejo y propenso a errores críticos de seguridad. Delegar esta función es una práctica estándar de la industria.
    *   **Función en el proyecto:** Externaliza la gestión de usuarios, roles y permisos. Actúa como un servidor de autorización (OAuth2/OIDC) que emite tokens para asegurar las APIs.

*   **Servidor de Configuración (`Spring Cloud Config`):**
    *   **Problema que resuelve:** En un sistema con N servicios y M entornos, gestionar N x M archivos de configuración es inmanejable y una fuente común de errores.
    *   **Función en el proyecto:** Centraliza la configuración en un repositorio Git. Los servicios obtienen su configuración al arrancar, permitiendo una gestión centralizada, versionada y auditable.

*   **Comunicación Asíncrona (`Apache Kafka`):**
    *   **Problema que resuelve:** La comunicación síncrona (REST) crea un acoplamiento temporal fuerte. Si el `order-service` llama directamente al `inventory-service`, un fallo en el segundo impacta directamente al primero.
+   *   **Analogía:** Una llamada REST es como una llamada telefónica: debes esperar a que el otro conteste. Un evento en Kafka es como enviar un paquete por mensajería: lo dejas en la oficina postal y confías en que llegará, sin tener que esperar.
    *   **Función en el proyecto:** Permite una arquitectura orientada a eventos que desacopla los servicios. El `order-service` produce un evento `PedidoRealizado`, y los servicios `inventory` y `payment` reaccionan a él. Esto aumenta la resiliencia y permite implementar patrones como Sagas.

*   **Contenerización (`Docker` & `Docker Compose`):**
    *   **Problema que resuelve:** Elimina el clásico "funciona en mi máquina". Asegura la paridad entre los entornos de desarrollo y producción.
+   *   **Función en el proyecto:** Cada componente (microservicio, base de datos, Kafka, Keycloak) se empaqueta como una imagen de Docker. `Docker Compose` orquesta el despliegue de toda la pila local con un solo comando, permitiendo a un desarrollador levantar el ecosistema completo para trabajar en una funcionalidad de "trancha vertical".

*   **Observabilidad (`Prometheus`, `Grafana`, `Jaeger`):**
    *   **Problema que resuelve:** Monitorear y depurar un sistema distribuido es notoriamente difícil sin las herramientas adecuadas.
    *   **Función en el proyecto:** Implementa los tres pilares de la observabilidad:
        *   **Métricas (Prometheus):** Para monitorear la salud y el rendimiento.
        *   **Visualización (Grafana):** Para crear paneles y alertas.
        *   **Trazado Distribuido (Jaeger):** Para seguir el rastro de una solicitud a medida que viaja a través de los microservicios, identificando cuellos de botella y puntos de fallo.

## 4. Pila Tecnológica y Patrones
*   **Lenguaje de Programación:** Java 17+
*   **Framework Principal:** Spring Boot 3+ / Spring Cloud
*   **Gestión de Identidad:** Keycloak (OAuth2/OIDC)
*   **Broker de Mensajería:** Apache Kafka
*   **Contenerización:** Docker, Docker Compose
+ *   **Persistencia de Datos:** PostgreSQL. Se aplica el patrón **"Database per Service"**, donde cada microservicio gestiona su propio esquema para garantizar el bajo acoplamiento.
*   **Herramienta de Build:** Apache Maven
*   **Pila de Observabilidad:** Prometheus, Grafana, Jaeger
