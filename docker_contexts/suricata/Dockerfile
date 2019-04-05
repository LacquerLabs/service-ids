FROM alpine:3.9

ENV TIMEZONE=UTC \
    ENV=/etc/profile \
    APP_ENV=prod

ENV FILEBEAT_VERSION=6.7.1 \
    FILEBEAT_URL=https://artifacts.elastic.co/downloads/beats/filebeat

# add in repos for testing
RUN apk --no-cache add dumb-init tzdata ca-certificates file procps wget py-pip suricata libc6-compat

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
    mkdir -p /container-init.d && \
    apk --no-cache del tzdata

# user for suricata
RUN addgroup -g 2000 suri && \
    adduser -S -H -u 2000 -D -g 2000 suri

# setup update-suricata
RUN if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    pip install --upgrade pip && \
    pip install pyyaml && \
    pip install https://github.com/OISF/suricata-update/archive/master.zip && \
    pip install --pre --upgrade suricata-update

# Include configs
COPY config/suricata.yaml /etc/suricata/suricata.yaml
COPY config/enable.conf /etc/suricata/enable.conf

# update suricata sources with update-sources
RUN suricata-update update-sources && \
    suricata-update enable-source ptresearch/attackdetection && \
    suricata-update enable-source oisf/trafficid && \
    suricata-update enable-source sslbl/ssl-fp-blacklist && \
    suricata-update list-enabled-sources && \
    suricata-update

# Install Filebeater
RUN wget ${FILEBEAT_URL}/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /tmp/filebeat.tgz && \
    tar -zxf /tmp/filebeat.tgz -C / && \
    mv /filebeat-${FILEBEAT_VERSION}-linux-x86_64 /filebeat

# Include more configs here to maximize cache
COPY config/capture-filter.bpf /etc/suricata/capture-filter.bpf
COPY config/filebeat.yml /etc/filebeat.yml
COPY config/cmd.sh /
COPY config/10_update_rules.sh /container-init.d/

# Clean up and set modifiers
RUN chmod a+x /cmd.sh /container-init.d/10_update_rules.sh && \
    rm -rf /root/* && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/run/suricata && \
    chmod go-w /etc/filebeat.yml && \
    chown -R suri:suri /var/run/suricata /var/lib/suricata /etc/suricata && \
    chmod -R ug+rw /var/run/suricata /var/lib/suricata /etc/suricata

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/cmd.sh"]
