# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).

Install [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) based on your version of OS.
Use `eksctl` for quickly creating a cluster. EksCtl will take care of creating the required dependent resources for the cluster, including the managed nodes for running conformance tests.

```bash
eksctl create cluster --version=1.24 \
  --name=sample-cluster-1-24 \
  --managed --node-type c5.xlarge \
  --nodes 10 --node-volume-size 40
```

To run conformance tests, we recommend that you use a cluster that provides sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient [ENI limits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). We ran our conformance tests on a cluster with 10 c5.xlarge worker instances.

If using the example vpc and node group templates from the EKS documentation you need to allow outbound traffic on the ControlPlaneSecurityGroup for ports 1-1024 and inbound traffic on the NodeSecurityGroup for the same ports.

## Run conformance tests using sonobuoy CLI

Start the conformance tests on your EKS cluster

```bash
sonobuoy run \
--mode=certified-conformance \
--kubernetes-version=v1.24.7 \
--sonobuoy-image=sonobuoy/sonobuoy:v0.56.12
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```bash
sonobuoy logs -f
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```bash
OUTPUT_PATH=$(sonobuoy retrieve)
echo ${OUTPUT_PATH}
mkdir ./results
tar xzf ${OUTPUT_PATH} -C ./results
```

