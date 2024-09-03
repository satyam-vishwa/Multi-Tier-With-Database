# Stage 1: Build the application
FROM maven:3.8.7-openjdk-17 AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and other necessary files
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Add execute permissions to the mvnw script
RUN chmod +x ./mvnw

# Download dependencies (cached if pom.xml has not changed)
RUN ./mvnw dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Create a lightweight runtime image
FROM openjdk:17-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the jar file from the builder stage
COPY --from=builder /app/target/your-app.jar /app/your-app.jar

# Command to run the application
CMD ["java", "-jar", "/app/your-app.jar"]
