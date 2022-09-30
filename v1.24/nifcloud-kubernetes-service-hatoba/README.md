# NIFCLOUD Kubernetes Service Hatoba

## Create cluster

Install and setup [NIFCLOUD SDK for Python](https://github.com/nifcloud/nifcloud-sdk-python).

```bash
# Environments
export CLUSTER_NAME=conformancetest
export FIREWALL_NAME=conformancetestfw
export SOURCE_IP=<YOUR SOURCE IP>
export KUBERNETES_VERSION=v1.24.3

# Create Firewall Group
nifcloud hatoba create-firewall-group --firewall-group "Name=$FIREWALL_NAME"
nifcloud hatoba authorize-firewall-group --firewall-group-name $FIREWALL_NAME --rules "CidrIp=$SOURCE_IP,Direction=IN,FromPort=6443,ToPort=6443,Protocol=TCP"

# Create Cluster
nifcloud hatoba create-cluster --cluster "FirewallGroup=$FIREWALL_NAME,KubernetesVersion=$KUBERNETES_VERSION,ListOfRequestLocations=jp-east-11,Name=$CLUSTER_NAME,ListOfRequestNodePools=[{InstanceType=medium,NodeCount=3,Name=nodepool01}]"
nifcloud hatoba wait cluster-running --cluster-name $CLUSTER_NAME

# Get Credentials
nifcloud hatoba get-cluster-credentials --cluster-name=$CLUSTER_NAME | jq -r ".Credentials" > kubeconfig
export KUBECONFIG=$PWD/kubeconfig
```

## Run conformance tests

Install and run [sonobuoy](https://github.com/vmware-tanzu/sonobuoy) as instructed on
[official instruction](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)

```bash
go install github.com/vmware-tanzu/sonobuoy@v0.56.10
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
sonobuoy delete
```
