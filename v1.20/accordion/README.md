# Accordion


## Install Accordion v2.0 (based on Kubernetes v1.20.8) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/hostyml
master_isolation "no"
master_host_name acc-master 
master_ip 10.20.200.161
master_mode "yes"
master2_ip 10.20.200.162
master3_ip 10.20.200.163
master2_hostname acc-master2 
master3_hostname acc-master3 
L4_mode "haproxy"
haproxy_port 8443
keep_vip 10.20.200.160 
keep_interface ens192 
```
```
$ vi etc/hosts
10.20.200.161 acc-master
10.20.200.164 acc-node1
10.20.200.165 acc-node2
10.20.200.162 acc-master2
10.20.200.163 acc-master3
```

### Accordion 5 nodes cluster:

```
root@acc-master:~# kubectl get nodes -o wide
NAME          STATUS   ROLES                  AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
acc-master    Ready    control-plane,master   33d   v1.20.8   10.20.200.161   <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   containerd://1.5.2
acc-master2   Ready    control-plane,master   33d   v1.20.8   10.20.200.162   <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   containerd://1.5.2
acc-master3   Ready    control-plane,master   33d   v1.20.8   10.20.200.163   <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   containerd://1.5.2
acc-node1     Ready    worker                 33d   v1.20.8   10.20.200.164   <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   containerd://1.5.2
acc-node2     Ready    worker                 33d   v1.20.8   10.20.200.165   <none>        Ubuntu 20.04.1 LTS   5.4.0-42-generic   containerd://1.5.2
```


## Run Conformance Tests
```
$ k8s_version=v1.20
$ prod_name=accordion

$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance --wait
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results

$ mkdir -p ./${k8s_version}/${prod_name}
$ cp ./results/plugins/e2e/results/global/* ./${k8s_version}/${prod_name}/

$ cat << EOF > ./${k8s_version}/${prod_name}/PRODUCT.yaml
vendor: Mantech
name: Accordion
version: v2.0.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://drive.google.com/file/d/1HR9tMR01rlztd__S7kMcREo3aZDcguCq/view?usp=sharing
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```
