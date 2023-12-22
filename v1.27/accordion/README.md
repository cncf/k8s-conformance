# Accordion


## Install Accordion v2.7.0 (based on Kubernetes v1.27.6) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/host.yml


# master isolation ( yes / no )
master_isolation: "yes"
master_host_name: "acc-master"
master_ip: 10.60.200.85

master_mode "no"
```
```
$ vi etc/hosts
10.60.200.85 acc-master
10.60.200.86 acc-worker1
10.60.200.87 acc-worker2
```

### Accordion 3 nodes cluster:

```
[root@acc-master ~]# kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION          CONTAINER-RUNTIME
acc-master    Ready    control-plane   13d   v1.27.6   10.60.200.205   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64   containerd://1.6.24
acc-worker1   Ready    worker          13d   v1.27.6   10.60.200.206   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64   containerd://1.6.24
acc-worker2   Ready    worker          13d   v1.27.6   10.60.200.207   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64   containerd://1.6.24
```


## Run Conformance Tests
```
$ k8s_version=v1.27
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
version: v2.7.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://training.accordions.co.kr/assets/images/mantech-accordion.svg
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```

