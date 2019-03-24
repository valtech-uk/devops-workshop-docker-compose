FROM openjdk:11 as runtime

WORKDIR /app

COPY /target/*.jar /app/service.jar

CMD ["java", "-jar", "/app/service.jar"]