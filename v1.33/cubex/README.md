# CubeX PaaS Solution

CubeX is a PaaS solution that supports easy and convenient building and deploying of container-based applications.

---

## Install CubeX v1.5
To configure CubeX, follow the steps below.

### 1. Preparing a Package
To download the installation package, please contact Seowon Information CubeX-Team. (Email: cubex@seowoninfo.com)

### 2. Install CubeX Cluster

#### STEP 1. Install Ansible
```
$ cubex-v1.5/ansible/setup.sh
$ source ~/.bashrc
```

#### STEP 2. Modify the Kubernetes Cluster Configuration
```
$ vi cubex-v1.5/config/cubex-env.yml
common:
  domain: seowoninfo.com
  max-pods: "200"
  cluster-cidr: "10.42.0.0/16"
  service-cidr: "10.43.0.0/16"
  service-node-port-range: "30000-32767"

master:
  hostnames:
    - cncf-cubex01
  ips:
    - 192.168.20.174

worker:
  hostnames:
    - cncf-cubex02
    - cncf-cubex03
  ips:
    - 192.168.20.175
    - 192.168.20.176
...
```

#### STEP 3. Execute the Install Command
```
$ ansible-playbook cubex-v1.5/playbooks/Install-cubex01.yml
$ ansible-playbook cubex-v1.5/playbooks/Install-cubex02.yml
```

#### STEP 4. Check the Kubernetes Cluster Status
```
$ kubectl get nodes
```

## Run Conformance Test
```
$ prod_name=cubex
$ k8s_version=v1.33

$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
$ tar zxvf sonobuoy_0.57.3_linux_amd64.tar.gz
$ sudo cp sonobuoy /usr/bin/sonobuoy
$ sonobuoy run --mode=certified-conformance --wait &
$ sonobuoy logs -f
$ sonobuoy status

$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results
$ mkdir -p ./${k8s_version}/${prod_name}
$ cp -r ./results/plugins/e2e/results/global/* ./${k8s_version}/${prod_name}/
```
