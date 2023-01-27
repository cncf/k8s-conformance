# Accordion


## Install Accordion v2.2.1 (based on Kubernetes v1.23.8) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/hostyml


# master isolation ( yes / no )
master_isolation: "yes"
master_host_name: "acc-master"
master_ip: 10.60.200.145

master_mode "no"
```
```
$ vi etc/hosts
10.60.200.145 acc-master
10.60.200.146 acc-node1
10.60.200.146 acc-node2
```

### Accordion 3 nodes cluster:

```
[root@acc-master1 accordion]# k get node -o wide
NAME          STATUS   ROLES           AGE     VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION           CONTAINER-RUNTIME
acc-master1   Ready    control-plane   7h35m   v1.24.9   10.60.200.145   <none>        CentOS Linux 7 (Core)   3.10.0-1160.el7.x86_64   containerd://1.6.8
acc-node1     Ready    worker          7h35m   v1.24.9   10.60.200.146   <none>        CentOS Linux 7 (Core)   3.10.0-1160.el7.x86_64   containerd://1.6.8
acc-node2     Ready    worker          7h35m   v1.24.9   10.60.200.147   <none>        CentOS Linux 7 (Core)   3.10.0-1160.el7.x86_64   containerd://1.6.8
```


## Run Conformance Tests
```
$ k8s_version=v1.24
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
version: v2.4.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://drive.google.com/file/d/13W74c6fC67P9Ahsl_mHHSLbFLl-KQ6zS/view?usp=share_link
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```
