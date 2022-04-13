# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).
Use one of the following ways to create a cluster.

Install [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) based on your version of OS.
Use `eksctl` for quickly creating a cluster. EksCtl will take care of creating the required dependent resources for the cluster, including the managed nodes for running conformance tests.

```bash
eksctl create cluster --version=1.22 --name=sample-cluster --managed --node-type c5.xlarge --nodes 10 --node-volume-size 40
```

Or
Use [aws-k8s-tester](https://github.com/aws/aws-k8s-tester). Install a recent [release](https://github.com/aws/aws-k8s-tester/releases).
The parameters for running the aws-k8s-tester are following. This creates a cluster with 10 worker nodes.

```bash
AWS_K8S_TESTER_EKS_REGION=us-west-2 \
AWS_K8S_TESTER_EKS_PARAMETERS_ENCRYPTION_CMK_CREATE=true \
AWS_K8S_TESTER_EKS_PARAMETERS_ROLE_CREATE=true \
AWS_K8S_TESTER_EKS_PARAMETERS_VERSION=1.22 \
AWS_K8S_TESTER_EKS_PARAMETERS_VPC_CREATE=true \
AWS_K8S_TESTER_EKS_CLIENTS=5 \
AWS_K8S_TESTER_EKS_CLIENT_QPS=30 \
AWS_K8S_TESTER_EKS_CLIENT_BURST=20 \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ENABLE=true \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ROLE_CREATE=true \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_FETCH_LOGS=false \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ASGS='{"GetRef.Name-ng-al2-cpu":{"name":"GetRef.Name-ng-al2-cpu","remote-access-user-name":"ec2-user","ami-type":"AL2_x86_64","image-id":"","image-id-ssm-parameter":"/aws/service/eks/optimized-ami/1.22/amazon-linux-2/recommended/image_id","instance-types":["c5.xlarge"],"volume-size":40,"asg-min-size":10,"asg-max-size":10,"asg-desired-capacity":10,"kubelet-extra-args":"","cluster-autoscaler":{"enable":false}}}' \
AWS_K8S_TESTER_EKS_ADD_ON_CONFORMANCE_ENABLE=true \
aws-k8s-tester eks create cluster --enable-prompt=true -p test.yaml
```

aws-k8s-tester will automatically fetch results from sonobuoy pod.

To run conformance tests, we recommend that you use a cluster that provides sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient [ENI limits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). We ran our conformance tests on a cluster with 10 c5.xlarge worker instances.

If using the example vpc and node group templates from the EKS documentation you need to allow outbound traffic on the ControlPlaneSecurityGroup for ports 1-1024 and inbound traffic on the NodeSecurityGroup for the same ports.

## Run conformance tests using sonobuoy CLI

Start the conformance tests on your EKS cluster

```bash
sonobuoy run \
  --mode=certified-conformance \
  --kube-conformance-image-version=v1.22.6
  --sonobuoy-image=sonobuoy/sonobuoy:v0.20.0
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
