FROM alpine:latest
LABEL maintainer="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.created="$(date +%Y-%m-%d\ %H:%M)" \
      org.opencontainers.image.authors="alcapone1933 <alcapone1933@cosanostra-cloud.de>" \
      org.opencontainers.image.url="https://hub.docker.com/r/alcapone1933/script-server" \
      org.opencontainers.image.version="v1.18.0" \
      org.opencontainers.image.ref.name="alcapone1933/script-server" \
      org.opencontainers.image.title="script-server" \
      org.opencontainers.image.description="Web UI for your scripts with execution management"

ENV TZ=Europe/Berlin
ARG VERSION=1.18.0

RUN apk add --update --no-cache tzdata python3 py3-pip curl && \
    rm -rf /var/cache/apk/* && mkdir -p /app mkdir -p /app/conf && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    wget https://github.com/bugy/script-server/releases/download/$VERSION/script-server.zip -O /tmp/script-server.zip
# COPY releases/latest /tmp
COPY app/conf.json /app/conf/conf.json

WORKDIR /app

RUN  unzip /tmp/script-server.zip -d /app && rm -rfv /tmp/script-server.zip && \
     pip install --break-system-packages -r requirements.txt

EXPOSE 5000

CMD [ "python3", "launcher.py" ]
