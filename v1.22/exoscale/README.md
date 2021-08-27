# Conformance tests for Exoscale SKS

## Exoscale SKS cluster setup

We'll use the [Exoscale CLI](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/) to setup the cluster. Please ensure to use the [latest](https://github.com/exoscale/cli/releases) version available.

CLI configuration steps can be found [here](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#configuration)

1. We start first by creating the required security and anti-affinity groups:
```bash
exo firewall create sks-conformance

exo firewall add sks-conformance -d "NodePort services" -p tcp -P 30000-32767

exo firewall add sks-conformance -d "SKS Logs" -p tcp -P 10250

exo firewall add sks-conformance -d "Calico traffic" -p udp -P 4789 -s sks-conformance

exo anti-affinity-group create "SKS conformance"
```

2. Now we create the cluster:
```bash
exo sks create conformance --description 'SKS conformance' --kubernetes-version "1.21.1" --nodepool-instance-type extra-large --nodepool-size 3 --nodepool-security-group sks-conformance --nodepool-anti-affinity-group 'SKS conformance' --nodepool-instance-prefix 'conformance' --no-exoscale-ccm --no-metrics-server
```

3. We retrieve our kubeconfig:
```bash
exo sks kubeconfig conformance admin -t 2628000 --group system:masters > ~/.kube/config-conformance
export KUBECONFIG=~/.kube/config-conformance
```

4. We approve the pending node certificates:
```bash
kubectl get csr
kubectl certificate approve XXX
```

5. We retrieve our cluster ID. We'll need it later for Sonobuoy:
```bash
CLUSTERID=$(exo sks list conformance -O text | awk '{print $1}')
```

## Run Conformance Test

1. Download the v0.50.0 release of [Sonobuoy](https://github.com/heptio/sonobuoy/releases)

2. Run Sonobuoy (note the clusterid variable use):
```bash
sonobuoy run --mode=certified-conformance --timeout 21600 --plugin-env e2e.E2E_EXTRA_ARGS="--dns-domain=$CLUSTERID.cluster.local"
```

3. Check the status:
```bash
sonobuoy status
```

4. Once the status shows the run as completed, you can download the results archive by running:
```bash
sonobuoy retrieve
```
