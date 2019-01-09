# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM alpine:3.8

RUN	mkdir /crontab-ui && \
	touch /etc/crontabs/root && \
	chmod +x /etc/crontabs/root

WORKDIR /crontab-ui

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs npm \
      supervisor \
      docker

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui
RUN	npm install

ENV	HOST=0.0.0.0 \
	PORT=8000 \
	CRON_PATH=/etc/crontabs \
	CRON_IN_DOCKER=true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
