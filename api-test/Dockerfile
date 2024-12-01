# Use uma imagem base para Java 21
FROM eclipse-temurin:21-jdk AS builder

# Diretório de trabalho dentro do container
WORKDIR /app

# Copiar os arquivos do projeto para o container
COPY . .

# Construir o projeto utilizando o Maven Wrapper
RUN ./mvnw clean package -DskipTests

# Etapa para criar a imagem mínima com o JAR
FROM eclipse-temurin:21-jre

# Diretório de trabalho na imagem final
WORKDIR /app

# Copiar o JAR gerado da etapa anterior para a imagem final
COPY --from=builder /app/target/*.jar app.jar

# Expor a porta padrão do Spring Boot
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
