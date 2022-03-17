FROM openjdk:8u111-jdk
MAINTAINER Márcio Gurgel <marcio.rga@gmail.com>

EXPOSE 8080

COPY docker/dspace/scripts/entry-point-dspace.sh /usr/local/bin
RUN mkdir -p /root/sources/dspace-source/
COPY . /root/sources/dspace-source

RUN chmod 775 /usr/local/bin/entry-point-dspace.sh

ENTRYPOINT ["entry-point-dspace.sh"]

