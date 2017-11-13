# SUSE Container as a Service Platform 2.0

## Introduction

This is instruction about how to run Kubernetes conformance tests on cluster SUSE CaaS Platform 2.0.

(Keep in mind that SUSE CaaS Platform 2.0 is in beta and this content will be changed after final release)

## Join SUSE Container as a Service Platform 2.0 beta program

Please subscribe to our CaaSP-beta Mailing List http://lists.suse.com/mailman/listinfo/caasp-beta and
visit our dedicated CaaSP-beta web page https://www.suse.com/betaprogram/caasp-beta/

## Download SUSE Container as a Service Platform 2.0

We are offering the following images on x86_64 only:
 * DVD ISOs
 * XEN and KVM qcow2 images
 * OpenStack cloud image
 * Hyper-V image

SUSE Container as a Service Platform 2 can be downloaded from https://download.suse.com/Download?buildid=bCcogJ5BFZ8

## Install SUSE Container as a Service Platform 2.0

Please go through installation Quick Start 
https://www.suse.com/betaprogram/caasp-beta/doc-quickstart/

After installation when you will have working Kubernetes cluster, go to console and run

```
kubectl cluster-info
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl create -f -
kubectl logs -f -n sonobuoy sonobuoy

# wait for completion, signified by:
# ... master.go:67] no-exit was specified, sonobuoy is now blocking

kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
curl -L h://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl delete -f -
cd results
tar xfz *_sonobuoy_*.tar.gz
```
