# Próximos Pasos: Tareas Pendientes

## Fase 3: Características Avanzadas (Nivel Portafolio)

- [ ] **6. Gateway de API (API Gateway):**
  - [ ] 6.1. Crear un nuevo `api-gateway-service` con Spring Cloud Gateway.
  - [ ] 6.2. Configurar las rutas hacia los demás microservicios.

- [ ] **7. Configuración Centralizada (Config Server):**
  - [ ] 7.1. Crear un `config-service` con Spring Cloud Config.
  - [ ] 7.2. Crear un repositorio Git para almacenar los archivos de configuración.
  - [ ] 7.3. Conectar los microservicios al Config Server.

- [ ] **8. Seguridad con Keycloak (Identity & Access Management):**
  - [ ] 8.1. Añadir Keycloak al `docker-compose.yml`.
  - [ ] 8.2. Configurar un "realm" y los clientes para nuestros servicios en la consola de Keycloak.
  - [ ] 8.3. Integrar Spring Security para proteger los endpoints utilizando los tokens de Keycloak.

- [ ] **9. Arquitectura Orientada a Eventos (Kafka):**
  - [ ] 9.1. Añadir Kafka y Zookeeper al `docker-compose.yml`.
  - [ ] 9.2. Implementar productores y consumidores de eventos en los servicios (`order`, `inventory`, `payment`) para la Saga de Pedidos.

- [ ] **10. Pruebas Avanzadas (Testing):**
  - [ ] 10.1. Implementar pruebas de integración con Testcontainers para verificar la conexión a base de datos y Kafka.
  - [ ] 10.2. (Opcional) Implementar pruebas de contrato con Pact.

- [ ] **11. Observabilidad (Monitoring):**
  - [ ] 11.1. Añadir Prometheus, Grafana y Jaeger (o Zipkin) al `docker-compose.yml`.
  - [ ] 11.2. Instrumentar los servicios para generar métricas y trazas distribuidas.
  - [ ] 11.3. Crear un panel básico en Grafana para visualizar el estado del sistema.
