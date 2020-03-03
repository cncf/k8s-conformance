To reproduce:
```bash
# Set this to the email address of your GCP user
export GCP_USERNAME=jennybuckley@google.com
# NB. you may need to update this to the latest patch version of 1.14
export VERSION=1.14.3-gke.11
export CLUSTER_NAME=k8s-conformance-test

gcloud container clusters create $CLUSTER_NAME --network "default" --num-nodes 2 --cluster-version=$VERSION

kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=$GCP_USERNAME

sonobuoy run
```