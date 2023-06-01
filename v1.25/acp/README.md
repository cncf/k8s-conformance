# Alauda Container Platform (ACP)
A Cloud-Native Application Platform based on Kubernetes

## Install ACP

### Download the package

[Contact Alauda](mailto:hello@alauda.io) to download the ACP installation package.

### Run the following command to install the ACP:

```sh
$ tar xzvf -C /opt cpaas-installer.tgz
$ cd /opt/cpaas/installer
$ bash setup.sh
```

## Run Conformance Test

1. On one of the worker node, install sonobuoy:

```sh
$ SONOBUOY_VERSION=$(curl -L https://github.com/vmware-tanzu/sonobuoy/releases/latest/ 2>/dev/null | grep '<title>.*Release v' | sed 's/^.*Release v/v/g' | awk '{print $1}')
$ SONOBUOY_DOWNLOAD_URL=https://github.com/vmware-tanzu/sonobuoy/releases/download/${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION/v//}_linux_amd64.tar.gz
$ curl -L $SONOBUOY_DOWNLOAD_URL -o /tmp/dd
$ mkdir /tmp/sonobuoy ; tar zxvf /tmp/dd -C /tmp/sonobuoy
```

2. Run sonobuoy:

```sh
$ cd /tmp/sonobuoy
$ ./sonobuoy run --mode=certified-conformance
```

3. Watch logs:

```sh
$ ./sonobuoy logs
```

4. Check status:

```sh
$ ./sonobuoy status
```

5. Retrieve results:

Wait for around 50 minutes for the test to be finished, the status will show `complete` to indicate that the test has been finished, then run the following command to extract the test results.

```sh
$ ./sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```
