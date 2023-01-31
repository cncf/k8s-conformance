README.md (A script or human-readable description of how to reproduce
your results):

To reproduce these results, create two instances on Google cloud with the following attributes:

Operating System: Ubuntu 22.04 LTS
Instance Size: e2-standard-4
Disk: 200 GB SSD

Update system to latest version:

````
sudo apt -y update && sudo apt -y upgrade
````

Populate public & private IPs of both instances in /etc/hosts

````
127.0.0.1 localhost
$PUB_IP1  cncf-1
$PRIV_IP1   cncf-1
$PUB_IP2  cncf-2
$PRIV_IP2   cncf-2
````

Install Kubernetes v1.25 with:
```
curl -sSL https://kurl.sh/cncf-conformance-v1-25 | sudo bash
```

Join the second instance using the command from the prompt at completion of the script above.

```
To add worker nodes to this installation, run the following script on your other nodes:
    …
```

Reload your shell:
```
bash -l
```

Download and unpack the latest release of sonobuoy with:
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
tar -xvf sonobuoy_0.56.10_linux_amd64.tar.gz
```

Start sonobuoy tests - these will take >1hr to complete:

```
./sonobuoy run --mode=certified-conformance
```

Check test status:

```
./sonobuoy status                                                                                                                                                                                      laverya-cncf-main: Wed Oct  5 17:24:03 2022
         PLUGIN     STATUS   RESULT   COUNT                 PROGRESS
            e2e    running                1   Passed: 74, Failed:  0
   systemd-logs   complete                2

Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
```

The result should show passed
```
./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT                 PROGRESS
            e2e   complete   passed       1   Passed:362, Failed:  0
   systemd-logs   complete   passed       2

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Retrieve the results
```
./sonobuoy retrieve
202210051652_sonobuoy_30298e5a-581a-49dd-a21b-c3c6c0f4efb1.tar.gz
```

Untar the results
```
tar xvf 202210051652_sonobuoy_30298e5a-581a-49dd-a21b-c3c6c0f4efb1.tar.gz
```

Go to the results folder
```
cd plugins/e2e/results/global
```

Make sure the following 2 files are there
```
ls
e2e.log  junit_01.xml
```
