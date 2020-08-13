# China Mobile CMIT PaaS

An Enterprise Platform-as-a-Service based on Kubernetes

## Install CMIT PaaS

### Download the package

Contact CMIT PaaS Dev Team to download the installation package.

### Run the following command to install the CMIT PaaS:
1. Install Docker by following https://docs.docker.com/engine/install;
2. Install CMIT PaaS
```sh
$ docker load < cmit-paas-20200715.tar
$ docker run -tid --name cmitpaas -p 1199:8088 --storage-opt size=70G \
         --restart always \
          -v /var/run/docker.sock:/var/run/docker.sock \
        cmitpaas:20200715
```

## Run Conformance Test

1. On one of the worker node, install sonobuoy:

```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

2. Run sonobuoy:

```sh
$ sonobuoy run --mode=certified-conformance
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

Wait for around 60 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```sh
$ sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```
