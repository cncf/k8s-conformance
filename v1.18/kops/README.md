# kops conformance


Official documentation:
 - https://kops.sigs.k8s.io/
 - https://kops.sigs.k8s.io/getting_started/install/
 - https://kops.sigs.k8s.io/getting_started/aws/

By following these steps you may reproduce the kops Conformance e2e results.

Many of these documents can also be found in official kops documentation and
have been duplicated here to conform with guidelines.

- [kops conformance](#kops-conformance)
  - [Requirements](#requirements)
    - [AWS CLI](#aws-cli)
    - [Cluster State storage](#cluster-state-storage)
    - [Sonobuoy](#sonobuoy)
    - [kops release](#kops-release)
  - [Create kops Cluster](#create-kops-cluster)
  - [Run Sonobuoy e2e](#run-sonobuoy-e2e)
  - [Cleanup](#cleanup)

## Requirements
- Kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- AWS CLI (https://aws.amazon.com/cli/)

### AWS CLI

In order to correctly prepare your AWS account for kops, we require you to install the AWS CLI tools, and have API credentials for an account that has the permissions to create a new IAM account for kops later in the guide.

The kops user will require the following IAM permissions to function properly:

```
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
IAMFullAccess
AmazonVPCFullAccess
```

You can create the kops IAM user from the command line using the following:

```
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops

aws iam create-access-key --user-name kops
```

You should record the SecretAccessKey and AccessKeyID in the returned JSON output, and then use them below:
```
# configure the aws client to use your new IAM user
aws configure           # Use your new access and secret key here
aws iam list-users      # you should see a list of all your IAM users here
```

### Cluster State storage

In order to store the state of your cluster, and the representation of your cluster, we need to create a dedicated S3 bucket for kops to use. This bucket will become the source of truth for our cluster configuration. In this guide we'll call this bucket example-com-state-store, but you should add a custom prefix as bucket names need to be unique.

We recommend keeping the creation of this bucket confined to us-east-1, otherwise more work will be required.

```
# Create your own name for a kops conformance bucket
kops_conformance_bucket="our-kops-conformance-bucket"
aws s3api create-bucket \
    --bucket ${kops_conformance_bucket} \
    --region us-east-1
```


### Sonobuoy

```shell
# Install sonobuoy locally
sonobuoy_version="0.18.2"
# os_arch="linux_amd64"
os_arch="darwin_amd64"
wget -qO - "https://github.com/heptio/sonobuoy/releases/download/v${sonobuoy_version}/sonobuoy_${sonobuoy_version}_${os_arch}.tar.gz" | tar -xz --exclude LICENSE -C .
```

### kops release
```shell
# Install kops locally
kops_version="v1.18.0-beta.1"
# os_arch="linux-amd64"
os_arch="darwin-amd64"
wget -qO ./kops "https://github.com/kubernetes/kops/releases/download/${kops_version}/kops-${os_arch}"
chmod +x ./kops
```

## Create kops Cluster

To create cluster:

```shell
# Confirm Kops version above
./kops version
# Should output the version installed above along with a git hash:
# e.g. Version 1.18.0-beta.1 (git-ec8022b352)
```

Some MacOS systems may prevent the unsigned binary from running.
Open MacOS Security & Privacy settings and approve kops for execution.

```shell
# Name your cluster. In this case we use a local domain.
# You can setup more complex DNS configuration here:
# https://kops.sigs.k8s.io/getting_started/aws/#configure-dns
export CLUSTER_NAME=test.k8s.local
# Point kops to the state store created above
export KOPS_STATE_STORE=s3://${kops_conformance_bucket}

./kops create cluster ${CLUSTER_NAME} --zones us-east-2a

# Conformance tests require nodeports to be world-readable however
# kops disables this by default for security reasons. A feature flag
# is required to open up nodePort access.
#
# For more details see: https://github.com/kubernetes/test-infra/pull/14731
export KOPS_FEATURE_FLAGS=SpecOverrideFlag
./kops set cluster ${CLUSTER_NAME} cluster.spec.nodePortAccess=0.0.0.0/0

# At this point, you can configure your cluster as you would like.
# By design, kops gives you many options on different options to configure and bootstrap
# your clusters. The conformance cluster is a simple cluster but conformance should pass with
# more complex configurations as well.
#
# For more information see docs: https://kops.sigs.k8s.io/cluster_spec/

./kops update cluster ${CLUSTER_NAME} --yes
```

At this point we must wait for our cluster instances to come up and boot strap.  This may take 5-10 minutes.

Running `./kops validate cluster` allows you to see when the cluster is up and ready to run conformance.  Once validation passes, we can begin running Sonobuoy.

## Run Sonobuoy e2e
```
./sonobuoy run --wait --mode=certified-conformance
results=$(./sonobuoy retrieve)
mkdir ./results
tar xzf $results -C ./results
./sonobuoy e2e ${results}
```



## Cleanup
```shell
# Cleanup your cluster:
./kops delete cluster ${CLUSTER_NAME} --yes
rm -rf sonobuoy* kops
```