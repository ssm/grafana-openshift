=======================
 Grafana for OpenShift
=======================

This is a docker image for Grafana designed for use with OpenShift.
It runs as an unprivileged user.

Usage
=====

* Create a project, and a new application

.. code-block:: shell

   oc project my-project
   oc new-app https://github.com/ssm/grafana-openshift.git --name grafana

* Add a persistent volume, mount inside the container at /var/lib/grafana

* Add a config map containing the files "grafana.ini" and "ldap.toml",
  mount it at /etc/grafana. You can find example configuration files
  at https://github.com/grafana/grafana/tree/master/conf
