# DaoCloud Enterprise

DaoCloud Enterprise is a platform based on Kubernetes which developed by [DaoCloud](https://www.daocloud.io).

## How to Reproduce

First install DaoCloud Enterprise 3.1.4, which is based on Kubernetes 1.15.3. To install DaoCloud Enterprise, run the following commands on CentOS 7.5 System:
```
sudo su
curl -L https://dce.daocloud.io/DaoCloud_Enterprise/3.1.4/os-requirements  > ./os-requirements
chmod +x ./os-requirements
./os-requirements

bash -c "$(docker run -i --rm daocloud.io/daocloud/dce:3.1.4-31535 install)"
```
To add more nodes to the cluster, the user need log into DaoCloud Enterprise control panel and follow instructions under node management section.

After the installation, run ```docker exec -it `docker ps | grep dce-kube-controller | awk '{print$1}'` bash``` to enter the DaoCloud Enterprise Kubernetes controller container.

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy), and the standard way to run
these in your cluster is with `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`.

Watch Sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for
the line `no-exit was specified, sonobuoy is now blocking`.  At this point, use
`kubectl cp` to bring the results to your local machine, expand the tarball, and
retain the 3 files `plugins/e2e/results/{e2e.log,junit.xml,version.txt}`, which will
be included in your submission.
