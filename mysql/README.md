# Demo MySQL Database Setup

Configuration in this directory deploys a MySQL Server in Kubernetes Cluster using Bitnami Helm Charts:

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `mysql`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install mysql --namespace mysql --create-namespace -f mysql-values.yaml
```