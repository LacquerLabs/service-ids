FROM docker.elastic.co/logstash/logstash:6.4.0

COPY config/logstash.conf /usr/share/logstash/pipeline/logstash.conf
COPY config/geodb/GeoLite2-City.mmdb /data/GeoLite2-City.mmdb
