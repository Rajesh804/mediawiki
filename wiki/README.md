# Demo MediaWiki Setup

Configuration in this directory builds and deploys a MediaWiki in Kubernetes Cluster:

## Prerequisites

- Kubernetes
- Jenkins Server

## Installing the Chart

To install the chart with the release name `mediawiki`:

```console
helm upgrade --install mediawiki \
    --set-string image.tag=latest \
    --namespace dev --create-namespace \
    -f ./charts/mediawiki/dev-values.yaml \
    ./charts/mediawiki
```