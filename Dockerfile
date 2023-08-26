FROM bellsoft/liberica-openjdk-alpine:17
MAINTAINER foodpang

# ref: https://stackoverflow.com/questions/48523346/how-to-use-an-environment-variable-from-a-docker-compose-yml-in-a-dockerfile
ARG DB_HOST=db
ARG DB_PORT=3306

ARG FLYWAY_DRIVER=org.mariadb.jdbc.Driver
ARG FLYWAY_URL=jdbc:mariadb://db:3306/myapp
ARG FLYWAY_USER=root
ARG FLYWAY_PASSWORD=rootpw
ARG FLYWAY_SCHEMAS=myapp
ARG FLYWAY_DEFAULT_SCHEMA=myapp
ARG FLYWAY_LOCATIONS=filesystem:db/migration

ENV VAR_DB_HOST=$DB_HOST
ENV VAR_DB_PORT=$DB_PORT
ENV VAR_FLYWAY_DRIVER=$FLYWAY_DRIVER
ENV VAR_FLYWAY_URL=$FLYWAY_URL
ENV VAR_FLYWAY_USER=$FLYWAY_USER
ENV VAR_FLYWAY_PASSWORD=$FLYWAY_PASSWORD
ENV VAR_FLYWAY_SCHEMAS=$FLYWAY_SCHEMAS
ENV VAR_FLYWAY_DEFAULT_SCHEMA=$FLYWAY_DEFAULT_SCHEMA
ENV VAR_FLYWAY_LOCATIONS=$FLYWAY_LOCATIONS


# Install Git and other required tools
RUN apk update && apk add --no-cache git
RUN apk add --no-cache unzip
RUN apk add --no-cache bash && apk add --no-cache mysql-client

WORKDIR /
RUN mkdir /mine

WORKDIR /mine
COPY ./cpfiles/myapp-main.zip /mine/
COPY ./cpfiles/build.gradle /mine/
COPY ./cpfiles/flyway.testdb.conf /mine/
COPY ./cpfiles/myapp-docker-entrypoint.sh /mine/
COPY ./cpfiles/myapp-init.sql /mine/
COPY ./cpfiles/wait-for-it.sh /mine/
COPY ./cpfiles/wrapper-wait-for-it.sh /mine/

RUN unzip ./myapp-main.zip

WORKDIR ./myapp
RUN sh ./gradlew

WORKDIR /mine
# run without 'sh', you need bash
ENTRYPOINT ['./myapp-docker-entrypoint.sh']

