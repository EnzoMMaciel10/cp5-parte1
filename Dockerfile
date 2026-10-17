FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw -B -ntp -DskipTests dependency:go-offline

COPY src/ src/
RUN ./mvnw -B -ntp -DskipTests package

FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=build /app/target/cp5-0.0.1-SNAPSHOT.jar app.jar

ENV PORT=10000
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=60.0 -XX:+ExitOnOutOfMemoryError"
EXPOSE 10000

ENTRYPOINT ["java", "-jar", "app.jar"]
