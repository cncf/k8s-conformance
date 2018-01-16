## To Reproduce:

This will run sonobuoy against a kubernetes v1.8 cluster as created by [triton-kubernetes](https://github.com/joyent/triton-kubernetes).

### Clone the repo:

```
git clone https://github.com/joyent/triton-kubernetes.git
```

### Create a cluster manager

Run the `triton-kubernetes.sh` script with the `-c` option and follow the instructions answering questions about how the cluster manager should be configured.

### Create an environment (Kubernetes cluster)

Run the `triton-kubernetes.sh` script with the `-e` option and follow the instructions answering questions about how the environment should be configured.

### Get KubeConfig

To configure your own kubectl to talk to your newly created Kubernetes cluster, go to Kubernetes -> kubectl. Click on Generate Config to generate the necessary kube/config_file that you can download and add to your local directory.

### Install sonobuoy

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

### Fetch the results, and retain plugins/e2e/results/{e2e.log,junit.xml}

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
cd results
tar xfz sonobuoy.tar.gz
```
