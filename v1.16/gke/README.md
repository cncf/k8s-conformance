To reproduce:
```bash
##
export PROJECT_ID=my-project-id
# At time of test (2020-02-24), clusters in the GKE Rapid Release Channel are
#   running 1.16.4-gke.30.

export CONFORMANCE_VERSION=v1.16.4
export SONOBUOY_IMAGE_VERSION=v0.17.2
export SONOBUOY_LOGS_IMAGE_VERSION=v0.3
export CLUSTER_NAME=c116
export ZONE=us-east4-a

##
# These tests were run against a GKE private cluster:
#   https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters

gcloud --project $PROJECT_ID beta container clusters create $CLUSTER_NAME \
  --zone $ZONE --release-channel "rapid" \
  --create-subnetwork name=$CLUSTER_NAME-subnet \
  --no-enable-master-authorized-networks \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr 172.16.0.32/28 \
  --no-enable-basic-auth \
  --no-issue-client-certificate

##
# GKE Private Clusters do not have access to public Docker Hub by default, so
# we republish the sonobuoy images to Google Container Registry. See:
#   https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#docker_hub

docker pull sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION
docker tag sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION \
  gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION
docker push gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION

docker pull sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION
docker tag sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION \
  gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION
docker push gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION

##
# Run the tests

sonobuoy run \
  --mode=certified-conformance \
  --sonobuoy-image=gcr.io/$PROJECT_ID/sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION \
  --systemd-logs-image=gcr.io/$PROJECT_ID/sonobuoy/systemd-logs:$SONOBUOY_LOGS_IMAGE_VERSION \
  --kube-conformance-image-version=$CONFORMANCE_VERSION
```
