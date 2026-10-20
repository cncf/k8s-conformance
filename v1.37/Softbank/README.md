# Infrinia AI Cloud OS v1.0.5-rc (K8S 1.37)

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

The Infrinia storage controller automatically injects a shared-storage PVC into every new namespace. Conformance tests expect exactly 1 PVC in their namespaces and the injected PVC makes the count 2, causing every PV lifecycle and StatefulSet test to fail with â€œExpected len:2 to have length 1â€

```shell
kubectl get deployments -A | grep -iE "storage|pvc|inject"
# If found: kubectl scale deployment <name> -n <namespace> --replicas=0
```

**Remove Infrinia VAP Policies and webhooks:**

Infrinia VAPs block privileged pods, hostPath volumes, namespace creation, PV modifications, dangerous capabilities, and more. The conformance suite requires all of these. Both the policies AND bindings must be deleted, and the webhook configurations must be removed.

```shell
cat > /tmp/vap-cleanup.sh << 'EOF'
kubectl patch ds policies -n infrinia -p '{"spec": {"template": {"spec": {"nodeSelector": {"conformance-test-pause": "true"}}}}}'

kubectl delete validatingadmissionpolicies $(kubectl get validatingadmissionpolicies -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep '^infrinia-') 2>/dev/null || true

kubectl get validatingadmissionpolicybindings --no-headers -o name | grep infrinia | xargs kubectl delete 2>/dev/null || true

kubectl delete validatingwebhookconfiguration infrinia-vap-protection-webhook 2>/dev/null || true
kubectl delete mutatingwebhookconfiguration infrinia-tenant-mutator-webhook 2>/dev/null || true
kubectl delete mutatingwebhookconfiguration ingress-fqdn 2>/dev/null || true
EOF

bash /tmp/vap-cleanup.sh

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
I1014 21:55:36.694906      24 e2e.go:109] Starting e2e run "1b2abdd8-dd63-4b04-bdd5-9b16a9a1e23b" on Ginkgo node 1
Running Suite: Kubernetes e2e suite - /usr/local/bin
====================================================
Random Seed: 1792014935 - will randomize all specs

Will run 462 of 3206 specs
SSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS•SS•SSSSSSSS•SS•SSSSSS•S•••S••SSS•SS•S•SSSSSSSS•S•SSSSSSSS•SSSSS•SSS••SS•SSSSS•SSSSSS•SS•SSSSSS••SSSSSSSSSSSSSSSSSSSS•SSSSSSSSSSSS••SSSSSSS•SSSSSSSSSSSS•SSSSSSSSS•S•S•SS•SSSSSS••SSSSSS•SSSSSSSSSSSS•SSSS•S••S•S•SSSSSSSSSSSSS••SS•SSSSS•SSSSSSSS•SSSSSSSSSSS•SS•S•SS•SS••SSS•S•SSS•SSSS•SSSSSSSSSSSS•SSS•SSSSSSSSSSSSSSSS•SS••SSSSS•SSSSSSSSSSSSSSSSSS•SSS•S••S••SSSS•SS•SSSSSSSSS•SSSSSSSSSS•S•SSSSS•SSSSSSS•SS•SS•SSSSS•SSSSSSSS•SSSSSSSSS•SSSSSSSSSSS•SS•SSSSSSSSS•SSSS•SSSSSS••••SSSSS•SSSSSSSSSSSSSSS•S•S•SS•SSSSSS•SSSSS•SSSSSSS•SSSSS•SSS•SSSS••SS•SSSSSSSSSSSSS•SSSS•SSSSSSSSSSSS••SSSSSSS•SS•SSSSSSSSSSSSS•SS•••SS•S•S•SSSS••SSSSSS•SSSS••S•SSSSSSSSSSSSS••S•SSSSSSSS••SSS•SS•SSSSSSSSSSSS•SSS••S•SS•SSSS•SSS•SSSSSS•SSSSSSSS•SSSSSSS•S•SSSSSSSSSSSS•SSS•••SSSSSS•SSSSSS•SS•S•SSSSSSSSS•SSSSSSSSS•SS•SSSSS•SS••SS•SS•SSSSSS••SS••SS•S•SSSSSSSSSS•••SSSSS•SS•SSSSSSS•S•SS•SSS•SS•SSS•SSSS•SSSSSSSSSSSSSSSS•SSSSSSSSSSSSSSSS•SSSS•SSSSSSS•S•SSSSSSSSS••S•SSS•SS•SSS•S•••S•SSSSS•SSSSSS•SSSSS•SSSS•SSSS••S•SSS•SSSS•S••S•SSSSS•SSSS•SSSSSS•SS•S•SS•S•SSSSSSSSSS•SS•SS•SSSSS•SSSSS•SSSSSSSSSSS•SS•SSSSSSSSSSSSSSSS••SS•SSSSSSSSSS•S•SSSSSSSS•S•SSSSSSSSSSS•SSS••••SSSSS••SSSSSSS•SSSSSSSSSSSSSSS•SS•SSSSSSSS•SS•SS••SS•S•SSS••SSSSSSS•S•SSSS••SS•SSSSSSS•SSS•SSS•S•S•S•SSSS•SS•SSSSSS•SSSSSSS••SSSSSS••SS•SS•SSSS•S••SSSSSSSSSSSSSS•SS•SSSSSSSSSSSSSS•S•SSSSSS•S•SSSSSSS•SSSSSS•SSS••SSSSSSSS•S•SSSSSSSS•SSS••SSSSSSSS•S••SSSSSSSSSS•S••SS•SSSSSS•SSSSSSS•SSSS•S•S•S•SSS•SSSSSSSS•S•SSSSSSSSS•SS•SS•SSSSSSSSSSSSS••SSSSSSSS•S••SSS•SSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSSSSSS•SS•SSSSS•SSSSS•SSSSSSSSSS•SSSSSSS•S•••S•SS••SSSSSSSSSSSSSSSSSSS••SS•SS•••S••S••SSSSSS••SSSSSSSSSSS•SS•SS•SSSSS••SSSSSSSSSSSSSSSSS•SS•SSSS•SSSSSS•SS•••S•SSSSSSS•SSSSSSSSSS•SSSSSSSSSS•SSS•SSSSSSSSSSSSSSSSSS•SSSSSS••S•••SSSSSS•SS•SSS•S•SSSSS•SSSSS•S•SSSSSSS•SSSSSSSS•SSS•SSSSSSSS•SSSS•SSSS••SSSS•SS•S•S••SSSSSSSSSSSSSSS•SSSSSSS•SS•S••SSS•SSSS••SSSSSSSSSS••SSSSSSSSSSSSS••SSSSSSS•SS•SSSSSSS•SSSSSS•SSSSSSSS•SSSSSSSSS•SSSSSSSSSSSSSSSSSSS•S•SSSSSSS•SSSSSS•SSSSSSSS•SSSSSSSSS•SSSSSSSSSSS•SSSSSSSSSSSSSSSSSSSSSSSSSSS•SSSSS•SS•S•SSSSSS••SSSSSSSSSSSSSSS•S•S•SSS•SSSSSSSSS•SSS••SSSSSSS•SSSSS•SSSSSSSSSSS•SSSSSSSSS•SSSSS•S•SSS•SSS•SSSSSSSSSSS•SSSSS•SSSSSSSSSSSSSS••SSS•SSSS•SS••SSSSSSS•S•SSSSSSSSSSSSSSS•S•SS•SSSSSSSSSSSSSSSSS•SSSS•••SSSS•SSS•SSSSSS•SSSS•SSSSS•S•SS•S••SS•S•SSSSSSS•SSSSSS•SSS•SSSSSSS•SS•SSSS•SSSSSSS•SSSSS•SSSSSS•S•SSSS•SSS

Ran 462 of 3206 Specs in 7408.313 seconds
SUCCESS! -- 462 Passed | 0 Failed | 0 Pending | 2744 Skipped
PASS

Ginkgo ran 1 suite in 2h3m30.167085359s
Test Suite Passed
```

# After the run: Decommission the conformance cluster

To restore full production security posture, simply destroy and recreate clusters. This is the recommended approach as it guarantees all platform security controls, VAPs, webhooks, and policies are fully restored without risk of partial or missed restores.

## Contact

For questions about this submission: thierno.diallo@g.softbank.co.jp
