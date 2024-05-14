# Demo MediaWiki Setup

Configuration in this directory builds and deploys a MediaWiki in Kubernetes Cluster:

## Prerequisites

- Kubernetes
- Jenkins Server

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install mysql --namespace mysql --create-namespace -f mysql-values.yaml
```