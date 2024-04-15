# Use the official OpenJDK image to create a build artifact
FROM openjdk:17-slim as build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven
RUN mvn -B package -DskipTests

# Use the same OpenJDK image for the runtime
FROM openjdk:17-slim
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
