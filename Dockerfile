FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

ARG http://3.26.33.91:8081/
ARG com.example
ARG demo-app
ARG 1.0.2
ARG REPO=maven-releases
ARG admin
ARG admin@123

RUN apk add --no-cache curl

# Convert groupId to path (com/example)
RUN GROUP_PATH=$(echo $GROUP_ID | tr '.' '/') && \
    curl -u $USERNAME:$PASSWORD \
    -L "$NEXUS_URL/repository/$REPO/$GROUP_PATH/$ARTIFACT_ID/$VERSION/$ARTIFACT_ID-$VERSION.jar" \
    -o app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]