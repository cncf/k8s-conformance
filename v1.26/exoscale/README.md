# Conformance tests for Exoscale SKS

## Exoscale SKS cluster setup

We'll use the [Exoscale CLI](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/) to setup the cluster. Please ensure to use the [latest](https://github.com/exoscale/cli/releases) version available.

CLI configuration steps can be found [here](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#configuration)

1. We start first by creating the required security and anti-affinity groups:
```bash
exo compute security-group create sks-conformance

exo compute security-group add sks-conformance -d "NodePort services" -p tcp -P 30000-32767

exo compute security-group add sks-conformance -d "SKS Logs" -p tcp -P 10250

exo compute security-group add sks-conformance -d "Calico traffic" -p udp -P 4789 -s sks-conformance

exo compute anti-affinity-group create "SKS conformance"
```

2. Now we create the cluster:
```bash
exo compute sks create conformance --description 'SKS conformance' --kubernetes-version "1.26.0" --nodepool-instance-type extra-large --nodepool-size 3 --nodepool-security-group sks-conformance --nodepool-anti-affinity-group 'SKS conformance' --nodepool-instance-prefix 'conformance' --no-exoscale-ccm --no-metrics-server
```

3. We retrieve our kubeconfig:
```bash
exo compute sks kubeconfig conformance admin -t 2628000 --group system:masters > ~/.kube/config-conformance
export KUBECONFIG=~/.kube/config-conformance
```

4. We approve the pending node certificates:
```bash
kubectl get csr
kubectl certificate approve XXX
```

5. We retrieve our cluster ID. We'll need it later for Sonobuoy:
```bash
CLUSTERID=$(exo compute sks list conformance -O text | awk '{print $1}')
```

## Run Conformance Test

1. Download the v0.56.6 release of [Sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases)

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
