FROM openjdk:8u111-jdk
LABEL maintainer="Márcio Gurgel <marcio.rga@gmail.com>"

EXPOSE 8080

RUN apt-get update; exit 0
RUN apt-get -y install cron

COPY docker/dspace/scripts/subscription_setting /etc/cron.d/subscription_setting
RUN chmod 775 /etc/cron.d/subscription_setting
RUN crontab /etc/cron.d/subscription_setting

COPY docker/dspace/scripts/entry-point-dspace.sh /usr/local/bin
RUN mkdir -p /root/sources/dspace-source/
COPY . /root/sources/dspace-source

RUN chmod 775 /usr/local/bin/entry-point-dspace.sh

ENTRYPOINT ["entry-point-dspace.sh"]
