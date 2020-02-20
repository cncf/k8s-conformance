To reproduce:
```bash
# NB. you may need to update this to the latest patch version of 1.15
export GKE_VERSION=1.15.9-gke.8
export CONFORMANCE_VERSION=v1.15.9
export CLUSTER_NAME=c115
export ZONE=us-east1-c

gcloud beta container clusters create $CLUSTER_NAME \
  --zone $ZONE --cluster-version $VERSION \
  --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" \
  --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --max-pods-per-node "110" --num-nodes "3" --enable-stackdriver-kubernetes \
  --enable-ip-alias --network "default" \
  --default-max-pods-per-node "110" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade \
  --enable-autorepair

sonobuoy run \
  --mode=certified-conformance \
  --kube-conformance-image-version=$CONFORMANCE_VERSION
```
