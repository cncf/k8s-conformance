To reproduce:
```bash
##
# Env setup

export CLUSTER_NAME=gke-1-25

##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels

gcloud container clusters create --release-channel=rapid --cluster-version=1.25 $CLUSTER_NAME

##
# Run the tests

sonobuoy run --mode=certified-conformance
```
