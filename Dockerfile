FROM openjdk:8-jre-alpine
ADD wildfly-swarm-consul-demo-swarm.jar /opt/wildfly-swarm-consul-demo-swarm.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/opt/wildfly-swarm-consul-demo-swarm.jar"]