FROM debian:9

LABEL maintainer="Stig Sandbeck Mathisen" \
      version="0.1.0" \
      io.k8s.description="Open source metric analytics & visualisation suite" \
      io.k8s.display-name="Visualisation" \
      description="Grafana is an open source metric analytics and visualisation suite. It is most commonly used for visualising time series data for infrastructure and application analytics but many use it in other domains including industrial sensors, home automation, weather, and process control"


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install adduser libfontconfig \
 && apt-get clean

ADD https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.3.1_amd64.deb /root
RUN dpkg -i /root/grafana_4.3.1_amd64.deb \
 && chgrp root /etc/grafana/grafana.ini /etc/grafana/ldap.toml \
 && install -d -o root -g root -m 0775 /var/lib/grafana \
 && install -d -o root -g root -m 0775 /var/log/grafana

EXPOSE 3000
VOLUME /etc/grafana /var/lib/grafana /var/log/grafana

USER 1000
WORKDIR /usr/share/grafana
CMD /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini cfg:default.paths.logs=/var/log/grafana cfg:default.paths.data=/var/lib/grafana/ cfg:default.paths.plugins=/var/lib/grafana/plugins
