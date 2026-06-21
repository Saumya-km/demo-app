# to build docker image taking out jar file fron nux repo
#FROM eclipse-temurin:17-jdk-alpine

#WORKDIR /app

#ARG http://3.26.33.91:8081/
#ARG com.example
#ARG demo-app
#ARG 1.0.2
#ARG REPO=maven-releases
#ARG admin
#ARG admin@123

#RUN apk add --no-cache curl

# Convert groupId to path (com/example)
#RUN GROUP_PATH=$(echo $GROUP_ID | tr '.' '/') && \
    #curl -u $USERNAME:$PASSWORD \
   # -L "$NEXUS_URL/repository/$REPO/$GROUP_PATH/$ARTIFACT_ID/$VERSION/$ARTIFACT_ID-$VERSION.jar" \
  #  -o app.jar

#EXPOSE 8081

#ENTRYPOINT ["java", "-jar", "app.jar"]

FROM eclipse-temurin:21-jre

WORKDIR /app

# Install wget
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Build arguments
ARG NEXUS_URL
ARG REPOSITORY=maven-releases
ARG GROUP_PATH=com/example
ARG ARTIFACT=demo-app
ARG APP_VERSION

# Download the JAR from Nexus
RUN wget -O app.jar \
${NEXUS_URL}/repository/${REPOSITORY}/${GROUP_PATH}/${ARTIFACT}/${APP_VERSION}/${ARTIFACT}-${APP_VERSION}.jar

EXPOSE 8082

ENTRYPOINT ["java","-jar","app.jar"]





