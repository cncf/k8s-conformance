# Conformance testing Amazon EKS

## Setup EKS Cluster

Setup EKS cluster as per the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html). Sample command:

```bash
eksctl create cluster --version=1.16 --name=sample-cluster
```

Or

```bash
# https://github.com/aws/aws-k8s-tester
AWS_K8S_TESTER_EKS_ON_FAILURE_DELETE=true \
AWS_K8S_TESTER_EKS_REGION=us-west-2 \
AWS_K8S_TESTER_EKS_S3_BUCKET_CREATE=true \
AWS_K8S_TESTER_EKS_COMMAND_AFTER_CREATE_CLUSTER="aws eks describe-cluster --name GetRef.Name" \
AWS_K8S_TESTER_EKS_PARAMETERS_ENCRYPTION_CMK_CREATE=true \
AWS_K8S_TESTER_EKS_PARAMETERS_ROLE_CREATE=true \
AWS_K8S_TESTER_EKS_PARAMETERS_VERSION=1.16 \
AWS_K8S_TESTER_EKS_PARAMETERS_VPC_CREATE=true \
AWS_K8S_TESTER_EKS_CLIENTS=5 \
AWS_K8S_TESTER_EKS_CLIENT_QPS=30 \
AWS_K8S_TESTER_EKS_CLIENT_BURST=20 \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ENABLE=true \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ROLE_CREATE=true \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_FETCH_LOGS=true \
AWS_K8S_TESTER_EKS_ADD_ON_NODE_GROUPS_ASGS='{"GetRef.Name-ng-al2-cpu":{"name":"GetRef.Name-ng-al2-cpu","remote-access-user-name":"ec2-user","ami-type":"AL2_x86_64","image-id":"ami-0d3a471eb8364fe8b","asg-min-size":10,"asg-max-size":10,"asg-desired-capacity":10,"instance-types":["c5.xlarge"],"volume-size":40,"kubelet-extra-args":""}}' \
aws-k8s-tester eks create cluster --enable-prompt=true -p /tmp/${USER}-test-eks.yaml
```

To run conformance tests, we recommend that you use a cluster that provides sufficient resources - compute, storage as well as network IPs. EKS uses [Amazon VPC CNI plugin](https://github.com/aws/amazon-vpc-cni-k8s) which uses ENIs to provide IP addresses to your Kubernetes pods. Please ensure your worker node instance type provides you sufficient [ENI limits](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). We ran our conformance tests on a cluster with 10 c5.xlarge worker instances.

If using the example vpc and node group templates from the EKS documentation you need to allow outbound traffic on the ControlPlaneSecurityGroup for ports 1-1024 and inbound traffic on the NodeSecurityGroup for the same ports.

## Run conformance tests

Start the conformance tests on your EKS cluster

```bash
sonobuoy run \
  --mode=certified-conformance \
  --kubeconfig=/tmp/test-eks.kubeconfig.yaml \
  --kube-conformance-image gcr.io/google-containers/conformance:v1.16.8
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```bash
sonobuoy logs --kubeconfig=/tmp/test-eks.kubeconfig.yaml -f
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```bash
OUTPUT_PATH=$(sonobuoy retrieve --kubeconfig=/tmp/test-eks.kubeconfig.yaml)
echo ${OUTPUT_PATH}
mkdir ./results
tar xzf ${OUTPUT_PATH} -C ./results
```
