# SUSE Container as a Service Platform 3.0 Beta

## Introduction

This is instruction about how to run Kubernetes conformance tests on cluster SUSE CaaS Platform 3.0.

## Join SUSE Container as a Service Platform 3.0 user community

Please vsit our official SUSE CaaSP web page https://www.suse.com/betaprogram/caasp-beta/

## Download SUSE Container as a Service Platform 3.0 Beta

We are offering the following images on x86_64:
 * DVD ISOs
 * KVM and Xen qcow2 images
 * OpenStack cloud image
 * Hyper-V image

SUSE Container as a Service Platform 3 can be downloaded from https://www.suse.com/betaprogram/caasp-beta/#download

## Install SUSE Container as a Service Platform 3.0

Please go through Deployment Guide
https://www.suse.com/betaprogram/caasp-beta/#documentation

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
