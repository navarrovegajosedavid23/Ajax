# --- Etapa 1: Construcción (Build) ---
# Usamos una imagen que ya incluye Maven y el JDK de Java 17
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copiamos el archivo de configuración de Maven y el código fuente
COPY pom.xml .
COPY src ./src

# Compilamos y empaquetamos la aplicación (ignorando los tests para que sea más rápido)
RUN mvn clean package -DskipTests

# --- Etapa 2: Ejecución (Run) ---
# Usamos una imagen mucho más ligera que solo tiene el JRE (entorno de ejecución)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copiamos el archivo .jar generado en la etapa 1
COPY --from=build /app/target/*.jar app.jar

# Indicamos el puerto en el que escucha Spring Boot (8080 por defecto)
EXPOSE 8080

# Comando principal para arrancar el servidor web
ENTRYPOINT ["java", "-jar", "app.jar"]