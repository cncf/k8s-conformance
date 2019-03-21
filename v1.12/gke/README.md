To reproduce:

```bash
export GCP_USERNAME=yaseenh@google.com
# You may need to use the latest available patch version of 1.12
export VERSION=1.12.5-gke.7
export CLUSTER_NAME=conformance

gcloud container clusters create $CLUSTER_NAME --network "default" --num-nodes 5 --machine-type n1-standard-4 --disk-size 50 --cluster-version=$VERSION --zone=us-central1-a
gcloud container cluster get-credentials --project yaseenh-gke-dev conformance --zone=us-central1-a
kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=$GCP_USERNAME

sonobuoy run
```

