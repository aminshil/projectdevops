# Use OpenJDK 17 slim image
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Expose the port Spring Boot uses
EXPOSE 8089

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
