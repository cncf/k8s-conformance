# kOps conformance

Official documentation:
 - https://kops.sigs.k8s.io/
 - https://kops.sigs.k8s.io/getting_started/install/
 - https://kops.sigs.k8s.io/getting_started/aws/

By following these steps you may reproduce the kOps Conformance e2e results.

- [kOps conformance](#kops-conformance)
  - [Requirements](#requirements)
    - [AWS CLI](#aws-cli)
    - [Cluster state storage](#cluster-state-storage)
    - [Service account issuer discovery (IRSA)](#service-account-issuer-discovery-irsa)
    - [Install kOps](#install-kops)
    - [Install Sonobuoy](#install-sonobuoy)
  - [Create the kOps cluster](#create-the-kops-cluster)
  - [Run the conformance tests](#run-the-conformance-tests)
  - [Cleanup](#cleanup)
  - [Notes](#notes)

## Requirements
- kubectl (https://kubernetes.io/docs/tasks/tools/)
- AWS CLI (https://aws.amazon.com/cli/)

### AWS CLI

kOps needs credentials for an IAM user (or role) with the `AdministratorAccess` managed policy attached, to manage the cluster resources:

```shell
aws configure                  # Use your access and secret key here
aws sts get-caller-identity    # Check that the credentials work
```

If you prefer a dedicated IAM user instead, follow the official guide: https://kops.sigs.k8s.io/getting_started/aws/#setup-iam-user

### Cluster state storage

kOps stores the state and representation of your cluster in a dedicated S3 bucket. This bucket will become the source of truth for the cluster configuration. Bucket names are globally unique, so add your own prefix.

```shell
# Create your own name for the kOps state store bucket
kops_state_bucket="<your-unique-prefix>-kops-conformance-state-store"
aws s3api create-bucket \
    --bucket ${kops_state_bucket} \
    --region us-east-1
aws s3api put-bucket-versioning \
    --bucket ${kops_state_bucket} \
    --versioning-configuration Status=Enabled
```

### Service account issuer discovery (IRSA)

The cluster publishes its service account issuer discovery documents (OIDC) to a separate S3 bucket, enabling AWS IAM Roles for Service Accounts (IRSA). The discovery documents must be publicly readable, so this must be a different bucket than the state store:

```shell
kops_oidc_bucket="<your-unique-prefix>-kops-conformance-oidc-store"
aws s3api create-bucket \
    --bucket ${kops_oidc_bucket} \
    --region us-east-1 \
    --object-ownership BucketOwnerPreferred
aws s3api put-public-access-block \
    --bucket ${kops_oidc_bucket} \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl \
    --bucket ${kops_oidc_bucket} \
    --acl public-read
```

For more details see: https://kops.sigs.k8s.io/cluster_spec/#service-account-issuer-discovery-and-aws-iam-roles-for-service-accounts-irsa

### Install kOps

```shell
kops_version="v1.36.2"
os="darwin"    # or "linux"
arch="arm64"   # or "amd64"
curl -fsSLo ./kops "https://github.com/kubernetes/kops/releases/download/${kops_version}/kops-${os}-${arch}"
chmod +x ./kops

./kops version
# Client version: 1.36.2 (git-v1.36.2)
```

Some macOS systems may prevent the unsigned binary from running. Open macOS Privacy & Security settings and approve kOps for execution.

### Install Sonobuoy

```shell
sonobuoy_version="0.57.5"
curl -fsSL "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${sonobuoy_version}/sonobuoy_${sonobuoy_version}_${os}_${arch}.tar.gz" \
  | tar -xzf - sonobuoy
chmod +x ./sonobuoy
```

## Create the kOps cluster

```shell
# With --dns none, the cluster name is only a label and does not need to be
# a registered domain. The API is accessed through the load balancer hostname.
export KOPS_CLUSTER_NAME=conformance.k8s.io
# Point kOps to the state store created above
export KOPS_STATE_STORE=s3://${kops_state_bucket}

# Conformance tests require NodePort services to be reachable from the e2e
# test client, however kOps restricts this by default for security reasons.
# The nodePortAccess setting opens up NodePort access, matching the CI jobs:
# https://github.com/kubernetes/kops/blob/master/tests/e2e/kubetest2-kops/deployer/up.go
./kops create cluster ${KOPS_CLUSTER_NAME} \
    --dns none \
    --networking calico \
    --zones us-east-1a \
    --control-plane-size t3.large \
    --node-size t3.large \
    --node-count 4 \
    --discovery-store s3://${kops_oidc_bucket} \
    --set cluster.spec.nodePortAccess=0.0.0.0/0

# At this point, you can configure the cluster as you would like.
# The conformance cluster is a simple cluster, but conformance should pass
# with more complex configurations as well.
# For more information see: https://kops.sigs.k8s.io/cluster_spec/

./kops update cluster --yes --admin
```

Wait for the cluster instances to come up and bootstrap. This may take 5-10 minutes:

```shell
./kops validate cluster --wait 20m --count 3
```

Once validation passes, we can run the conformance tests.

## Run the conformance tests

A certified-conformance run executes all `[Conformance]` tests serially and takes 1.5-3 hours to complete:

```shell
./sonobuoy run --mode=certified-conformance --wait
results=$(./sonobuoy retrieve)
./sonobuoy results ${results}
mkdir ./results
tar xzf ${results} -C ./results

# The two files required for the CNCF submission:
cp ./results/plugins/e2e/results/global/e2e.log .
cp ./results/plugins/e2e/results/global/junit_01.xml .
```

## Cleanup

```shell
./sonobuoy delete --wait
./kops delete cluster ${KOPS_CLUSTER_NAME} --yes
aws s3 rb s3://${kops_state_bucket} --force
aws s3 rb s3://${kops_oidc_bucket} --force
rm -rf ./results ./sonobuoy* ./kops
```

## Notes

The submitted results were produced by the kOps CI conformance job ([e2e-kops-aws-conformance-1-36](https://prow.k8s.io/job-history/gs/kubernetes-ci-logs/logs/e2e-kops-aws-conformance-1-36)), which runs the same `[Conformance]` test suite through [kubetest2](https://github.com/kubernetes/kops/tree/master/tests/e2e) on an equivalent cluster configuration.
