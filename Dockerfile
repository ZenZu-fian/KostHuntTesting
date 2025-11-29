FROM tomcat:9.0-jdk17

# Install Ant
RUN apt-get update && apt-get install -y ant

# Copy project files
COPY . /app
WORKDIR /app

# Create lib folder if it doesn't exist and ensure JARs are there
# (You'll need to manually add mysql-connector.jar and jstl-1.2.jar to your project's lib folder)

# Build using Maven instead of Ant (simpler for Docker)
# OR manually compile and package
RUN mkdir -p build/web/WEB-INF/lib && \
    mkdir -p build/web/WEB-INF/classes && \
    cp -r web/* build/web/ && \
    cp lib/*.jar build/web/WEB-INF/lib/ && \
    javac -d build/web/WEB-INF/classes -cp "lib/*:${CATALINA_HOME}/lib/*" $(find src -name "*.java") && \
    cd build/web && jar -cvf ../../dist/ROOT.war *

# Deploy to Tomcat
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p dist && \
    cp dist/ROOT.war /usr/local/tomcat/webapps/

ENV PORT=8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
