# gov NCP issue: must finish gradle build before `docker build`
# insert 'Build Commands' in `chmod +x ./gradlew && ./gradlew build`
# It cause under error
# [2024-07-12 16:57] Downloading https://services.gradle.org/distributions/gradle-8.2-bin.zip
# [2024-07-12 16:58] Exception in thread "main" java.io.IOException: Downloading from https://services.gradle.org/distributions/gradle-8.2-bin.zip failed: timeout (10000ms)

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY ./build/libs/*-SNAPSHOT.jar /app/app.jar
ENTRYPOINT [ "java" ]
CMD [ "-jar", "app.jar" ]

# !!CAUTION!! (NCP Issue)
# I was tried to `tee ...yaml > /dev/null <<EOT` and `cat >> ...yaml <<EOT`
# but, NCP 'SourceBuild' doesn't recognize whitespace
# so I had no choice but to use `echo`

# Before `docker build`, should insert under script
# (Must setup env)
#
# echo "server:" >> src/main/resources/application.yaml
# ...
