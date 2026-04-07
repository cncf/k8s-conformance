# Sonobuoy Installation & Certified Conformance Test Guide

This guide walks you through installing Sonobuoy, running a conformance test, retrieving results, and cleaning up.

---

## 1. Download and Extract Sonobuoy (for x86_64 systems)

```bash
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
tar -xvzf sonobuoy_0.57.3_linux_amd64.tar.gz
chmod +x sonobuoy
```
---

##  2. Run the Certified Conformance Test

```bash
./sonobuoy run --mode=certified-conformance
```

> This command starts a Sonobuoy pod to perform Kubernetes conformance testing.

---

## 3. Check Test Status

```bash
./sonobuoy status
```

> Use this command to check if the test is still running or completed.

---

## 4. View Live Logs (Optional)

```bash
./sonobuoy logs
```

> View logs from the running Sonobuoy pod for debugging or monitoring purposes.

---

## 5. Retrieve Test Results

```bash
./sonobuoy retrieve
```

> This will copy a `.tar.gz` file containing all test results to your current directory.

---

## 6. Extract Results

```bash
mkdir ./results
tar xzf *.tar.gz -C ./results
```

> Extracts test result contents to the `./results` directory.  
> The required files for submission are located here:

- `./results/plugins/e2e/results/e2e.log`
- `./results/plugins/e2e/results/junit.xml`

---

## 7. Clean Up Sonobuoy Resources

```bash
./sonobuoy delete
```

> Deletes all Kubernetes resources created by Sonobuoy.

---

## (Optional) Move Binary for Global Access

```bash
sudo mv sonobuoy /usr/local/bin/
```

> Allows running `sonobuoy` from any path without `./` prefix.

---

## Additional Notes

- Always ensure that your cluster meets the [Kubernetes Conformance requirements](https://github.com/cncf/k8s-conformance).
- The test may take several minutes depending on cluster size and performance.



## How to install ansible based installation
```angular2html

## bastion machine need package installation
$ ./bastion-setup.sh

## ansible galaxy module installation
./run-ansible-galaxy-install.sh

## ansible inventory ini settings modification
$ vi inventory/inventory.ini

## docker installation and basic environment configuration
./run-playbook.sh bastion-prepare.yaml

## system utility installation
./run-playbook.sh openmaru-cop-system-setup.yaml

## time synchronization server installation
./run-playbook.sh bastion-chronyd.yaml

## dns server installation
./run-playbook.sh bastion-dns.yaml
./run-playbook.sh openmaru-cop-system-dns.yaml

## HAProxy installation
./run-playbook.sh bastion-haproxy.yaml

## NFS installation
./run-playbook.sh bastion-nfs.yaml

## OPENMARU COP cluster installation
./kubernetes-setup.sh


$ kubectl get node
NAME                      STATUS   ROLES                       AGE   VERSION
master1.cop.rnd01.local   Ready    control-plane,etcd,master   17d   v1.33.2+rke2r1
worker1.cop.rnd01.local   Ready    worker                      17d   v1.33.2+rke2r1
```