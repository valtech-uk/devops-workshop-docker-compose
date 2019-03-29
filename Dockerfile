FROM openjdk:latest

WORKDIR /

COPY target/easy-notes-1.0.0.jar /app.jar

CMD ["java", "-jar", "/app.jar"]