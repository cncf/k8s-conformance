# Reproduce Sonobuoy Conformance Results for TrilioVault for Kubernetes

### Introduction to the Product

TrilioVault for Kubernetes (TVK) is a cloud-native, application-centric data protection and management platform that was designed from the ground up to support the scale, performance, and mobility requirements of Kubernetes container environments across any public or hybrid cloud environment.

## Prerequisites

The users need to install the product `TrilioVault for Kubernetes` with the latest version `2.10.6`.
Please follow the below documentation as per the Kubernetes distribution where you are installing the product.

## Install TrilioVault for Kubernetes:
- Follow the product installation [documentation](https://docs.trilio.io/kubernetes/getting-started-3/getting-started/install-and-configure) for different Kubernetes distributions

## Verify the `TrilioVault for Kubernetes` Installation

- We have installed TVK on the TVK namespace so please update the namespace name according to your installation.
Verify if all the deployments are in the `RUNNING` state:

```command
root@bh-desktop-vm:/conformance# kubectl get deployment -n tvk
NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
k8s-triliovault-admission-webhook          1/1     1            1           5m36s
k8s-triliovault-control-plane              1/1     1            1           5m37s
k8s-triliovault-exporter                   1/1     1            1           5m36s
k8s-triliovault-ingress-nginx-controller   1/1     1            1           5m36s
k8s-triliovault-operator                   1/1     1            1           6m56s
k8s-triliovault-web                        1/1     1            1           5m36s
k8s-triliovault-web-backend                1/1     1            1           5m36s
```

- Verify if all the pods are in the `RUNNING` state

```command
root@bh-desktop-vm:/conformance# kubectl get pods -n tvk
NAME                                                        READY   STATUS    RESTARTS   AGE
k8s-triliovault-admission-webhook-5bb8847cdb-jn8vs          1/1     Running   0          4m27s
k8s-triliovault-control-plane-64bdccf9b5-zx4w8              2/2     Running   0          4m27s
k8s-triliovault-exporter-65c7cbd48b-k5bvh                   1/1     Running   0          4m27s
k8s-triliovault-ingress-nginx-controller-677987fbc6-g545h   1/1     Running   0          4m27s
k8s-triliovault-operator-5bcf4c6cfb-z47rq                   1/1     Running   0          5m47s
k8s-triliovault-web-5cf65cf859-fwd4q                        1/1     Running   0          4m27s
k8s-triliovault-web-backend-7484df4484-lf75w                1/1     Running   0          4m27s
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
root@bh-desktop-vm:/conformance# sonobuoy run --mode=certified-conformance --namespace sonobuoy
sonobuoy run --mode=certified-conformance
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
root@bh-desktop-vm:/conformance# sonobuoy status --show-all
PLUGIN                                             NODE     STATUS   RESULT                                PROGRESS
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-14g6   complete
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-gsrd   complete
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-rc7h   complete
            e2e                                           global    running            Passed:  5, Failed:  0, Remaining:351
```

- Wait for around 60 minutes for the test run to complete and check the status again.

```command
root@bh-desktop-vm:/conformance# sonobuoy status --show-all
         PLUGIN                                             NODE     STATUS   RESULT                                PROGRESS
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-14g6   complete   passed
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-gsrd   complete   passed
   systemd-logs   gke-bh-gke-sandbox1-default-pool-f310b35e-rc7h   complete   passed
            e2e                                           global   complete   passed   Passed:356, Failed:  0, Remaining:  0
```

- Once all the tests run successfully, fetch the results

```command
root@bh-desktop-vm:/conformance# outfile=$(sonobuoy retrieve)
```

- After successfully fetching the results, run below commands to get the `e2e.log` and `junit_01.xml` files in the appropriate directories for the PR.

```command
root@bh-desktop-vm:/conformance# k8s_version=v1.24
root@bh-desktop-vm:/conformance# prod_name=triliovault-for-kubernetes

root@bh-desktop-vm:/conformance# mkdir results; tar xzf $outfile -C results

root@bh-desktop-vm:/conformance# mkdir -p ${k8s_version}/${prod_name}

root@bh-desktop-vm:/conformance# cp results/plugins/e2e/results/global/* ${k8s_version}/${prod_name}/
```

- At the end create the `PRODUCT.yaml` file with the all correct TVK product details and URLs.

```yaml
vendor: Trilio
name: TrilioVault for Kubernetes
version: v2.10.6
website_url: https://trilio.io/products/triliovault-kubernetes/
documentation_url: https://docs.trilio.io/kubernetes/getting-started-3/getting-started/install-and-configure
product_logo_url: https://trilio.io/wp-content/uploads/2022/10/TRILIO_Logo_Green-Navy-pos_sRGB.svg
type: installer
description: 'TrilioVault for Kubernetes (TVK) is a cloud-native, application-centric data protection and management platform that was designed from the ground up to support the scale, performance, and mobility requirements of Kubernetes container environments across any public or hybrid cloud environment.'
```

