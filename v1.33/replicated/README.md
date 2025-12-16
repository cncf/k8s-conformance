README.md (A script or human-readable description of how to reproduce your results):

To reproduce these results, create two instances on Google Cloud Compute Engine with the following attributes:

- Operating System: `Ubuntu 24.04 LTS`
- Instance Size: `n1-standard-8`
- Disk: 200 GB SSD

Update system to latest version:

````
sudo apt -y update && sudo apt -y upgrade
````

Install dependencies:

```
sudo apt install -y containerd=1.7.27-0ubuntu1~24.04.1 conntrack
```

Populate public & private IPs of both instances in `/etc/hosts`:

````
127.0.0.1 localhost
$PUB_IP1  cncf-1
$PRIV_IP1   cncf-1
$PUB_IP2  cncf-2
$PRIV_IP2   cncf-2
````

Install Kubernetes v1.33 with kURL:
```
curl -sSL https://kurl.sh/kurl-conformance-1-33 | sudo bash
```

Join the second instance using the command from the prompt at completion of the script above:

```
To add worker nodes to this installation, run the following script on your other nodes:
    …
```

Download and unpack the latest release of sonobuoy with:
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
tar -xvf sonobuoy_0.57.3_linux_amd64.tar.gz
```

Start sonobuoy tests - these will take >1hr to complete:

```
./sonobuoy run --mode=certified-conformance
```

Check test status:

```
$ ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT                                PROGRESS
            e2e    running                1   Passed:  0, Failed:  0, Remaining:419
   systemd-logs   complete                2

Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
```

The tests should all pass:
```
$ ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT                                PROGRESS
            e2e   complete   passed       1   Passed:  0, Failed:  0, Remaining:419
   systemd-logs   complete   passed       2

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Retrieve the results:
```
$ ./sonobuoy retrieve
202508261812_sonobuoy_3ea8ecc3-90b4-425f-bd6e-2de37c4e7a75.tar.gz
```

Untar the results:
```
$ tar xzvf 202508261812_sonobuoy_3ea8ecc3-90b4-425f-bd6e-2de37c4e7a75.tar.gz
```

Go to the results folder:
```
$ cd plugins/e2e/results/global
```

Make sure the following two files are there:
```
$ ls
e2e.log  junit_01.xml
```
