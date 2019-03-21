FROM maven:3 as dependencies

WORKDIR /workspace

COPY pom.xml /workspace

RUN set -ex && \
    mvn -B dependency:go-offline

############################################################

FROM dependencies as build

COPY . /workspace

RUN set -ex && \
    mvn clean install

############################################################

FROM openjdk:11 as runtime

WORKDIR /app

COPY --from=build /workspace/target/*.jar /app/service.jar

CMD ["java", "-jar", "/app/service.jar"]