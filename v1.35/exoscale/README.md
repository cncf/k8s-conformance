# Conformance tests for Exoscale SKS

## Exoscale SKS cluster setup

We'll use the [Exoscale CLI](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/) to set up the cluster. Please ensure to use the [latest](https://github.com/exoscale/cli/releases) version available.

CLI configuration steps can be found [here](https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/#configuration)

1. We start first by creating the required security and anti-affinity groups:
```bash
exo compute security-group create sks-conformance

exo compute security-group rule add sks-conformance \
    --description "NodePort services" \
    --protocol tcp \
    --network 0.0.0.0/0 \
    --port 30000-32767

exo compute security-group rule add sks-conformance \
    --description "SKS kubelet" \
    --protocol tcp \
    --port 10250 \
    --security-group sks-conformance

exo compute security-group rule add sks-conformance \
    --description "Calico traffic" \
    --protocol udp \
    --port 4789 \
    --security-group sks-conformance
```

2. Now we create the cluster:
```bash
exo compute sks create sks-conformance \
    --service-level pro \
    --kubernetes-version "1.35.0" \
    --nodepool-name mainpool \
    --nodepool-size 3 \
    --nodepool-instance-type cpu.huge \
    --nodepool-security-group sks-conformance \
    --nodepool-instance-prefix 'conformance'
```

3. We retrieve our kubeconfig:
```bash
exo compute sks kubeconfig sks-conformance admin -t 2628000 --group system:masters > ~/.kube/config-conformance
export KUBECONFIG=~/.kube/config-conformance
```

## Run Conformance Test

1. Download the latest release of [Sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases)

2. Run Sonobuoy:
```bash
sonobuoy run --mode=certified-conformance --timeout 21600
```

3. Check the status:
```bash
sonobuoy status
```

4. Once the status shows the run as completed, you can download the results archive by running:
```bash
sonobuoy retrieve
```
