FROM alpine:3.8

ENV TIMEZONE=UTC \
    ENV=/etc/profile \
    APP_ENV=prod

# add in repos for testing
RUN echo '@testing https://dl-3.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    echo '@community https://dl-3.alpinelinux.org/alpine/v3.4/community'

# Install packages
RUN apk --update --no-cache add dumb-init tzdata ca-certificates file procps wget py3-pip suricata filebeat@testing

# configure up some container stuff
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    update-ca-certificates && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh && \
    echo alias dir=\'ls -alh --color\' >> /etc/profile && \
    echo 'source ~/.profile' >> /etc/profile && \
    echo 'cat /etc/os-release' >> /etc/motd && \
    echo 'cat /etc/os-release' >> ~/.profile && \
    echo 'date' >> ~/.profile && \
    mkdir -p /container-init.d

# user for suricata
RUN addgroup -g 2000 suri && \
    adduser -S -H -u 2000 -D -g 2000 suri

# setup update-suricata
RUN pip3 install pyyaml && \
    pip3 install https://github.com/OISF/suricata-update/archive/master.zip && \
    pip3 install --pre --upgrade suricata-update

# Include configs
COPY config/suricata.yaml /etc/suricata/suricata.yaml

# update suricata sources with update-sources
RUN suricata-update update-sources && \
    suricata-update enable-source ptresearch/attackdetection && \
    suricata-update enable-source oisf/trafficid && \
    suricata-update enable-source sslbl/ssl-fp-blacklist && \
    suricata-update list-enabled-sources && \
    suricata-update

# Clean up
RUN chmod a+x /cmd.sh /container-init.d/10_update_rules.sh && \
    rm -rf /root/* && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/run/suricata && \
    chown -R suri:suri /var/run/suricata && \
    chmod -R ug+rw /var/run/suricata

# Include more configs here to maximize cache
COPY config/capture-filter.bpf /etc/suricata/capture-filter.bpf
COPY config/filebeat.yml /etc/filebeat.yml
COPY config/cmd.sh /
COPY config/10_update_rules.sh /container-init.d/

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/cmd.sh"]
