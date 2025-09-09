╭───────────────────────────────────────────────────────────────────────────╮
│  > dame el todo listo con todos los pasos y fases de la trancha vertical  │
╰───────────────────────────────────────────────────────────────────────────╯

✦ De acuerdo. Aquí tienes una hoja de ruta detallada, estructurada en fases, que implementa la "Trancha Vertical" de autenticación y paga la "deuda de
  automatización" que identificaste.

  Este plan reemplaza la necesidad de todoList_keycloak_setup.md y partes de project_roadmap.txt.

  ---

  Hoja de Ruta: Trancha Vertical de Autenticación

  Objetivo: Implementar un flujo de autenticación de extremo a extremo, seguro y completamente automatizado. Un usuario podrá obtener un token de un Keycloak
  configurado automáticamente y usarlo para acceder a un endpoint protegido en el identity-service a través del api-gateway.

  ---

  Fase 1: Automatización de la Configuración de Keycloak (Infraestructura como Código)

   * Meta: Eliminar toda configuración manual de Keycloak. El realm debe crearse y configurarse automáticamente al iniciar el entorno con docker-compose.

   * Pasos:
       * [ ] 1.1. Configuración Manual (Temporal):
           * Inicia el entorno (docker-compose up).
           * Accede a la consola de Keycloak (http://localhost:9090) y realiza la configuración descrita en todoList_keycloak_setup.md una sola vez. Esto
             incluye:
               * Crear el realm noxtla-gourmet.
               * Crear el cliente público noxtla-frontend.
               * Crear el cliente confidencial noxtla-backend (y guardar su secret).
               * Crear el rol user.
               * Crear el usuario testuser con contraseña y asignarle el rol user.

       * [ ] 1.2. Exportar la Configuración del Realm:
           * En la consola de Keycloak, ve a "Realm settings" -> "Action" -> "Export".
           * Selecciona todas las opciones (exportar clientes, roles, etc.).
           * Guarda el archivo JSON resultante en la raíz del proyecto como realm-config.json.

       * [ ] 1.3. Integrar la Importación en Docker Compose:
           * Modifica el servicio keycloak en tu archivo docker-compose.yml:
               * Añade un volume para montar el archivo de configuración:

   1                 volumes:
   2                   - ./realm-config.json:/opt/keycloak/data/import/realm.json
               * Añade un command para que Keycloak importe el realm al arrancar:

   1                 command:
   2                   - start-dev
   3                   - --import-realm
       * [ ] 1.4. Verificación de la Automatización:
           * Detén y elimina los contenedores (docker-compose down -v).
           * Inicia de nuevo (docker-compose up).
           * Accede a la consola de Keycloak y verifica que el realm noxtla-gourmet y toda su configuración existen sin ninguna intervención manual.

       * [ ] 1.5. Limpieza:
           * Elimina el archivo copilot/todoList_keycloak_setup.md. Ya no es necesario.

  ---

  Fase 2: Implementación de Seguridad en `identity-service`

   * Meta: Proteger un endpoint dentro del identity-service para que solo sea accesible con un token JWT válido emitido por Keycloak.

   * Pasos:
       * [ ] 2.1. Añadir Dependencias de Seguridad:
           * En el pom.xml de identity-service, añade las dependencias de Spring Security:

   1             <dependency>
   2                 <groupId>org.springframework.boot</groupId>
   3                 <artifactId>spring-boot-starter-security</artifactId>
   4             </dependency>
   5             <dependency>
   6                 <groupId>org.springframework.boot</groupId>
   7                 <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
   8             </dependency>
       * [ ] 2.2. Configurar la Conexión a Keycloak:
           * En el application.yml de identity-service (o preferiblemente, en el archivo de configuración centralizado que lee el Config Server), añade la
             propiedad que apunta al issuer de Keycloak:

   1             spring:
   2               security:
   3                 oauth2:
   4                   resourceserver:
   5                     jwt:
   6                       issuer-uri: http://keycloak:9090/realms/noxtla-gourmet
       * [ ] 2.3. Crear un Endpoint Protegido:
           * Crea un nuevo controlador, por ejemplo UserController.java, en identity-service.
           * Añade un endpoint GET /api/v1/me que devuelva información del usuario autenticado.

   1             @RestController
   2             @RequestMapping("/api/v1/me")
   3             public class UserController {
   4                 @GetMapping
   5                 public String getMyInfo(JwtAuthenticationToken principal) {
   6                     return "Hola, " + principal.getToken().getSubject(); // Devuelve el 'sub' (ID de usuario) del token
   7                 }
   8             }
       * [ ] 2.4. Habilitar y Configurar Spring Security:
           * Crea una clase SecurityConfig.java para configurar el SecurityFilterChain.

    1             @Configuration
    2             @EnableWebSecurity
    3             public class SecurityConfig {
    4                 @Bean
    5                 public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    6                     http
    7                         .authorizeHttpRequests(authorize -> authorize
    8                             .anyRequest().authenticated()
    9                         )
   10                         .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()));
   11                     return http.build();
   12                 }
   13             }

  ---

  Fase 3: Integración y Verificación End-to-End

   * Meta: Validar que el flujo completo funciona a través del api-gateway.

   * Pasos:
       * [ ] 3.1. Configurar Enrutamiento en API Gateway:
           * Asegúrate de que el api-gateway-service tiene una ruta en su application.yml que dirige el tráfico al identity-service. Por ejemplo:

   1             - id: identity-service
   2               uri: lb://identity-service
   3               predicates:
   4                 - Path=/api/v1/identity/**
   5               filters:
   6                 - StripPrefix=3
              Nota: Puede que necesites ajustar el `StripPrefix` y el `Path` según tu endpoint exacto.

       * [ ] 3.2. Crear un Script de Verificación:
           * Crea un script de shell (ej. verify_auth.sh) para automatizar la prueba:
               1. Paso 1 (Script): Obtener un token de acceso de Keycloak usando curl y las credenciales del cliente noxtla-backend y del usuario testuser.
               2. Paso 2 (Script): Extraer el access_token del JSON de respuesta.
               3. Paso 3 (Script): Realizar una petición GET al api-gateway (http://localhost:80/api/v1/identity/me) incluyendo el token en la cabecera
                  Authorization: Bearer <TOKEN>.

       * [ ] 3.3. Ejecutar y Validar:
           * Ejecuta el script. La salida esperada es una respuesta 200 OK con el saludo "Hola, <ID_DEL_USUARIO>".
           * Intenta ejecutar el script sin la cabecera de autorización para confirmar que recibes un 401 Unauthorized.

  ---

  Fase 4: Finalización y Documentación

   * Meta: Actualizar la documentación del proyecto para reflejar el nuevo estado.

   * Pasos:
       * [ ] 4.1. Actualizar la Hoja de Ruta:
           * Marca las tareas correspondientes en project_roadmap.txt como completadas.
       * [ ] 4.2. Documentar el Flujo de Autenticación:
           * Añade una sección al README.md principal explicando cómo funciona la configuración automática de Keycloak y cómo ejecutar el script verify_auth.sh
             para probar la autenticación.