# Use an official Maven image with Java 17.
FROM maven:3.8-openjdk-17

# Set the working directory.
WORKDIR /app

# Copy your project code into the container.
COPY . .

# Run the Maven build command to create your .war file.
# This will now succeed because the problematic plugin is gone.
RUN mvn clean install

# Download the webapp-runner directly using curl.
# The -L flag follows redirects, ensuring a complete download.
# We use version 10.1.19.0 to match your jakarta.servlet-api version 6.0.0
RUN curl -L https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/10.1.19.0/webapp-runner-10.1.19.0.jar -o target/webapp-runner.jar

# Expose port 10000 for Render.
EXPOSE 10000

# This command runs the webapp-runner.jar that was just downloaded.
CMD ["java", "-jar", "target/webapp-runner.jar", "--port", "10000", "target/*.war"]