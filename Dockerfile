# ===== Stage 1: Build ứng dụng =====
FROM maven:3.9.12-eclipse-temurin-21 AS build

WORKDIR /app

# Copy file khai báo trước để tận dụng cache
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

# Tải dependency trước
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build file jar
RUN mvn clean package -DskipTests


# ===== Stage 2: Chạy ứng dụng =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy file jar từ stage build sang
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]