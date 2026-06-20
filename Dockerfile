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

FROM ubuntu:24.04
RUN apt-get update && \
    apt-get install -y wget

RUN wget \
  http://NEW_NEXUS:8081/repository/maven-releases/com/example/demo-app/1.0.0/demo-app-1.0.0.jar \
  -O app.jar

ENTRYPOINT ["java","-jar","app.jar"]

