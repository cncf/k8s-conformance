# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the EKS documentation, you received as part of whitelisting welcome package. For running conformance tests, we recommend to use a cluster that provides you with sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient ENI limits. We ran our conformance tests on a cluster with 10 m4.large worker instances.

## Run conformance tests

Start the conformance tests on your EKS cluster
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```
kubectl logs -f sonobuoy -n sonobuoy
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```
