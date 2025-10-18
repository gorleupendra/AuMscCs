# === Stage 1: Build ===
FROM maven:3.9-eclipse-temurin-20 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# === Stage 2: Runtime ===
FROM eclipse-temurin:20-jre-jammy
WORKDIR /app

# Install curl to download the runner
RUN apt-get update && apt-get install -y curl

# ✅ Use stable version of Heroku Webapp Runner (works on Render)
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner-main/9.0.41.0/webapp-runner-main-9.0.41.0.jar



# Integrity check (optional but good practice)
RUN if [ $(stat -c%s "/app/webapp-runner.jar") -lt 1000000 ]; then \
    echo "ERROR: Downloaded webapp-runner.jar is corrupt or incomplete!" >&2; \
    exit 1; \
    fi

# Copy .war file from build stage
COPY --from=builder /app/target/*.war /app/app.war

# Expose Render port
EXPOSE 10000

# Run the webapp
CMD ["java", "-jar", "/app/webapp-runner.jar", "--port", "10000", "/app/app.war"]
