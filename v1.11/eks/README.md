# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html). To run conformance tests, we recommend that you use a cluster that provides sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient [ENI limits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). We ran our conformance tests on a cluster with 3 m4.large worker instances.

If using the example vpc and node group templates from the EKS documentation you need to allow outbound traffic on the ControlPlaneSecurityGroup for ports 1-1024 and inbound traffic on the NodeSecurityGroup for the same ports.

## Run conformance tests

Start the conformance tests on your EKS cluster
```
sonobuoy run
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```
sonobuoy logs -f
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```
sonobuoy results
```
