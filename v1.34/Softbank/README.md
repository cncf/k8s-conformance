# Infrinia AI Cloud OS v1.0.1-rc (K8S 1.34) 

Softbank's Infrinia AI Cloud OS is a GPU-native managed Kubernetes platform built for AI/ML workloads.

# Prerequisites

- A deployed a 2 node K8S cluster using Infrinia AI Cloud OS using APIs or Graphical Portal  
- SSH access to a tenant control plane node  
- [Hydrophone](https://github.com/kubernetes-sigs/hydrophone) installed on the control plane

```shell
go install sigs.k8s.io/hydrophone@latest
```

# Step 1: Prepare conformance cluster

Before running conformance tests on an Infrinia cluster, the following platform-specific policies must be temporarily suspended as they enforce production security controls that intentionally restrict operations the conformance suite requires (privileged pods, hostPath volumes, namespace creation, PV modifications):

Run all steps from the tenant control plane using the `kubeadmin` identity.

**Disable authorization webhooks** (run on each control plane node via SSH):

By default, Infrinia enforces authorization webhooks to prevent unauthorized access. The kube-apiserver authorization webhook can block conformance test API calls that use non-standard auth patterns. Must be disabled on all 3 control plane nodes before running conformance.

```shell
sudo sed -i \
  -e '/--authorization-config/d' \
  -e '/--authorization-mode/d' \
  -e '/- --allow-privileged=true/a\    - --authorization-mode=Node,RBAC' \
  /etc/kubernetes/manifests/kube-apiserver.yaml
```

Wait \~30 seconds for the API server to restart on each node.

**Scale down Infrinia Storage Controller** (if present):

The Infrinia storage controller automatically injects a shared-storage PVC into every new namespace. Conformance tests expect exactly 1 PVC in their namespaces and the injected PVC makes the count 2, causing every PV lifecycle and StatefulSet test to fail with “Expected len:2 to have length 1”

```shell
kubectl get deployments -A | grep -iE "storage|pvc|inject"
# If found: kubectl scale deployment <name> -n <namespace> --replicas=0
```

**Remove Infrinia VAP Policies and webhooks:**

Infrinia VAPs block privileged pods, hostPath volumes, namespace creation, PV modifications, dangerous capabilities, and more. The conformance suite requires all of these. Both the policies AND bindings must be deleted, and the webhook configurations must be removed.

```shell
kubectl patch ds policies -n infrinia -p '{"spec": {"template": {"spec": {"nodeSelector": {"conformance-test-pause": "true"}}}}}' 

kubectl delete validatingadmissionpolicies $(kubectl get validatingadmissionpolicies -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep '^infrinia-') 2>/dev/null || true kubectl get validatingadmissionpolicybindings --no-headers -o name | grep infrinia | xargs 

kubectl delete 2>/dev/null || true kubectl delete validatingwebhookconfiguration infrinia-vap-protection-webhook 2>/dev/null || true kubectl delete mutatingwebhookconfiguration infrinia-tenant-mutator-webhook 2>/dev/null || true kubectl delete mutatingwebhookconfiguration ingress-fqdn 2>/dev/null || true
```

# Step 2: Run Conformance

```shell
RUN_DIR=~/conformance/standard-results-$(date +%Y%m%d-%H%M)
mkdir -p $RUN_DIR

hydrophone --conformance \
  --parallel 1 \
  --output-dir $RUN_DIR/
```

# Step 3: Validate Results

```shell
RESULTS_DIR=$(ls -td ~/conformance/standard-results-* | head -1)

grep -E "Passed|Failed|Skipped" $RESULTS_DIR/e2e.log | tail -5
grep "\[FAILED\]" $RESULTS_DIR/e2e.log | wc -l
```

## Results

```
Ran 424 of 7137 Specs in 6403.994 seconds
SUCCESS! -- 424 Passed | 0 Failed | 0 Pending | 6713 Skipped
PASS
```

# After the run: Decommission the conformance cluster

To restore full production security posture, simply destroy and recreate clusters. This is the recommended approach as it guarantees all platform security controls, VAPs, webhooks, and policies are fully restored without risk of partial or missed restores.

## Contact

For questions about this submission: thierno.diallo@g.softbank.co.jp

