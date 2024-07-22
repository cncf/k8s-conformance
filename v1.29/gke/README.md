To reproduce:
```bash
##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels

gcloud container clusters create --release-channel=rapid --cluster-version=1.29 gke-1-29

##
# Run the tests

sonobuoy run --mode=certified-conformance
```
