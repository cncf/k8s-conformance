# OpenShift Container Platform by Red Hat

## Create a cluster

1. Download `openshift-install` and `oc` binaries from https://console.redhat.com/openshift/downloads.
2. Download installation pull secret from https://console.redhat.com/openshift/install/pull-secret.
3. Run `openshift-install` and follow the instructions. When the cluster deployment completes,
   directions for accessing your cluster display in your terminal.

```
openshift-install create cluster --dir <installation_directory> --log-level=info
```

4. Set the environment variable KUBECONFIG pointing to your `.kubeconfig` from the previous step.

```
export KUBECONFIG=PATH_TO_KUBECONFIG
```

NOTE: Detailed instructions how to install OpenShift cluster can be found under https://docs.openshift.com/container-platform/.

## Run conformance tests

1. By default OpenShift security rules do not allow running with privileged access.
   Below commands allow unprivileged users to run root level containers. Once
   conformance testing is completed, you should restore the default security rules.

```
oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
oc adm policy add-scc-to-group anyuid system:authenticated system:serviceaccounts
```

2. Follow the [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
   to run the conformance tests. You will need to add the `--dns-namespace=openshift-dns`
   and `--dns-pod-labels=dns.operator.openshift.io/daemonset-dns=default`
   options so `sonobuoy` can find the cluster DNS pods:

```
sonobuoy run --mode=certified-conformance --dns-namespace=openshift-dns --dns-pod-labels=dns.operator.openshift.io/daemonset-dns=default
```

3. Once conformance testing is completed, restore the default security rules:

```
oc adm policy remove-scc-from-group anyuid system:authenticated system:serviceaccounts
oc adm policy remove-scc-from-group privileged system:authenticated system:serviceaccounts
```
