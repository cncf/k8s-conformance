# Accordion


## Install Accordion v2.15.0 (based on Kubernetes v1.35.5) and create a cluster

Use regular ansible playbook command to create a cluster.

If you need an installation package, please request it by e-mail.

```
$ vi group_vars/host.yml


# master isolation ( yes / no )
master_isolation: "yes"
master_host_name: "sun-vm-72"
master_ip: 10.20.201.72

master_mode "no"
```
```
$ vi etc/hosts
10.20.201.72 sun-vm-72
10.20.201.73 sun-vm-73
10.20.201.74 sun-vm-74
```

### Accordion 3 nodes cluster:

```
[root@sun-vm-72 accordion]# kubectl get nodes -o wide
NAME        STATUS   ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                      KERNEL-VERSION                 CONTAINER-RUNTIME
sun-vm-72   Ready    control-plane   3d23h   v1.35.5   10.20.201.72   <none>        Rocky Linux 9.5 (Blue Onyx)   5.14.0-503.14.1.el9_5.x86_64   containerd://2.1.5
sun-vm-73   Ready    worker          3d23h   v1.35.5   10.20.201.73   <none>        Rocky Linux 9.5 (Blue Onyx)   5.14.0-503.14.1.el9_5.x86_64   containerd://2.1.5
sun-vm-74   Ready    worker          3d23h   v1.35.5   10.20.201.74   <none>        Rocky Linux 9.5 (Blue Onyx)   5.14.0-503.14.1.el9_5.x86_64   containerd://2.1.5
```


## Run Conformance Tests
```
$ k8s_version=v1.35
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
version: v2.15.0
website_url: https://accordions.co.kr/kube_eng/
documentation_url: https://demo.accordions.co.kr/docs/
product_logo_url: https://training.accordions.co.kr/assets/images/mantech-accordion.svg
type: distribution
description: 'Accordion Kubernetes Platform help you to orchestrate containerized workloads for your DevOps practices & CI/CD pipelines, delivering enhanced developer productivity and accelerating time to market.'
EOF
```
