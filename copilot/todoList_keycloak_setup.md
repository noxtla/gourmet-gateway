# Lista de Tareas: Configuración de Keycloak

Esta es una guía para la configuración manual de Keycloak que se debe realizar en la consola de administración (`http://localhost:9090`).

- [ ] **1. Iniciar Sesión:**
  - [ ] Accede a la [Consola de Administración](http://localhost:9090).
  - [ ] Usa las credenciales `admin` / `admin`.

- [ ] **2. Crear el Realm:**
  - [ ] En la esquina superior izquierda, pasa el cursor sobre "Master" y haz clic en "Add Realm".
  - [ ] Nombra el nuevo realm `noxtla-gourmet`.
  - [ ] Haz clic en "Create".

- [ ] **3. Crear el Cliente para Frontend:**
  - [ ] En el menú de la izquierda, ve a "Clients".
  - [ ] Haz clic en "Create client".
  - [ ] **Client ID:** `noxtla-frontend`
  - [ ] **Client Protocol:** `openid-connect` (por defecto)
  - [ ] Haz clic en "Next".
  - [ ] **Client authentication:** `Off` (esto lo hace un cliente público).
  - [ ] **Valid redirect URIs:** Pon `http://localhost:3000/*` (asumiendo un frontend en el puerto 3000). Puedes añadir más URIs después.
  - [ ] Haz clic en "Save".

- [ ] **4. Crear el Cliente para Backend (Service-to-Service):**
  - [ ] Vuelve a "Clients" y haz clic en "Create client".
  - [ ] **Client ID:** `noxtla-backend`
  - [ ] Haz clic en "Next".
  - [ ] **Client authentication:** `On` (esto lo hace un cliente confidencial).
  - [ ] Deja los flujos de autenticación como están y haz clic en "Save".
  - [ ] Una vez guardado, ve a la pestaña "Credentials".
  - [ ] Copia el **Client secret**. Lo necesitaremos para la configuración de Spring Boot.

- [ ] **5. Crear un Rol de Prueba:**
  - [ ] En el menú de la izquierda, ve a "Realm roles".
  - [ ] Haz clic en "Create role".
  - [ ] **Role name:** `user`.
  - [ ] Haz clic en "Save".

- [ ] **6. Crear un Usuario de Prueba:**
  - [ ] En el menú de la izquierda, ve a "Users".
  - [ ] Haz clic en "Add user".
  - [ ] **Username:** `testuser`.
  - [ ] Haz clic en "Create".
  - [ ] Ve a la pestaña "Credentials".
  - [ ] Configura una contraseña para el usuario (ej. `password`) y desmarca "Temporary" para que no pida cambiarla.
  - [ ] Ve a la pestaña "Role mapping".
  - [ ] Haz clic en "Assign role".
  - [ ] Busca y asigna el rol `user` que creaste.

- [ ] **7. Obtener el Issuer URI:**
  - [ ] En el menú de la izquierda, ve a "Realm settings".
  - [ ] En la pestaña "General", busca el enlace "OpenID Endpoint Configuration".
  - [ ] Ábrelo y copia el valor del campo `issuer`. Este es el URI que usarán nuestros microservicios para conectar con Keycloak.
