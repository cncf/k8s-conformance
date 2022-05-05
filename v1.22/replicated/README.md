# Conformance tests for kURL Kubernetes installer

## Node Provisioning

To reproduce these results, create two instances on Google cloud with the following attributes:

- Operating System: Ubuntu 20.04 LTS
- Instance Size: N1-standard-8
- Disk: 200 GB SSD

## Install kURL on the Controller node with the following URL:

```
curl -sSL https://k8s.kurl.sh/kurl-conformance-1-22 | sudo bash
```

Join the second instance using the command from the prompt at completion of the script above.

```
To add worker nodes to this installation, run the following script on your other nodes:
    …
```

Reload bash shell:
```
bash -l
```
## Run Conformance Tests

Download and install the latest release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases) on the Controller node.

Start sonobuoy tests - these will take >1hr to complete:

```
./sonobuoy run --mode=certified-conformance
```

Check test status:

```
./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e    running                1
   systemd-logs   complete                1

Sonobuoy is still running. Runs can take up to 60 minutes.
```

The result should show passed
```
./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e   complete   passed       1
   systemd-logs   complete   passed       2

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Retrieve the results

```
./sonobuoy retrieve
```

Untar the results
```
tar -xvf 202007231853_sonobuoy_ccdf72c1-be7d-4ca3-bdb3-7d5a813f5746.tar.gz
```

Go to the results folder
```
cd plugins/e2e/results/global
```

Make sure the following 2 files are present

```
ls
e2e.log  junit_01.xml
```
