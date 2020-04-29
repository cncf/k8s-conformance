![Rafay_Logo](Rafay_Logo.png)

# Rafay Certification Results

The Rafay system manages the distribution and scaling of containerized
microservices across one or many Kubernetes clusters. It supports intent-based
placement to simplify day-2 operations for distributed applications. 

You can use your own private clusters or a Rafay sandbox of clusters. To
reproduce the certification results you will need kubectl access (and more), so
you must use a private cluster (not the sandbox, which are Rafay-managed).
Instructions for joining a cluster to the Rafay system is in the [product
documentation](https://app.rafay.dev/docs/cluster-deploy/) (requires login
access, but you may create a free account).

## Steps to Reproduce

``` shell
ssh # to a K8S master node in your Rafay cluster
```

Install and run [sonobuoy](https://github.com/heptio/sonobuoy) as instructed on
[k8s-conformance](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

Submit the results.
