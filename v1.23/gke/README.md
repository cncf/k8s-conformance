To reproduce:
```bash
##
# Env setup

export PROJECT_ID=my-project-id
export CLUSTER_NAME=gke-1-23

##
# Create the cluster.
# This creates a cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
#
# At time of test (2022-04-21), the rapid channel was at 1.22 by default,
# so we specify a cluster version of 1.23
#

gcloud --project $PROJECT_ID container clusters create $CLUSTER_NAME \
  --release-channel=rapid \
  --cluster-version=1.23

##
# Run the tests

sonobuoy run --mode=certified-conformance
```
