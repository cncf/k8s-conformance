To reproduce:

After installing Caicloud Compass, you can create a new kubernetes cluster following the docs [create-cluster](https://docs.caicloud.io/compass/clusters/create-cluster.html). Once the cluster is ready, ssh into master and run:

`curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -`.

