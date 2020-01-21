# Alauda Cloud Enterprise (ACE) 

An Enterprise Platform-as-a-Service based on Kubernetes

## Install ACE

### Download the package

[Contact Alauda](mailto:hello@alauda.io) to download the ACE installation package.

### Run the following command to install the ACE:

```sh
$ tar xzvf -C /opt cpaas-20200109.tgz
$ cd /opt/cpaas
$ bash ./up-cpaas.sh \
     --network-interface=eth0 \
     --enabled-features=acp \
     --single-mode
$ kubectl captain create --version $(helm search | grep '^stable/alauda-cloud-enterprise ' | awk '{print $2}') --configmap=acp-config --namespace=cpaas-system alauda-cloud-enterprise --chart=stable/alauda-cloud-enterprise
```

## Run Conformance Test

1. On one of the worker node, install sonobuoy:

```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:

```sh
$ sonobuoy run
```

3. Watch logs:

```sh
$ sonobuoy logs
```

4. Check status:

```sh
$ sonobuoy status
```

5. Retrieve results:

Wait for around 50 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```sh
$ sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```
