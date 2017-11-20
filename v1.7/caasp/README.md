# SUSE Container as a Service Platform 2.0

## Introduction

This is instruction about how to run Kubernetes conformance tests on cluster SUSE CaaS Platform 2.0.

## Join SUSE Container as a Service Platform 2.0 user community

Please vsit our official SUSE CaaSP web page https://www.suse.com/products/caas-platform/

## Download SUSE Container as a Service Platform 2.0

We are offering the following images on x86_64:
 * DVD ISOs
 * KVM and Xen qcow2 images
 * OpenStack cloud image
 * Hyper-V image

SUSE Container as a Service Platform 2 can be downloaded from https://www.suse.com/download-linux/

## Install SUSE Container as a Service Platform 2.0

Please go through Deployment Guide
https://www.suse.com/documentation/suse-caasp-2/book_caasp_deployment/data/book_caasp_deployment.html

After installation when you will have working Kubernetes cluster, go to console and run

```
kubectl cluster-info
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl create -f -
kubectl logs -f -n sonobuoy sonobuoy

# wait for completion, signified by:
# ... master.go:67] no-exit was specified, sonobuoy is now blocking

kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl delete -f -
cd results
tar xfz *_sonobuoy_*.tar.gz
```
