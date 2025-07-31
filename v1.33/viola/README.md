# Kubernetes conformance tests on VIOLA
## VIOLA - [ START GUIDE ]
<br>

## **This guide is based on a closed network**
#### OKESTRO
#
<br>

## **System Information**


| System | Version |
| --- | --- |
| K8S Cluster | v1.33.3 |
| System OS | Ubuntu 22.04.3 LTS |

#
<br>

* Node list

```
root@viola-gs-master-1:# kubectl get node
NAME                STATUS   ROLES           AGE   VERSION
viola-gs-master-1   Ready    control-plane   41h   v1.33.3
viola-gs-master-2   Ready    control-plane   41h   v1.33.3
viola-gs-master-3   Ready    control-plane   41h   v1.33.3
viola-gs-worker-1   Ready    <none>          41h   v1.33.3
viola-gs-worker-2   Ready    <none>          41h   v1.33.3
viola-gs-worker-3   Ready    <none>          41h   v1.33.3
viola-gs-worker-4   Ready    <none>          41h   v1.33.3
```


# Run Conformance Tests

* Download a sonobuoy


```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz

tar -xvf sonobuoy_0.57.3_linux_amd64.tar.gz
```

* sonobuoy run

```
sonobuoy run --mode-certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v"
```

* Check the status

```
sonobuoy status
```

* To inspect the logs

```
sonobuoy logs
```

* Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
```
outfile=$(sonobuoy retrieve)
```

* This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
```
dir_name="./results"; mkdir "$dir_name" && tar xzf "$outfile" -C "$dir_name"
```

* To clean up Kubernetes objects created by Sonobuoy, run:
```
sonobuoy delete --all --wait
```
