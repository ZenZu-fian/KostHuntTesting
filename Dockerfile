FROM tomcat:9.0-jdk17

# Install Ant to build Java project
RUN apt-get update && apt-get install -y ant

# Download CopyLibs JAR
RUN mkdir -p /usr/share/ant/lib && \
    curl -o /usr/share/ant/lib/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    https://repo1.maven.org/maven2/org/netbeans/external/org-netbeans-modules-java-j2seproject-copylibstask/8.2/org-netbeans-modules-java-j2seproject-copylibstask-8.2.jar

# Copy project files into container
COPY . /app
WORKDIR /app

# Download CopyLibs JAR to a specific location
RUN mkdir -p /opt/netbeans/ant/extra && \
    curl -L -o /opt/netbeans/ant/extra/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    https://repo1.maven.org/maven2/org/netbeans/external/org-netbeans-modules-java-j2seproject-copylibstask/8.2/org-netbeans-modules-java-j2seproject-copylibstask-8.2.jar

# Build with the CopyLibs property set
RUN ant -Dlibs.CopyLibs.classpath=/opt/netbeans/ant/extra/org-netbeans-modules-java-j2seproject-copylibstask.jar clean dist

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

