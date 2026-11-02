# Centron Managed Kubernetes Service 

## Prerequisites

You first need to create an Account for the Centron CCloud.

## Provision a Cluster

- Login to Centron CCloud Web Interface
- Navigate to Manage -> Kubernetes
- Click on "Cluster erstellen"
- Choose the desired Kubernetes Version
- Fill in network configurations and node pool offerings, or leave on default 
- Click on "Jetzt erstellen & kaufen" to order and provision your cluster
- In the list of your kubernetes clusters, click on your newly created Cluster.
- Top right, click on "Aktionen" -> "Config-Datei herunterladen" to download your Kubeconfig

## Run conformance tests

Follow the k8s-conformance [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run conformance tests.

The output here was obtained with Sonobuoy v0.57.5 running on a Kubernetes v1.35.9 cluster.
