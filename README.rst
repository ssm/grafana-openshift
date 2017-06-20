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

* Add a persistent volume, mount inside the container at ``/var/lib/grafana``.
  If you want persistent logging as well, do the same for ``/var/log/grafana``
  and update the configuration.

* Add a config map containing the files "grafana.ini" and "ldap.toml",
  mount it at /etc/grafana. You can find example configuration files
  at https://github.com/grafana/grafana/tree/master/conf

* Add a service and a route

* Add health checks

  The path /api/health can be used to check for liveness and
  readiness.

.. code-block:: yaml

   livenessProbe:
     failureThreshold: 3
     httpGet:
       path: /api/health
       port: 3000
       scheme: HTTP
     periodSeconds: 10
     successThreshold: 1
     timeoutSeconds: 1

   readinessProbe:
     failureThreshold: 3
     httpGet:
       path: /api/health
       port: 3000
       scheme: HTTP
     periodSeconds: 10
     successThreshold: 1
     timeoutSeconds: 1
