# Etapa 1: Build do projeto
FROM openjdk:21 AS builder
WORKDIR /api-test
COPY . .
RUN .api-test/mvnw clean package -DskipTests

# Etapa 2: Construir a imagem final
FROM openjdk:21
WORKDIR api-test
COPY --from=builder /app/target/*.jar api-test.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
