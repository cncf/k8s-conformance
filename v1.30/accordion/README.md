# Accordion


## Install Accordion v2.10.0 (based on Kubernetes v1.30.6) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/hostyml


# master isolation ( yes / no )
master_isolation: "yes"
master_host_name: "acc-master"
master_ip: 10.60.200.88

master_mode "no"
```
```
$ vi etc/hosts
10.60.200.88 acc-master
10.60.200.89 acc-node1
10.60.200.90 acc-node2
```

### Accordion 3 nodes cluster:

```
[root@acc-master accordion]# k get node -o wide
NAME         STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                           KERNEL-VERSION                 CONTAINER-RUNTIME
acc-master   Ready    control-plane   3h50m   v1.30.6   10.60.200.88   <none>        Rocky Linux 8.8 (Green Obsidian)   4.18.0-477.10.1.el8_8.x86_64   containerd://1.7.19
acc-node1    Ready    worker          3h50m   v1.30.6   10.60.200.89   <none>        Rocky Linux 8.8 (Green Obsidian)   4.18.0-477.10.1.el8_8.x86_64   containerd://1.7.19
acc-node2    Ready    worker          3h50m   v1.30.6   10.60.200.90   <none>        Rocky Linux 8.8 (Green Obsidian)   4.18.0-477.10.1.el8_8.x86_64   containerd://1.7.19
```


## Run Conformance Tests
```
$ k8s_version=v1.30
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
version: v2.10.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://training.accordions.co.kr/assets/images/mantech-accordion.svg
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```
