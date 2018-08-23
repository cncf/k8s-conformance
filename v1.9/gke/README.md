To reproduce:

```bash
# Set this to the email address of your GCP user
export GCP_USERNAME=your-username@company.org
# NB. you may need to update this to the latest patch version of 1.10
export VERSION=1.9.7-gke.5
export CLUSTER_NAME=conformance

gcloud container clusters create $CLUSTER_NAME --network "default" --num-nodes 5 --machine-type n1-standard-4 --disk-size 50 --cluster-version=$VERSION

kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=$GCP_USERNAME

sonobuoy run
```
