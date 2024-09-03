# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /app

# Copy the source code and pom.xml (or equivalent build files)
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine

EXPOSE 8080

ENV APP_HOME /usr/src/app

WORKDIR $APP_HOME

# Copy the jar file from the build stage
COPY --from=builder /app/target/*.jar ./app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
