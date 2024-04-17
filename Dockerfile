# Use a Maven image to create a build artifact
FROM maven:3.8.4-openjdk-17-slim as build
WORKDIR /app
COPY pom.xml .
# Download dependencies as a separate layer to improve caching
RUN mvn dependency:go-offline

COPY src ./src
# Build the application without running tests to speed up the build
RUN mvn -B package -DskipTests

# Use the official OpenJDK image for the runtime
FROM openjdk:17-slim
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
