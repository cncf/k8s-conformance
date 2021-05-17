To reproduce:
```bash
##
# Env setup

export PROJECT_ID=my-project-id
export CLUSTER_NAME=gke-1-17

export CONFORMANCE_VERSION=v1.17.4
export SONOBUOY_IMAGE_VERSION=v0.17.2
export SONOBUOY_LOGS_IMAGE_VERSION=v0.3

##
# Create the cluster.
# This creates a private cluster on the rapid channel.
# https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
# https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
#
# At time of test (2020-05-07), the rapid channel was at 1.17.4-gke.10
#
# To reproduce after 1.17 graduates from the rapid channel, replace
#   --release-channel=rapid
# with --cluster-version=<latest-1.17.x>, e.g.:
#   --cluster-version=1.17.4-gke.10

gcloud beta container clusters create $CLUSTER_NAME \
  --release-channel=rapid \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.32/28 \
  --no-enable-master-authorized-networks

##
# GKE Private Clusters do not have access to public Docker Hub by default, so
# we republish the sonobuoy images to Google Container Registry. See:
#   https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#docker_hub

docker pull sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION
docker tag sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION
docker push gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION

docker pull sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION
docker tag sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION
docker push gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION

##
# Run the tests

sonobuoy run \
  --mode=certified-conformance \
  --kube-conformance-image-version=$CONFORMANCE_VERSION \
  --sonobuoy-image=gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION \
  --systemd-logs-image=gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION
```
