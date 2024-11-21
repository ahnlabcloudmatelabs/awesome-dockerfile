FROM openjdk:17-slim AS base
FROM whatap/kube_mon:1.7.11 AS whatap

FROM base AS builder
WORKDIR /app
ADD build.gradle /app/

RUN /app/gradlew build -x test --parallel --continue > /dev/null 2>&1 || true

COPY . /app
RUN /app/gradlew clean build --no-daemon

FROM base
WORKDIR /app

COPY --from=builder /app/build/libs/*-SNAPSHOT.jar /app/app.jar
COPY ./whatap /whatap
COPY --from=whatap /data/agent/micro/whatap.agent.kube.jar /whatap/whatap.agent.kube.jar

ENTRYPOINT [ "java" ]
CMD [ "--add-opens=java.base/java.lang=ALL-UNNAMED", \
  "-javaagent:/whatap/whatap.agent.kube.jar", \
  "-jar", \
  "app.jar", \
  "--spring.profiles.active=${PROFILE}" ]
