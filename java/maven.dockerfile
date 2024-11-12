FROM maven:3.9.9-sapmachine-11 AS builder
WORKDIR /app

ADD ./pom.xml /app/pom.xml
RUN mvn verify clean --fail-never

COPY . /app
RUN mvn package

FROM openjdk:11-slim AS base
WORKDIR /app

# see `pom.xml` and search `<packaging>`, if it is a `jar` or `war`, then use `*.jar` or `*.war` respectively
COPY --from=builder /app/target/*.jar /app/app.jar

ENTRYPOINT [ "java" ]
CMD [ "-jar", \
  "app.jar", \
  "--spring.profiles.active=${PROFILE}" ]
