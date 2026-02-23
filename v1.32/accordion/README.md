# Accordion


## Install Accordion v2.12.0 (based on Kubernetes v1.32.8) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/host.yml


# master isolation ( yes / no )
master_isolation: "no"
master_host_name: "acc-master"
master_ip: 10.60.200.72

master_mode "no"
```
```
$ vi etc/hosts
10.60.200.72 acc-master
10.60.200.73 acc-node1
10.60.200.74 acc-node2
```

### Accordion 3 nodes cluster:

```
[root@acc-master accordion]# k get node -o wide
NAME         STATUS   ROLES           AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                            KERNEL-VERSION                  CONTAINER-RUNTIME
acc-master   Ready    control-plane   3d7h   v1.32.8   10.60.200.72   <none>        Rocky Linux 8.10 (Green Obsidian)   4.18.0-553.30.1.el8_10.x86_64   containerd://1.7.26
acc-node1    Ready    worker          3d7h   v1.32.8   10.60.200.73   <none>        Rocky Linux 8.10 (Green Obsidian)   4.18.0-553.30.1.el8_10.x86_64   containerd://1.7.26
acc-node2    Ready    worker          3d7h   v1.32.8   10.60.200.74   <none>        Rocky Linux 8.10 (Green Obsidian)   4.18.0-553.30.1.el8_10.x86_64   containerd://1.7.26
```


## Run Conformance Tests
```
$ k8s_version=v1.32
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
version: v2.12.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://training.accordions.co.kr/assets/images/mantech-accordion.svg
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```
