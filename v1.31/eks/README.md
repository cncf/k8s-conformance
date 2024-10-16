# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).

Or install [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) based on your version of OS.
Use `eksctl` for quickly creating a cluster. EksCtl will take care of creating the required dependent resources for the cluster, including the managed nodes for running conformance tests.

```bash
eksctl create cluster --version=1.31 \
  --name=sample-cluster-1.31 \
  --managed --node-type c5.xlarge \
  --nodes 10 --node-volume-size 40
```

To run conformance tests, we recommend that you use a cluster that provides sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient [ENI limits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). We ran our conformance tests on a cluster with 10 c5.xlarge worker instances.

If using the example vpc and node group templates from the EKS documentation you need to allow outbound traffic on the ControlPlaneSecurityGroup for ports 1-1024 and inbound traffic on the NodeSecurityGroup for the same ports.

## Sonobuoy

Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/).

If you are on a Mac, you many need to open the Security & Privacy and approve sonobuoy for
execution.

```shell
if [[ "$(uname)" == "Darwin" ]]
then
  SONOBUOY=https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_darwin_amd64.tar.gz
else
  SONOBUOY=https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_386.tar.gz
fi
wget -qO- ${SONOBUOY} | tar -xz sonobuoy
chmod 755 sonobuoy
mv sonobuoy /usr/local/bin
```

## Run conformance tests using sonobuoy CLI

Start the conformance tests on your EKS cluster

```bash
sonobuoy run \
--mode=certified-conformance \
--kubernetes-version=v1.31.0 \
--sonobuoy-image=sonobuoy/sonobuoy:v0.57.1
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

## Cleanup
```bash
eksctl delete cluster --name=sample-cluster-1.31
```
