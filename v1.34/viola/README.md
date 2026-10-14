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
| K8S Cluster(API Verion) | v1.34.2 |
| System OS | Ubuntu 24.04 LTS |
| Sonobuoy Version | v0.57.3 |
| Sonobuoy GitSHA | a988242e8bbded3ef4602eda48addcfac24a1a91 |
| GoVersion | go1.23.6 |
| Platform | linux/amd64 |

#
<br>

* Node list

```
root@pd-cncf-master-1:~# kubectl get nodes
NAME               STATUS   ROLES           AGE     VERSION
pd-cncf-master-1   Ready    control-plane   2d17h   v1.34.2
pd-cncf-master-2   Ready    control-plane   2d17h   v1.34.2
pd-cncf-master-3   Ready    control-plane   2d17h   v1.34.2
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
