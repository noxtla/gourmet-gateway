# Etapa 1: Compilar la aplicación con Maven
FROM maven:3.9-eclipse-temurin-17 AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el pom.xml y el código fuente
COPY pom.xml .
COPY src ./src

# Construir la aplicación, omitiendo los tests para acelerar el proceso de build
RUN mvn clean install -DskipTests

# Etapa 2: Crear la imagen final y ligera
FROM eclipse-temurin:17-jre-jammy

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el JAR construido desde la etapa anterior
COPY --from=build /app/target/config-service-0.0.1-SNAPSHOT.jar app.jar

# Exponer el puerto en el que correrá la aplicación
EXPOSE 8888

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
