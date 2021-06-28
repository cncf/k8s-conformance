# Running conformance tests on  k8s cluster created with airshipctl


## Test Scenario

The conformance tests were executed on a 3 node kubernetes cluster with 1 control plane and 2 worker nodes.
The cluster was created with airshipctl using docker provider.
The kubernetes cluster created was on version  1.19.11 and the sonobuoy version that was used was v0.51.0

## Prerequisites 

### Creating the kubernetes cluster with airshipctl

To setup the kubernetes cluster with airshipctl please follow  the instructions available at https://docs.airshipit.org/airshipctl/providers/cluster_api_docker.html

`Note:`
There is currently an open issue to fix airshipctl phase run clusterctl-init-ephemeral with docker provider.
For more information check https://github.com/airshipit/airshipctl/issues/565
To apply the fix for the above issue, these additionl steps needs to executed after running `airshipctl document pull -n --debug` 

```
$ cd /tmp/airship/airshipctl

$ git review -d https://review.opendev.org/c/airship/airshipctl/+/795403

$ wget https://review.opendev.org/changes/airship%2Fairshipctl\~782614/revisions/16/archive\?format\=tgz -O fix.tar

$ tar xvf fix.tar
```

## Running the conformance tests

The conformance tests use sonobuoy and are availalbe as a part of the scripts in the patchset  
https://review.opendev.org/c/airship/airshipctl/+/782614


```
$ git clone https://review.opendev.org/airship/airshipctl  

$ git fetch "https://review.opendev.org/airship/airshipctl" refs/changes/14/782614/13 && git checkout FETCH_HEAD

```

```
$ cd airshipctl

$ KUBE_CONFIG=~/.airship/kubeconfig ./tools/deployment/sonobuoy/01-install_sonobuoy.sh

$ KUBE_CONFIG=~/.airship/kubeconfig CONFORMANCE_MODE=certified-conformance ./tools/deployment/sonobuoy/02-run_default.sh

+ : /home/rishabh/.airship/kubeconfig
+ : certified-conformance
+ : 10800
+ : target-cluster
+ mkdir -p /tmp/sonobuoy_snapshots/e2e
+ cd /tmp/sonobuoy_snapshots/e2e
+ sonobuoy run --plugin e2e --plugin systemd-logs -m certified-conformance --context target-cluster --kubeconfig /home/rishabh/.airship/kubeconfig --wait --timeout 10800 --log_dir /tmp/sonobuoy_snapshots/e2e
INFO[0000] created object                                name=sonobuoy namespace= resource=namespaces
INFO[0000] created object                                name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
INFO[0000] created object                                name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
INFO[0000] created object                                name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
INFO[0000] created object                                name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
INFO[0000] created object                                name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
INFO[0000] created object                                name=sonobuoy namespace=sonobuoy resource=pods
INFO[0000] created object                                name=sonobuoy-aggregator namespace=sonobuoy resource=services
+ kubectl get all -n sonobuoy --kubeconfig /home/rishabh/.airship/kubeconfig --context target-cluster
NAME           READY   STATUS    RESTARTS   AGE
pod/sonobuoy   1/1     Running   0          109m

NAME                          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/sonobuoy-aggregator   ClusterIP   10.133.61.203   <none>        8080/TCP   109m
+ sonobuoy status --kubeconfig /home/rishabh/.airship/kubeconfig --context target-cluster
         PLUGIN     STATUS   RESULT   COUNT
            e2e   complete   passed       1
   systemd-logs   complete   passed       3

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
+ sonobuoy logs --kubeconfig /home/rishabh/.airship/kubeconfig --context target-cluster
namespace="sonobuoy" pod="sonobuoy" container="kube-sonobuoy"
time="2021-06-10T15:38:54Z" level=info msg="Scanning plugins in ./plugins.d (pwd: /)"
time="2021-06-10T15:38:54Z" level=info msg="Scanning plugins in /etc/sonobuoy/plugins.d (pwd: /)"
time="2021-06-10T15:38:54Z" level=info msg="Directory (/etc/sonobuoy/plugins.d) does not exist"
time="2021-06-10T15:38:54Z" level=info msg="Scanning plugins in ~/sonobuoy/plugins.d (pwd: /)"
time="2021-06-10T15:38:54Z" level=info msg="Directory (~/sonobuoy/plugins.d) does not exist"
I0610 15:38:54.922979       1 request.go:557] Throttling request took 74.061628ms, request: GET:https://10.128.0.1:443/apis/apiextensions.k8s.io/v1?timeout=32s
I0610 15:38:54.956695       1 request.go:557] Throttling request took 107.81546ms, request: GET:https://10.128.0.1:443/apis/admissionregistration.k8s.io/v1beta1?timeout=32s
I0610 15:38:54.989142       1 request.go:557] Throttling request took 140.18151ms, request: GET:https://10.128.0.1:443/apis/apiextensions.k8s.io/v1beta1?timeout=32s
I0610 15:38:55.023295       1 request.go:557] Throttling request took 174.292814ms, request: GET:https://10.128.0.1:443/apis/scheduling.k8s.io/v1?timeout=32s
I0610 15:38:55.057349       1 request.go:557] Throttling request took 208.420824ms, request: GET:https://10.128.0.1:443/apis/admissionregistration.k8s.io/v1?timeout=32s
time="2021-06-10T15:38:55Z" level=info msg="Filtering namespaces based on the following regex:.*"
time="2021-06-10T15:38:55Z" level=info msg="Namespace airshipit Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace calico-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace capd-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace capi-kubeadm-bootstrap-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace capi-kubeadm-control-plane-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace capi-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace capi-webhook-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace cert-manager Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace default Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace kube-node-lease Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace kube-public Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace kube-system Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace sonobuoy Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Namespace tigera-operator Matched=true"
time="2021-06-10T15:38:55Z" level=info msg="Starting server Expected Results: [{global e2e} {target-cluster-control-plane-8m52s systemd-logs} {target-cluster-md-0-6b59c4f65-5pcx5 systemd-logs} {target-cluster-md-0-6b59c4f65-cqpjz systemd-logs}]"
time="2021-06-10T15:38:55Z" level=info msg="Starting annotation update routine"
time="2021-06-10T15:38:55Z" level=info msg="Starting aggregation server" address=0.0.0.0 port=8080
time="2021-06-10T15:38:55Z" level=info msg="Running plugin" plugin=e2e
time="2021-06-10T15:38:55Z" level=info msg="Running plugin" plugin=systemd-logs
time="2021-06-10T15:39:50Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-cqpjz plugin_name=systemd-logs
time="2021-06-10T15:39:57Z" level=info msg="received aggregator request" client_cert= node=target-cluster-control-plane-8m52s plugin_name=systemd-logs
time="2021-06-10T15:40:05Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-5pcx5 plugin_name=systemd-logs
time="2021-06-10T15:40:17Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:40:45Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:40:52Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:40:59Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:40:59Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:41:18Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:41:28Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:41:43Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:41:48Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:41:57Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:42:25Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:44:46Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:01Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:03Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:24Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:25Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:29Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:42Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:46:50Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:19Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:19Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:26Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:28Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:33Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:41Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:41Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T15:47:44Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
...
...
time="2021-06-10T17:19:21Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:23Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:48Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:51Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:51Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:51Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:51Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:19:53Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:09Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:11Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:11Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:13Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:21Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:25Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:36Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:52Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:52Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:20:54Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:21:11Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:21:13Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:21:19Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:21:38Z" level=info msg="received aggregator request" client_cert= node=target-cluster-control-plane-8m52s plugin_name=systemd-logs
time="2021-06-10T17:21:38Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-control-plane-8m52s already received"
time="2021-06-10T17:21:45Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-5pcx5 plugin_name=systemd-logs
time="2021-06-10T17:21:45Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-md-0-6b59c4f65-5pcx5 already received"
time="2021-06-10T17:22:01Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-cqpjz plugin_name=systemd-logs
time="2021-06-10T17:22:01Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-md-0-6b59c4f65-cqpjz already received"
time="2021-06-10T17:22:04Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:22:09Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:22:12Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:22:19Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:23:52Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:23:57Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:24:02Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:24:06Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:08Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:19Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:40Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:45Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:50Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:25:54Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:15Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:36Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:36Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:41Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:45Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:26:51Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-5pcx5 plugin_name=systemd-logs
time="2021-06-10T17:26:51Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-md-0-6b59c4f65-5pcx5 already received"
time="2021-06-10T17:26:53Z" level=info msg="received aggregator request" client_cert= node=target-cluster-control-plane-8m52s plugin_name=systemd-logs
time="2021-06-10T17:26:53Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-control-plane-8m52s already received"
time="2021-06-10T17:26:54Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:27:08Z" level=info msg="received aggregator request" client_cert= node=target-cluster-md-0-6b59c4f65-cqpjz plugin_name=systemd-logs
time="2021-06-10T17:27:08Z" level=error msg="Result processing error (409): result systemd-logs/target-cluster-md-0-6b59c4f65-cqpjz already received"
time="2021-06-10T17:28:07Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:28:07Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:28:07Z" level=info msg="received aggregator request" client_cert= plugin_name=e2e
time="2021-06-10T17:28:07Z" level=info msg="Last update to annotations on exit"
time="2021-06-10T17:28:07Z" level=info msg="Shutting down aggregation server"
I0610 17:28:08.059387       1 request.go:557] Throttling request took 59.220672ms, request: GET:https://10.128.0.1:443/apis/storage.k8s.io/v1beta1?timeout=32s
I0610 17:28:08.091990       1 request.go:557] Throttling request took 91.830171ms, request: GET:https://10.128.0.1:443/apis/admissionregistration.k8s.io/v1?timeout=32s
I0610 17:28:08.125634       1 request.go:557] Throttling request took 125.381518ms, request: GET:https://10.128.0.1:443/apis/coordination.k8s.io/v1beta1?timeout=32s
I0610 17:28:08.159165       1 request.go:557] Throttling request took 158.869548ms, request: GET:https://10.128.0.1:443/apis/scheduling.k8s.io/v1beta1?timeout=32s
I0610 17:28:08.193980       1 request.go:557] Throttling request took 193.718634ms, request: GET:https://10.128.0.1:443/apis/coordination.k8s.io/v1?timeout=32s
I0610 17:28:08.225842       1 request.go:557] Throttling request took 225.510087ms, request: GET:https://10.128.0.1:443/apis/node.k8s.io/v1beta1?timeout=32s
time="2021-06-10T17:28:08Z" level=info msg="runtimeclasses not specified in non-nil Resources. Skipping runtimeclasses query."
time="2021-06-10T17:28:08Z" level=info msg="clusterissuers not specified in non-nil Resources. Skipping clusterissuers query."
time="2021-06-10T17:28:08Z" level=info msg="installations not specified in non-nil Resources. Skipping installations query."
time="2021-06-10T17:28:08Z" level=info msg="imagesets not specified in non-nil Resources. Skipping imagesets query."
time="2021-06-10T17:28:08Z" level=info msg="tigerastatuses not specified in non-nil Resources. Skipping tigerastatuses query."
time="2021-06-10T17:28:08Z" level=info msg="bgppeers not specified in non-nil Resources. Skipping bgppeers query."
time="2021-06-10T17:28:08Z" level=info msg="ippools not specified in non-nil Resources. Skipping ippools query."
time="2021-06-10T17:28:08Z" level=info msg="kubecontrollersconfigurations not specified in non-nil Resources. Skipping kubecontrollersconfigurations query."
time="2021-06-10T17:28:08Z" level=info msg="globalnetworkpolicies not specified in non-nil Resources. Skipping globalnetworkpolicies query."
time="2021-06-10T17:28:08Z" level=info msg="clusterinformations not specified in non-nil Resources. Skipping clusterinformations query."
time="2021-06-10T17:28:08Z" level=info msg="hostendpoints not specified in non-nil Resources. Skipping hostendpoints query."
time="2021-06-10T17:28:08Z" level=info msg="blockaffinities not specified in non-nil Resources. Skipping blockaffinities query."
time="2021-06-10T17:28:08Z" level=info msg="bgpconfigurations not specified in non-nil Resources. Skipping bgpconfigurations query."
time="2021-06-10T17:28:08Z" level=info msg="ipamconfigs not specified in non-nil Resources. Skipping ipamconfigs query."
time="2021-06-10T17:28:08Z" level=info msg="ipamhandles not specified in non-nil Resources. Skipping ipamhandles query."
time="2021-06-10T17:28:08Z" level=info msg="ipamblocks not specified in non-nil Resources. Skipping ipamblocks query."
time="2021-06-10T17:28:08Z" level=info msg="globalnetworksets not specified in non-nil Resources. Skipping globalnetworksets query."
time="2021-06-10T17:28:08Z" level=info msg="felixconfigurations not specified in non-nil Resources. Skipping felixconfigurations query."
time="2021-06-10T17:28:08Z" level=info msg="ingressclasses not specified in non-nil Resources. Skipping ingressclasses query."
time="2021-06-10T17:28:08Z" level=info msg="csinodes not specified in non-nil Resources. Skipping csinodes query."
time="2021-06-10T17:28:08Z" level=info msg="csidrivers not specified in non-nil Resources. Skipping csidrivers query."
time="2021-06-10T17:28:08Z" level=info msg="challenges not specified in non-nil Resources. Skipping challenges query."
time="2021-06-10T17:28:08Z" level=info msg="orders not specified in non-nil Resources. Skipping orders query."
time="2021-06-10T17:28:08Z" level=info msg="machines not specified in non-nil Resources. Skipping machines query."
time="2021-06-10T17:28:08Z" level=info msg="machinedeployments not specified in non-nil Resources. Skipping machinedeployments query."
time="2021-06-10T17:28:08Z" level=info msg="machinehealthchecks not specified in non-nil Resources. Skipping machinehealthchecks query."
time="2021-06-10T17:28:08Z" level=info msg="clusters not specified in non-nil Resources. Skipping clusters query."
time="2021-06-10T17:28:08Z" level=info msg="machinesets not specified in non-nil Resources. Skipping machinesets query."
time="2021-06-10T17:28:08Z" level=info msg="endpointslices not specified in non-nil Resources. Skipping endpointslices query."
time="2021-06-10T17:28:08Z" level=info msg="providers not specified in non-nil Resources. Skipping providers query."
time="2021-06-10T17:28:08Z" level=info msg="kubeadmcontrolplanes not specified in non-nil Resources. Skipping kubeadmcontrolplanes query."
time="2021-06-10T17:28:08Z" level=info msg="kubeadmconfigs not specified in non-nil Resources. Skipping kubeadmconfigs query."
time="2021-06-10T17:28:08Z" level=info msg="kubeadmconfigtemplates not specified in non-nil Resources. Skipping kubeadmconfigtemplates query."
time="2021-06-10T17:28:08Z" level=info msg="dockermachinetemplates not specified in non-nil Resources. Skipping dockermachinetemplates query."
time="2021-06-10T17:28:08Z" level=info msg="dockermachines not specified in non-nil Resources. Skipping dockermachines query."
time="2021-06-10T17:28:08Z" level=info msg="dockerclusters not specified in non-nil Resources. Skipping dockerclusters query."
time="2021-06-10T17:28:08Z" level=info msg="clusterresourcesets not specified in non-nil Resources. Skipping clusterresourcesets query."
time="2021-06-10T17:28:08Z" level=info msg="clusterresourcesetbindings not specified in non-nil Resources. Skipping clusterresourcesetbindings query."
time="2021-06-10T17:28:08Z" level=info msg="certificaterequests not specified in non-nil Resources. Skipping certificaterequests query."
time="2021-06-10T17:28:08Z" level=info msg="certificates not specified in non-nil Resources. Skipping certificates query."
time="2021-06-10T17:28:08Z" level=info msg="issuers not specified in non-nil Resources. Skipping issuers query."
time="2021-06-10T17:28:08Z" level=info msg="machinepools not specified in non-nil Resources. Skipping machinepools query."
time="2021-06-10T17:28:08Z" level=info msg="dockermachinepools not specified in non-nil Resources. Skipping dockermachinepools query."
time="2021-06-10T17:28:08Z" level=info msg="horizontalpodautoscalers not specified in non-nil Resources. Skipping horizontalpodautoscalers query."
time="2021-06-10T17:28:08Z" level=info msg="networksets not specified in non-nil Resources. Skipping networksets query."
time="2021-06-10T17:28:08Z" level=info msg="secrets not specified in non-nil Resources. Skipping secrets query."
time="2021-06-10T17:28:08Z" level=info msg="events not specified in non-nil Resources. Skipping events query."
time="2021-06-10T17:28:08Z" level=info msg="Collecting Node Configuration and Health..."
time="2021-06-10T17:28:08Z" level=info msg="Creating host results for target-cluster-control-plane-8m52s under /tmp/sonobuoy/09f39916-e662-4ef6-a1b7-7487f5105368/hosts/target-cluster-control-plane-8m52s\n"
time="2021-06-10T17:28:08Z" level=info msg="Creating host results for target-cluster-md-0-6b59c4f65-5pcx5 under /tmp/sonobuoy/09f39916-e662-4ef6-a1b7-7487f5105368/hosts/target-cluster-md-0-6b59c4f65-5pcx5\n"
time="2021-06-10T17:28:08Z" level=info msg="Creating host results for target-cluster-md-0-6b59c4f65-cqpjz under /tmp/sonobuoy/09f39916-e662-4ef6-a1b7-7487f5105368/hosts/target-cluster-md-0-6b59c4f65-cqpjz\n"
time="2021-06-10T17:28:08Z" level=info msg="Running cluster queries"
time="2021-06-10T17:28:09Z" level=info msg="Running ns query (airshipit)"
time="2021-06-10T17:28:09Z" level=info msg="Running ns query (calico-system)"
time="2021-06-10T17:28:09Z" level=info msg="Running ns query (capd-system)"
time="2021-06-10T17:28:10Z" level=info msg="Running ns query (capi-kubeadm-bootstrap-system)"
time="2021-06-10T17:28:10Z" level=info msg="Running ns query (capi-kubeadm-control-plane-system)"
time="2021-06-10T17:28:11Z" level=info msg="Running ns query (capi-system)"
time="2021-06-10T17:28:12Z" level=info msg="Running ns query (capi-webhook-system)"
time="2021-06-10T17:28:13Z" level=info msg="Running ns query (cert-manager)"
time="2021-06-10T17:28:13Z" level=info msg="Running ns query (default)"
time="2021-06-10T17:28:14Z" level=info msg="Running ns query (kube-node-lease)"
time="2021-06-10T17:28:15Z" level=info msg="Running ns query (kube-public)"
time="2021-06-10T17:28:16Z" level=info msg="Running ns query (kube-system)"
time="2021-06-10T17:28:16Z" level=info msg="Running ns query (sonobuoy)"
time="2021-06-10T17:28:17Z" level=info msg="Running ns query (tigera-operator)"
time="2021-06-10T17:28:18Z" level=info msg="Namespace airshipit Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace calico-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace capd-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace capi-kubeadm-bootstrap-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace capi-kubeadm-control-plane-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace capi-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace capi-webhook-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace cert-manager Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace default Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace kube-node-lease Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace kube-public Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace kube-system Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Namespace sonobuoy Matched=true"
time="2021-06-10T17:28:18Z" level=info msg="Namespace tigera-operator Matched=false"
time="2021-06-10T17:28:18Z" level=info msg="Collecting Pod Logs by namespace (sonobuoy)"
time="2021-06-10T17:28:18Z" level=info msg="Collecting Pod Logs by FieldSelectors []"
time="2021-06-10T17:28:18Z" level=info msg="Log lines after this point will not appear in the downloaded tarball."
time="2021-06-10T17:28:19Z" level=info msg="Results available at /tmp/sonobuoy/202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz"
time="2021-06-10T17:28:19Z" level=info msg="no-exit was specified, sonobuoy is now blocking"
++ sonobuoy retrieve --kubeconfig /home/rishabh/.airship/kubeconfig --context target-cluster
+ results=202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz
+ echo 'Results: 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz'
Results: 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz
+ sonobuoy results 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz
Plugin: e2e
Status: passed
Total: 5484
Passed: 305
Failed: 0
Skipped: 5179

Plugin: systemd-logs
Status: passed
Total: 3
Passed: 3
Failed: 0
Skipped: 0
+ ls -ltr /tmp/sonobuoy_snapshots/e2e
total 1268
-rw-rw-r-- 1 rishabh rishabh 1296959 Jun 10 10:28 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz

```
## Analyze Results

```
$  cd /tmp/sonobuoy_snapshots/e2e

$ ls

202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz

```
To check the tests that passed, execute the following command:

```
$ sonobuoy results 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz --plugin e2e --mode=detailed | jq 'select(.status=="passed")'  

```
To check the tests that were skipped, execute the following command:

```
$ sonobuoy results 202106101538_sonobuoy_09f39916-e662-4ef6-a1b7-7487f5105368.tar.gz --plugin e2e --mode=detailed | jq 'select(.status=="skipped")'  

```

<style>.markdown-body { max-width: 1250px; }</style>