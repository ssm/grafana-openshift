FROM debian:9

LABEL no.fnord.maintainer="Stig Sandbeck Mathisen <ssm@fnord.no>" \
      no.fnord.version="0.1.1" \
      io.openshift.tags="graphing,visualisation,metrics" \
      io.openshift.description="Grafana is an open source metric analytics and visualisation suite. It is most commonly used for visualising time series data for infrastructure and application analytics but many use it in other domains including industrial sensors, home automation, weather, and process control" \
      io.openshift.non-scalable="true" \
      io.openshift.expose-services="3000:http" \
      io.openshift.min-memory="20Mi" \
      io.openshift.min-cpu="4"

## Prepare for installation
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg apt-transport-https 

ADD gpg.key /root/
RUN apt-key add /root/gpg.key \
 && gpg --keyring /etc/apt/trusted.gpg --no-default-keyring --list-keys 418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB

## Install grafana, and modify permissions for docker
# No "stretch" packages yet, use their "jessie" repo
RUN echo 'deb https://packagecloud.io/grafana/stable/debian/ jessie main' \
  | tee /etc/apt/sources.list.d/grafana.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install grafana \
 && apt-get clean \
 && chgrp root /etc/grafana/grafana.ini /etc/grafana/ldap.toml \
 && install -d -o root -g root -m 0775 /var/lib/grafana \
 && install -d -o root -g root -m 0775 /var/log/grafana \

EXPOSE 3000
VOLUME /etc/grafana /var/lib/grafana /var/log/grafana

USER grafana:grafana
WORKDIR /usr/share/grafana
CMD /usr/sbin/grafana-server \
    --config=/etc/grafana/grafana.ini \
    cfg:default.paths.logs=/var/log/grafana \
    cfg:default.paths.data=/var/lib/grafana \
    cfg:default.paths.plugins=/var/lib/grafana/plugins
