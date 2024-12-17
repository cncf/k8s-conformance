To reproduce:
```bash
##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels

gcloud container clusters create --release-channel=rapid --cluster-version=1.32 gke-1-32

##
# Run the tests with hydrophone from Kubernetes
# https://github.com/kubernetes-sigs/hydrophone

hydrophone --conformance
```
