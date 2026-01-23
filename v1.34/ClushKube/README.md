# Conformance Test Procedure for Clush Kube
All of the tasks below will be done only on Bastion Server


## Installing Required Packages and Dependencies
-   **Generate and Copy SSH Keys**
```
ssh-keygen -t rsa

ssh-copy-id root@<master01>
ssh-copy-id root@<worker01>
ssh-copy-id root@<worker02>
```

-   **Install Python3 and Ansible**
```
apt update
apt install python3 iputils-ping ansible sshpass git
```

-   **Extract the Package File**
```
tar -xvzf clushkube_package.tar.gz
```


## Configuring and Running Clush Kube
-   **Cluster Configuration**
```
vi static_files/yml-ha/config.yml

# GLOBAL
kubernetes_version: <k8s-version>
contianerd_version: <containerd-version>
...
# HA
ethernet_name: <nic-name>
virtual_ip: <haproxy-vip>
virtual_ep: <haproxy-vip>:<haproxy-port>
```

-   **Run the Clush Kube Binary**
```
./clushkube-api -port 880
```

-   **Install a Cluster**
```
curl --location --request POST 'localhost:880/bizkube/api/v1/man/cluster/manage/control' \
--header 'Meta: {"uuid":"TEST:SESSION","client":0}' \
--header 'Content-Type: application/json' \
--data-raw '{
  "cluster": "cluster001",
  "type": "create",
  "version": "<k8s-version>",
  "mode": "debug",
  "host": {
    "control": {
      "name":"master01",
      "ip":"<master01-ip>"
    },
    "workers": [
      {
        "name":"worker01",
        "ip":"<worker01-ip>"
      },
      {
        "name":"worker02",
        "ip":"<worker02-ip>"
      }
    ]
  }
}'
```


## Running the Conformance Tests
**Download the Sonobuoy Binary Release**
```
URL: "https://github.com/vmware-tanzu/sonobuoy/releases"
```

**Extract the Downloaded Files**
```
tar -xvf <sonobouy.version>.tar.gz
```

**Start the Sonobuoy Test**
```
./sonobuoy run --mode=certified-conformance --wait
```

**Check the Progress of Sonobuoy (It Should End with 'fail: 0')**
```
./sonobouy status
```

**Save the Test Results to a File**
```
outfile=$(./sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

**Verify the Two Required Files in the Path Below**
```
cat ./results/plugins/e2e/results/global/e2e.log
cat ./results/plugins/e2e/results/global/junit_01.xml
```