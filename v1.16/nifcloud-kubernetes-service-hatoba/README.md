
# NIFCLOUD Kubernetes Service Hatoba

## Create cluster

Install and setup [NIFCLOUD SDK for Python](https://github.com/nifcloud/nifcloud-sdk-python).

```bash
# Environments
export CLUSTER_NAME=conformancetest
export FIREWALL_NAME=conformancetestfw
export SOURCE_IP=<YOUR SOURCE IP>

# Create Firewall Group
nifcloud-debugcli hatoba create-firewall-group --firewall-group "Name=$FIREWALL_NAME"
nifcloud-debugcli hatoba --endpoint-url authorize-firewall-group --firewall-group-name $FIREWALL_NAME --rules "CidrIp=$SOURCE_IP,Direction=IN,FromPort=6443,ToPort=6443,Protocol=TCP"

# Create Cluster
nifcloud-debugcli hatoba create-cluster --cluster "FirewallGroup=test,Locations=east-11,Name=$CLUSTER_NAME,NodePools=[{InstanceType=medium,NodeCount=3,Name=nodepool01}]"
nifcloud-debugcli hatoba wait cluster-running --cluster-name $CLUSTER_NAME

# Get Credentials
nifcloud-debugcli --profile=${PROFILE} hatoba get-cluster-credentials --cluster-name=$CLUSTER_NAME | jq -r ".Credentials" > kubeconfig
export KUBECONFIG=$PWD/kubeconfig
```

## Run conformance tests

Install and run [sonobuoy](https://github.com/vmware-tanzu/sonobuoy) as instructed on
[official instruction](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)

```bash
go get -u -v github.com/vmware-tanzu/sonobuoy
sonobuoy run --mode=certified-conformance
sonobuoy status
sonobuoy logs
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
sonobuoy delete
```