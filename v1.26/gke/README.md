To reproduce:
```bash
##
# Env setup

export CLUSTER_NAME=gke-1-26

##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels

gcloud container clusters create --release-channel=rapid --cluster-version=1.26 $CLUSTER_NAME

##
# Run the tests

sonobuoy run --mode=certified-conformance
```
