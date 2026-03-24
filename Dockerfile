# ====================================================
# STAGE 1 : BUILD
# ====================================================
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copier le pom.xml d'abord pour bénéficier du cache Docker
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et compiler
COPY src ./src
RUN rm -f src/main/resources/application-prod.properties src/main/resources/application-staging.properties
RUN mvn clean package -DskipTests -B

# ====================================================
# STAGE 2 : RUNTIME
# ====================================================
FROM eclipse-temurin:17-jre-alpine AS runtime

LABEL maintainer="elhadji10@gmail.com"
LABEL version="1.0"
LABEL description="Spring Boot Application with CI/CD"

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copier le JAR depuis le stage de build
COPY --from=builder /app/target/*.jar app.jar

# Sécurité : changer le propriétaire
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseContainerSupport"
ENV SPRING_PROFILES_ACTIVE=prod

ENTRYPOINT ["sh", "-c", "java  -jar app.jar"]
