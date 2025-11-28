To reproduce:
```bash
##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
# Note: you must set one of --zone --location or --region
# For testing I have used --zone=us-east1 but another location should give the same results
gcloud container clusters create --release-channel=rapid --cluster-version=1.33 gke-1-33

##
# Run the tests with hydrophone from Kubernetes
# https://github.com/kubernetes-sigs/hydrophone
#
# There are mutiple install options
# I used: `go install sigs.k8s.io/hydrophone@v0.7.0`
hydrophone --conformance
```
