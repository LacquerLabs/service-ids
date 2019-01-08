FROM alpine:3.8 AS geodb
ENV GEOIP_BASE_URL      http://geolite.maxmind.com/download/geoip/database
ENV GEOIP_CITY_DB       GeoLite2-City.mmdb
ENV GEOIP_DB_DIR        /data
RUN apk --update --no-cache add gzip
ADD ${GEOIP_BASE_URL}/${GEOIP_CITY_DB}.gz /tmp/
RUN gunzip -v -c /tmp/${GEOIP_CITY_DB}.gz > /tmp/${GEOIP_CITY_DB}

FROM docker.elastic.co/logstash/logstash:6.4.0
COPY config/logstash.conf /usr/share/logstash/pipeline/logstash.conf
COPY --from=geodb /tmp/GeoLite2-City.mmdb /data/GeoLite2-City.mmdb
