#adding comment to merge
# same, adding comment to run workflow!
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the JAR
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/burger-builder-backend-1.0.0.jar app.jar

# Expose the port (matches SERVER_PORT=8080)
EXPOSE 8080

# Health check for Azure Web App and Docker
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1

# Run the JAR with environment variables injected at runtime
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
