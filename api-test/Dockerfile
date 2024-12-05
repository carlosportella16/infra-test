# Etapa 1: Build do projeto
FROM openjdk:21 AS builder
WORKDIR /api-test

# Copiar arquivos do projeto para o container
COPY . .

# Verificar a existência do Maven Wrapper e conceder permissões de execução
RUN ls -la ./mvnw && chmod +x ./mvnw

# Executar o Maven para construir o projeto
RUN ./mvnw clean package -DskipTests

# Etapa 2: Construir a imagem final
FROM openjdk:21
WORKDIR /api-test

# Copiar o JAR gerado da etapa anterior
COPY --from=builder /api-test/target/*.jar app.jar

# Expor a porta da aplicação
EXPOSE 8080

# Comando de inicialização
ENTRYPOINT ["java", "-jar", "app.jar"]
