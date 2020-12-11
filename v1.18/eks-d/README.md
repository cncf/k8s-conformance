# Conformance testing Amazon EKS-D

## Setup EKS-D Cluster

Setup EKS-D cluster according to the [EKS-D documentation](https://distro.eks.amazonaws.com/).

By following these steps you may reproduce the EKS-D Conformance e2e results using
[kops](https://github.com/kubernetes/kops).

## Requirements
There are several packages you will need to install and configure.

### Kubectl

Install and configure the Kubernetes command-line tool
[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### AWS CLI

Install and configure the [AWS CLI](https://aws.amazon.com/cli/)

### Sonobuoy

Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.19.0).

If you are on a Mac, you many need to open the Security & Privacy and approve sonobuoy for
execution.

### kops

Install kops:

```shell
# Install kops locally
kops_version="v1.18.2"
# os_arch="linux-amd64"
os_arch="darwin-amd64"
wget -qO ./kops "https://github.com/kubernetes/kops/releases/download/${kops_version}/kops-${os_arch}"
chmod +x ./kops
```

Validate `kops` is working correctly:

```shell

# Confirm Kops version above
./kops version
# Should output the version installed above
```

Some MacOS systems may prevent the unsigned binary from running. Open MacOS Security & Privacy settings
and approve kops for execution.

## Create kops Cluster

Use this shell script to create a cluster:

```shell
#!/usr/bin/env bash

if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name must be an FQDN: <yourcluster>.yourdomain.com or <yourcluster>.sub.yourdomain.com"
    read -r -p "What is the name of your Cluster? " CLUSTER_NAME
fi

export CNI_VERSION_URL=https://distro.eks.amazonaws.com/kubernetes-1-18/releases/1/artifacts/plugins/v0.8.7/cni-plugins-linux-amd64-v0.8.7.tar.gz
export CNI_ASSET_HASH_STRING=sha256:7426431524c2976f481105b80497238030e1c3eedbfcad00e2a9ccbaaf9eef9d

# Create a unique s3 bucket name, or use an existing S3_BUCKET environment variable
export S3_BUCKET=${S3_BUCKET:-"kops-state-store-$(cat /dev/random | LC_ALL=C tr -dc "[:alpha:]" | tr '[:upper:]' '[:lower:]' | head -c 32)"}
export KOPS_STATE_STORE=s3://$S3_BUCKET
echo "Using S3 bucket $S3_BUCKET: to use with kops run"
echo
echo "    export KOPS_STATE_STORE=s3://$S3_BUCKET"
echo "    export CNI_VERSION_URL=$CNI_VERSION_URL"
echo "    export CNI_ASSET_HASH_STRING=$CNI_ASSET_HASH_STRING"
echo

# Create the bucket if it doesn't exist
_bucket_name=$(aws s3api list-buckets  --query "Buckets[?Name=='$S3_BUCKET'].Name | [0]" --out text)
if [ $_bucket_name == "None" ]; then
    echo "Creating S3 bucket: $S3_BUCKET"
    if [ "$AWS_DEFAULT_REGION" == "us-east-1" ]; then
        aws s3api create-bucket --bucket $S3_BUCKET
    else
        aws s3api create-bucket --bucket $S3_BUCKET --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
    fi
fi

kops create cluster $CLUSTER_NAME \
    --zones "us-west-2a,us-west-2b,us-west-2c" \
    --master-zones "us-west-2a" \
    --networking kubenet \
    --node-count 3 \
    --node-size m5.xlarge \
    --kubernetes-version https://distro.eks.amazonaws.com/kubernetes-1-18/releases/1/artifacts/kubernetes/v1.18.9 \
    --master-size m5.large \
    --dry-run \
    -o yaml > $CLUSTER_NAME.yaml
echo "Add the following content to your Cluster spec in $CLUSTER_NAME.yaml"
echo
cat << EOF >> /dev/stdout
  kubeAPIServer:
    image: public.ecr.aws/eks-distro/kubernetes/kube-apiserver:v1.18.9-eks-1-18-1
  kubeControllerManager:
    image: public.ecr.aws/eks-distro/kubernetes/kube-controller-manager:v1.18.9-eks-1-18-1
  kubeScheduler:
    image: public.ecr.aws/eks-distro/kubernetes/kube-scheduler:v1.18.9-eks-1-18-1
  kubeProxy:
    image: public.ecr.aws/eks-distro/kubernetes/kube-proxy:v1.18.9-eks-1-18-1
  # Metrics Server will be supported with kops 1.19
  metricsServer:
    enabled: true
    image: public.ecr.aws/eks-distro/kubernetes-sigs/metrics-server:v0.4.0-eks-1-18-1
  authentication:
    aws:
      image: public.ecr.aws/eks-distro/kubernetes-sigs/aws-iam-authenticator:v0.5.2-eks-1-18-1
  kubeDNS:
    provider: CoreDNS
    coreDNSImage: public.ecr.aws/eks-distro/coredns/coredns:v1.7.0-eks-1-18-1
    externalCoreFile: |
      .:53 {
          errors
          health {
            lameduck 5s
          }
          kubernetes cluster.local. in-addr.arpa ip6.arpa {
            pods insecure
            #upstream
            fallthrough in-addr.arpa ip6.arpa
          }
          prometheus :9153
          forward . /etc/resolv.conf
          loop
          cache 30
          loadbalance
          reload
      }
  masterKubelet:
    podInfraContainerImage: public.ecr.aws/eks-distro/kubernetes/pause:v1.18.9-eks-1-18-1
  # kubelet might already be defined, append the following config
  kubelet:
    podInfraContainerImage: public.ecr.aws/eks-distro/kubernetes/pause:v1.18.9-eks-1-18-1
EOF
```

After you have finished configuring your cluster, run the update:

```
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

Wait for the cluster to come up which may take 5-10 minutes.

Running `./kops validate cluster` allows you to see when the cluster is up and ready to run conformance.

## Run Sonobuoy e2e
```
./sonobuoy run --mode=certified-conformance --wait --kube-conformance-image k8s.gcr.io/conformance:v1.18.9
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
