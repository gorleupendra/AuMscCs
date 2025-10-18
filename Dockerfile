# Use an official Maven image with Java 17.
FROM maven:3.8-openjdk-17

# Set the working directory.
WORKDIR /app

# Download the webapp-runner first and save it in the root.
# We use version 10.1.19.0 to match your Tomcat 10.1 / Servlet 6.0 spec.
RUN curl -L https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/10.1.19.0/webapp-runner-10.1.19.0.jar -o /app/webapp-runner.jar

# Copy your project code into the container.
COPY . .

# Run the Maven build command to create your .war file.
RUN mvn clean install

# Expose port 10000 for Render.
EXPOSE 10000

# This command runs the webapp-runner that was downloaded at the beginning.
CMD ["java", "-jar", "/app/webapp-runner.jar", "--port", "10000", "target/*.war"]
