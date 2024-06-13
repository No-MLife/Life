# Stage 1: Build the frontend
FROM node:20.14.0 AS frontend-build

WORKDIR /app
COPY reactworkspace/mlife/package*.json ./
RUN npm install
COPY reactworkspace/mlife ./
RUN npm run build

# Stage 2: Build the backend
FROM gradle:7.5.1-jdk17 AS backend-build

WORKDIR /app
COPY M_life/build.gradle M_life/settings.gradle ./
COPY M_life/src ./src
RUN gradle clean build

# Stage 3: Create the final image
FROM openjdk:17-jdk-slim

# Set up the backend
COPY --from=backend-build /app/build/libs/*.jar /app/app.jar

# Set up the frontend
RUN apt-get update && apt-get install -y nginx
COPY --from=frontend-build /app/dist /usr/share/nginx/html

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose ports
EXPOSE 8080 80

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start the applications
CMD ["/start.sh"]
