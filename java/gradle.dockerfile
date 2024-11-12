FROM openjdk:17-slim AS base

FROM base AS builder
WORKDIR /app
ADD build.gradle /app/

RUN /app/gradlew build -x test --parallel --continue > /dev/null 2>&1 || true

COPY . /app
RUN /app/gradlew clean build --no-daemon

FROM base
WORKDIR /app

COPY --from=builder /app/build/libs/*-SNAPSHOT.jar /app/app.jar

ENTRYPOINT [ "java" ]
CMD [ "-jar", \
  "app.jar", \
  "--spring.profiles.active=${PROFILE}" ]
