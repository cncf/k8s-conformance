# Reproduce Sonobuoy Conformance Results for TrilioVault for Kubernetes

### Introduction to the Product

TrilioVault for Kubernetes (TVK) is a cloud-native, application-centric data protection and management platform that was designed from the ground up to support the scale, performance, and mobility requirements of Kubernetes container environments across any public or hybrid cloud environment.

## Prerequisites

The users need to install the product `TrilioVault for Kubernetes` with the latest version `3.1.0`.
Please follow the below documentation as per the Kubernetes distribution where you are installing the product.

## Install TrilioVault for Kubernetes:
- Follow the product installation [documentation](https://docs.trilio.io/kubernetes/getting-started-3/install-and-configure) for different Kubernetes distributions

## Verify the `TrilioVault for Kubernetes` Installation

- We have installed TVK on the `trilio-system` namespace so please update the namespace name according to your installation.
Verify if all the deployments are in the `RUNNING` state:

```command
root@bh-ubuntu2004-vm:/tvk/cncf/conformance# kubectl get deployment -n trilio-system
NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
k8s-triliovault-admission-webhook          1/1     1            1           12d
k8s-triliovault-control-plane              1/1     1            1           12d
k8s-triliovault-exporter                   1/1     1            1           12d
k8s-triliovault-ingress-nginx-controller   1/1     1            1           12d
k8s-triliovault-operator                   1/1     1            1           12d
k8s-triliovault-web                        1/1     1            1           12d
k8s-triliovault-web-backend                1/1     1            1           12d
```

- Verify if all the pods are in the `RUNNING` state

```command
root@bh-ubuntu2004-vm:/tvk/cncf/conformance# kubectl get pods -n trilio-system
NAME                                                        READY   STATUS      RESTARTS   AGE
k8s-triliovault-admission-webhook-77b46b96cd-9lksn          1/1     Running     0          167m
k8s-triliovault-control-plane-6fcbd76b99-8kgx9              2/2     Running     0          167m
k8s-triliovault-exporter-59c8c8dcdc-kwbxw                   1/1     Running     0          167m
k8s-triliovault-ingress-nginx-controller-76b7885d96-rr66q   1/1     Running     0          167m
k8s-triliovault-operator-66747bd477-pmljl                   1/1     Running     0          167m
k8s-triliovault-web-75bdc67d7d-l8t7z                        1/1     Running     0          167m
k8s-triliovault-web-backend-54b448979f-98rfz                1/1     Running     0          167m
```

## Step 1 — Install `Sonobuoy` using the installer

- Copy the `Sonobuoy` tar.gz file from the Github repository

```command
root@bh-desktop-vm:/conformance# wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
```

- Untar the .tar.gz file

```command
root@bh-desktop-vm:/conformance# tar -xvzf sonobuoy_0.56.10_linux_amd64.tar.gz
LICENSE
sonobuoy
```

- Copy the `sonobuoy` file to the `PATH` of your system

- Run the `sonobuoy` by following the command mentioned on the [Github page](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running).

```command
root@bh-ubuntu2004-vm:/tvk/cncf/conformance# sonobuoy run --mode=certified-conformance --namespace sonobuoy
INFO[0000] create request issued                         name=sonobuoy namespace= resource=namespaces
INFO[0000] create request issued                         name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
INFO[0000] create request issued                         name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy namespace=sonobuoy resource=pods
INFO[0000] create request issued                         name=sonobuoy-aggregator namespace=sonobuoy resource=services
```

- Check the status of the `sonobuoy` conformance test run.

```command
root@bh-ubuntu2004-vm:/tvk/cncf/conformance# sonobuoy status --show-all
         PLUGIN                                NODE     STATUS   RESULT                 PROGRESS
            e2e                              global    running   Passed:  8, Failed:  0
   systemd-logs   aks-agentpool-36496647-vmss000000   complete   
   systemd-logs   aks-agentpool-36496647-vmss000001   complete   
   systemd-logs   aks-agentpool-36496647-vmss000002   complete   

```

- Wait for around 60 minutes for the test run to complete and check the status again.

```command
root@bh-ubuntu2004-vm:/tvk/cncf/conformance# sonobuoy status --show-all
         PLUGIN                                NODE     STATUS   RESULT                 PROGRESS
            e2e                              global   complete   passed   Passed:368, Failed:  0
   systemd-logs   aks-agentpool-36496647-vmss000000   complete   passed
   systemd-logs   aks-agentpool-36496647-vmss000001   complete   passed
   systemd-logs   aks-agentpool-36496647-vmss000002   complete   passed
```

- Once all the tests run successfully, fetch the results

```command
root@bh-desktop-vm:/conformance# outfile=$(sonobuoy retrieve)
```

- After successfully fetching the results, run below commands to get the `e2e.log` and `junit_01.xml` files in the appropriate directories for the PR.

```command
root@bh-desktop-vm:/conformance# k8s_version=v1.26
root@bh-desktop-vm:/conformance# prod_name=triliovault-for-kubernetes

root@bh-desktop-vm:/conformance# mkdir results; tar xzf $outfile -C results

root@bh-desktop-vm:/conformance# mkdir -p ${k8s_version}/${prod_name}

root@bh-desktop-vm:/conformance# cp results/plugins/e2e/results/global/* ${k8s_version}/${prod_name}/
```

- Now, copy the e2e results sonobuoy .tar.gz file to the above created directory.

```command
root@bh-desktop-vm:/conformance# cp <date>_sonobuoy_<result_uid>.tar.gz ${k8s_version}/${prod_name}/
```

- At the end create the `PRODUCT.yaml` file with the all correct TVK product details and URLs.

```yaml
vendor: Trilio
name: TrilioVault for Kubernetes
version: v3.1.0
website_url: https://trilio.io/products/triliovault-kubernetes/
documentation_url: https://docs.trilio.io/kubernetes/getting-started-3/install-and-configure
product_logo_url: https://trilio.io/wp-content/uploads/2022/10/TRILIO_Logo_Green-Navy-pos_sRGB.svg
type: installer
description: 'TrilioVault for Kubernetes (TVK) is a cloud-native, application-centric data protection and management platform that was designed from the ground up to support the scale, performance, and mobility requirements of Kubernetes container environments across any public or hybrid cloud environment.'
contact_email_address: bhagirath.hapse@trilio.io
```

