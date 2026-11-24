# Kubernetes Conformance tests on VIOLA
## VIOLA - [ START GUIDE ]
<br>

## **This guide is based on a closed network**
#### OKESTRO
#
<br>

## **System Information**


| System | Version |
| --- | --- |
| K8S Cluster(API Verion) | v1.36.4 |
| System OS | Ubuntu 24.04 LTS |
| Sonobuoy Version | v0.57.5 |
| Sonobuoy GitSHA | 310c51d9874a4d10d021ec8a19f8b42292ec0bfc |
| GoVersion | go1.26.4 |
| Platform | linux/amd64 |

#
<br>

* Node list

```
NAME                 STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE           KERNEL-VERSION             CONTAINER-RUNTIME
cncf-test-master-1   Ready    control-plane   12d   v1.36.4   10.255.52.186   <none>        Ubuntu 24.04 LTS   6.8.0-40-generic (amd64)   containerd://2.3.5
cncf-test-master-2   Ready    control-plane   12d   v1.36.4   10.255.52.113   <none>        Ubuntu 24.04 LTS   6.8.0-40-generic (amd64)   containerd://2.3.5
cncf-test-master-3   Ready    control-plane   12d   v1.36.4   10.255.52.203   <none>        Ubuntu 24.04 LTS   6.8.0-40-generic (amd64)   containerd://2.3.5
```


# Run Conformance Tests

* Download a sonobuoy


```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz

tar -xvf sonobuoy_0.57.5_linux_amd64.tar.gz
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
