FROM springci/graalvm-ce:java17-0.12.x AS builder
 
ADD . /build
WORKDIR /build

RUN apt update
RUN apt-get install wget -y

RUN cd /opt && wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && tar -xzvf apache-maven-3.8.6-bin.tar.gz

RUN /opt/apache-maven-3.8.6/bin/mvn -Pnative -DskipTests clean package

## We use a Docker multi-stage build here so that we only take the compiled native Spring Boot app from the first build container
FROM springci/graalvm-ce:java17-0.12.x
# 
## Add Spring Boot Native app sapin to Container
COPY --from=builder "/build/target/sapin-native-image" sapin
# 
## Fire up our Spring Boot Native app by default
ENTRYPOINT [ "sh", "-c", "./sapin" ]
