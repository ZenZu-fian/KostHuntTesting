FROM tomcat:9.0-jdk17

# Install Ant to build Java project
RUN apt-get update && apt-get install -y ant

# Copy project files into container
COPY . /app
WORKDIR /app

# Build the project into a WAR file
RUN ant clean dist

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy the WAR generated in dist folder as ROOT.war
RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Railway assigns PORT, Tomcat default 8080 is fine
ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
