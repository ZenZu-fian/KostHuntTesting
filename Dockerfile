FROM tomcat:9.0-jdk17

# Install Ant
RUN apt-get update && apt-get install -y ant

# Copy project files
COPY . /app
WORKDIR /app

# Remove any old build artifacts
RUN rm -rf build dist

# Create fresh build directories
RUN mkdir -p build/web/WEB-INF/lib && \
    mkdir -p build/web/WEB-INF/classes && \
    mkdir -p dist

# Copy web files
RUN cp -r web/* build/web/

# Copy library JARs
RUN cp lib/*.jar build/web/WEB-INF/lib/

# Compile Java source files
RUN javac -d build/web/WEB-INF/classes -cp "lib/*:${CATALINA_HOME}/lib/*" $(find src -name "*.java")

# Create WAR file
RUN cd build/web && jar -cvf ../../dist/ROOT.war *

# Deploy to Tomcat
RUN rm -rf /usr/local/tomcat/webapps/* && \
    cp dist/ROOT.war /usr/local/tomcat/webapps/

ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
