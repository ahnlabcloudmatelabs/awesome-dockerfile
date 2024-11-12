FROM maven:3.9.9-eclipse-temurin-8 AS builder
WORKDIR /app

ADD ./pom.xml /app/pom.xml
RUN mvn verify clean --fail-never

COPY . /app
RUN mvn package

FROM tomcat:9.0-jdk8 AS base
WORKDIR /app

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

# env: JAVA_OPTS=-Dspring.profiles.active=${PROFILE}
