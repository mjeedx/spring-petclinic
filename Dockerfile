#FROM openjdk:11
#COPY . /usr/src/myapp
#WORKDIR /usr/src/myapp

FROM openjdk:8-jre-alpine
RUN mkdir /app && addgroup -S webuser && adduser -S -s /bin/false -G webuser webuser
WORKDIR /app
COPY . /app
RUN chown -R webuser:webuser /app
USER webuser
EXPOSE 8080
CMD ["java", "-jar", "main.jar"]
#CMD tail -f /dev/null  I just want to understand what this command do in current context
