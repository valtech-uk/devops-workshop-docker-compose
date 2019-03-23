FROM maven:3 as dependencies

WORKDIR /workspace

COPY pom.xml /workspace

RUN set -ex && \
    mvn -B dependency:go-offline

############################################################

FROM dependencies as build

COPY src ./src

RUN set -ex && \
    mvn clean install

############################################################

FROM build as sonar-check

ARG SONAR_ENABLED=false
ARG SONAR_URL=
ARG SONAR_ORGANIZATION=
ARG SONAR_USERNAME=
ARG SONAR_PASSWORD=
ARG SONAR_BRANCH=

RUN if [ "$SONAR_ENABLED" = "true" ] ; \
    then mvn -B sonar:sonar \
        -Dsonar.host.url=${SONAR_URL} \
        -Dsonar.organization=${SONAR_ORGANIZATION} \
        -Dsonar.branch.name=${SONAR_BRANCH} \
        -Dsonar.login=${SONAR_USERNAME} \
        -Dsonar.password=${SONAR_PASSWORD}; \
    fi

############################################################

FROM build

FROM openjdk:11 as runtime

WORKDIR /app

COPY --from=build /workspace/target/*.jar /app/service.jar

CMD ["java", "-jar", "/app/service.jar"]