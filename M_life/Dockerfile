# Stage 1: Build the backend
FROM gradle:7.5.1-jdk17 AS backend-build

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle clean build

# Stage 2: Create the final image
FROM openjdk:17-jdk-slim

# Set up the backend
COPY --from=backend-build /app/build/libs/*.jar /app/app.jar

# Expose port
EXPOSE 8080

# Start the backend with timezone set to Asia/Seoul
CMD ["java", "-jar", "-Duser.timezone=Asia/Seoul", "/app/app.jar"]
