#base image
FROM openjdk:16-alpine3.13 as builder
ENV JAVA_HOME=/opt/openjdk-16
WORKDIR /usr/src/myapp
COPY mvnw pom.xml ./
COPY .mvn .mvn
COPY src ./src
RUN ./mvnw clean install -DskipTests

FROM alpine:3.15.0 as packager
RUN apk --no-cache add openjdk11=11.0.14_p9-r0 && \
    rm -rf /etc/apk/cache
ENV JAVA_MINIMAL="/opt/java-minimal"
RUN /usr/lib/jvm/java-11-openjdk/bin/jlink \
    --verbose \
    --add-modules \
        java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --compress 2 --strip-debug --no-header-files --no-man-pages \
    --release-info="add:IMPLEMENTOR=radistao:IMPLEMENTOR_VERSION=radistao_JRE" \
    --output "$JAVA_MINIMAL"

FROM alpine:3.15.0
ENV JAVA_HOME=/opt/java-minimal
ENV PATH="$PATH:$JAVA_HOME/bin"
COPY --from=packager "$JAVA_HOME" "$JAVA_HOME"
COPY --from=builder /usr/src/myapp/target/it-specialty-0.0.1-SNAPSHOT.jar app.jar
CMD [ "java","-Dserver.port=8083", "-jar", "app.jar" ]
EXPOSE 8083
