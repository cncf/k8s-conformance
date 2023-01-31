README.md (A script or human-readable description of how to reproduce
your results):

To reproduce these results, create two instances on Google cloud with the following attributes:

Operating System: Ubuntu 20.04 LTS
Instance Size: N1-standard-8
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

Install Kubernetes v1.24 with:
```
curl https://kots.io/install | bash kubectl kots install kurl-conformance-1-24
```

Join the second instance using the command from the prompt at completion of the script above.

```
To add worker nodes to this installation, run the following script on your other nodes:
    …
```

Reload bash shell on Controller node:
```
bash -l
```

Download and install the latest release of sonobuoy.

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
202206071444_sonobuoy_b725e204-2621-4a11-a45b-b02667aa8b92.tar.gz
```

Untar the results
```
tar xvf 202206071444_sonobuoy_b725e204-2621-4a11-a45b-b02667aa8b92.tar.gz
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
