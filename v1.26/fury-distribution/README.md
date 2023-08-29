# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.25.2 installed: https://github.com/sighupio/furyctl/releases/tag/v0.25.2 
- AWS requirments:
  - Administrator AWS Credentials.
  - An existing bucket on AWS to store terraform states

Also, requires the following environment variables:

```bash
#!/bin/bash

export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=THE_SECRET_KEY
export AWS_DEFAULT_REGION=YOUR_REGION
```

#### Prepare

Create the `furyctl.yaml` configuration file:

```yaml
---
apiVersion: kfd.sighup.io/v1alpha2
kind: EKSCluster
metadata:
  # The name of the cluster, will be also used as a prefix for all the other resources created on AWS
  name: k8s-conformance
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.26.0-rc.4
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: fury/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance"
  infrastructure:
    vpc:
      network:
        # This is the CIDR of the VPC
        cidr: 10.150.0.0/16
        subnetsCidrs:
          private:
            - 10.150.0.0/20
            - 10.150.16.0/20
            - 10.150.32.0/20
          public:
            - 10.150.48.0/24
            - 10.150.49.0/24
            - 10.150.50.0/24
    vpn:
      instances: 1
      port: 1194
      instanceType: t3.micro
      diskSize: 50
      operatorName: sighup
      dhParamsBits: 2048
      vpnClientsSubnetCidr: 172.16.0.0/16
      ssh:
        # Not yet supported
        publicKeys: []
        # The github user name list that will be used to get the ssh public key that will be added as authorized key to the operatorName user
        githubUsersName:
          - nutellinoit
        # The CIDR enabled in the security group that can access the bastions in SSH
        allowedFromCidrs:
          - 0.0.0.0/0
  kubernetes:
    nodeAllowedSshPublicKey: "{file:///Users/nutellinoit/.ssh/id_rsa.pub}"
    nodePoolsLaunchKind: "launch_templates"
    apiServer:
      privateAccess: true
      publicAccess: true
      privateAccessCidrs: ['0.0.0.0/0']
      publicAccessCidrs: ['0.0.0.0/0']
    nodePools:
      - name: infra
        size:
          min: 6
          max: 6
        instance:
          # The instance type
          type: t3.xlarge
          spot: false
          volumeSize: 50
        labels:
          nodepool: infra
          node.kubernetes.io/role: infra
        tags:
          k8s.io/cluster-autoscaler/node-template/label/nodepool: "infra"
          k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/role: "infra"
      - name: ingress
        size:
          min: 3
          max: 3
        instance:
          type: t3.medium
          spot: false
          volumeSize: 50
        labels:
          nodepool: ingress
          node.kubernetes.io/role: ingress
        tags:
          k8s.io/cluster-autoscaler/node-template/label/nodepool: "ingress"
          k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/role: "ingress"
      - name: worker
        size:
          min: 3
          max: 10
        instance:
          type: t3.large
          spot: false
          volumeSize: 50
        labels:
          nodepool: worker
          node.kubernetes.io/role: worker
        tags:
          k8s.io/cluster-autoscaler/node-template/label/nodepool: "worker"
          k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/role: "worker"
    awsAuth: {}
  distribution:
    common:
      # The node selector and tolerations to use to place the pods for all the KFD packages
      nodeSelector:
        node.kubernetes.io/role: infra
    modules:
      ingress:
        baseDomain: internal.zeta.fury-demo.sighup.io
        nginx:
          overrides:
            nodeSelector:
              node.kubernetes.io/role: ingress
          type: dual
          tls:
            provider: certManager
        certManager:
          clusterIssuer:
            name: letsencrypt-fury
            email: samuele@sighup.io
            type: dns01
        dns:
          public:
            name: "zeta.fury-demo.sighup.io"
            create: true
          private:
            name: "internal.zeta.fury-demo.sighup.io"
            create: true
      logging:
        type: loki
        minio:
          storageSize: 50Gi        
      monitoring:
        alertmanager:
          deadManSwitchWebhookUrl: ""
          slackWebhookUrl: ""
      policy:
        type: none
      dr:
        type: eks
        velero:
          eks:
            # This bucket will be created by furyctl
            bucketName: k8s-conformance-velero
            region: eu-west-1
      auth:
        provider:
          type: none
```



#### Execute `furyctl` to create the cluster

```bash
-> furyctl create cluster --disable-analytics --outdir $PWD
INFO Downloading distribution...                  
INFO Validating configuration file...             
INFO Downloading dependencies...                  
INFO Validating dependencies...                   
INFO Creating cluster...                          
INFO Creating infrastructure...                   
WARN Creating cloud resources, this could take a while... 
INFO Generating new VPN client certificate...     
INFO Creating Kubernetes Fury cluster...          
WARN Creating cloud resources, this could take a while... 
INFO Saving furyctl configuration file in the cluster... 
INFO Saving distribution configuration file in the cluster... 
INFO Installing Kubernetes Fury Distribution...   
WARN Creating cloud resources, this could take a while... 
INFO Checking that the cluster is reachable...    
INFO Applying manifests...      
INFO Saving furyctl configuration file in the cluster... 
INFO Saving distribution configuration file in the cluster... 
INFO Kubernetes Fury cluster created successfully 
INFO Please remember to kill the VPN connection when you finish doing operations on the cluster 
INFO To connect to the cluster, set the path to your kubeconfig with 'export KUBECONFIG=/Users/nutellinoit/furyctl/kubeconfig' or use the '--kubeconfig /Users/nutellinoit/furyctl/kubeconfig' flag in following executions         
```

#### Verify that the cluster is up & running

```bash
kubectl get nodes -L node.kubernetes.io/role --kubeconfig kubeconfig
NAME                                          STATUS   ROLES    AGE     VERSION               ROLE
ip-10-150-10-193.eu-west-1.compute.internal   Ready    <none>   4m8s    v1.26.6-eks-a5565ad   worker
ip-10-150-13-46.eu-west-1.compute.internal    Ready    <none>   3m59s   v1.26.6-eks-a5565ad   ingress
ip-10-150-15-183.eu-west-1.compute.internal   Ready    <none>   4m7s    v1.26.6-eks-a5565ad   infra
ip-10-150-17-174.eu-west-1.compute.internal   Ready    <none>   4m4s    v1.26.6-eks-a5565ad   infra
ip-10-150-17-27.eu-west-1.compute.internal    Ready    <none>   4m4s    v1.26.6-eks-a5565ad   ingress
ip-10-150-18-80.eu-west-1.compute.internal    Ready    <none>   4m4s    v1.26.6-eks-a5565ad   worker
ip-10-150-23-26.eu-west-1.compute.internal    Ready    <none>   4m2s    v1.26.6-eks-a5565ad   infra
ip-10-150-3-133.eu-west-1.compute.internal    Ready    <none>   4m3s    v1.26.6-eks-a5565ad   infra
ip-10-150-33-6.eu-west-1.compute.internal     Ready    <none>   4m5s    v1.26.6-eks-a5565ad   ingress
ip-10-150-36-130.eu-west-1.compute.internal   Ready    <none>   4m7s    v1.26.6-eks-a5565ad   worker
ip-10-150-37-27.eu-west-1.compute.internal    Ready    <none>   4m5s    v1.26.6-eks-a5565ad   infra
ip-10-150-42-36.eu-west-1.compute.internal    Ready    <none>   4m4s    v1.26.6-eks-a5565ad   infra
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                               READY   STATUS      RESTARTS       AGE
calico-system     calico-kube-controllers-7799b94cff-cdwld           1/1     Running     0              113s
calico-system     calico-node-2bcdr                                  1/1     Running     0              113s
calico-system     calico-node-7vwmb                                  1/1     Running     0              113s
calico-system     calico-node-87l89                                  1/1     Running     0              113s
calico-system     calico-node-8drx4                                  1/1     Running     0              113s
calico-system     calico-node-8jfwn                                  1/1     Running     0              113s
calico-system     calico-node-fk9sq                                  1/1     Running     0              113s
calico-system     calico-node-frqsx                                  1/1     Running     0              113s
calico-system     calico-node-j29xm                                  1/1     Running     0              113s
calico-system     calico-node-kx9hv                                  1/1     Running     0              113s
calico-system     calico-node-mn7ts                                  1/1     Running     0              113s
calico-system     calico-node-vwbgm                                  1/1     Running     0              113s
calico-system     calico-node-wbq2k                                  1/1     Running     0              114s
calico-system     calico-typha-65766875fb-dk7rh                      1/1     Running     0              105s
calico-system     calico-typha-65766875fb-jvtmj                      1/1     Running     0              114s
calico-system     calico-typha-65766875fb-n4tmr                      1/1     Running     0              105s
calico-system     csi-node-driver-48thq                              2/2     Running     0              112s
calico-system     csi-node-driver-5nwp5                              2/2     Running     0              113s
calico-system     csi-node-driver-7d9f2                              2/2     Running     0              112s
calico-system     csi-node-driver-7tv7c                              2/2     Running     0              112s
calico-system     csi-node-driver-d9tcr                              2/2     Running     0              113s
calico-system     csi-node-driver-j8rdz                              2/2     Running     0              113s
calico-system     csi-node-driver-ldmnj                              2/2     Running     0              113s
calico-system     csi-node-driver-qdk5k                              2/2     Running     0              113s
calico-system     csi-node-driver-rl5nh                              2/2     Running     0              113s
calico-system     csi-node-driver-rpkgg                              2/2     Running     0              113s
calico-system     csi-node-driver-rz6ms                              2/2     Running     0              112s
calico-system     csi-node-driver-sw565                              2/2     Running     0              112s
cert-manager      cert-manager-6674556d99-2c47l                      1/1     Running     0              2m17s
cert-manager      cert-manager-cainjector-b6866d96c-mczrx            1/1     Running     0              2m17s
cert-manager      cert-manager-webhook-5858989454-m6qbk              1/1     Running     0              2m17s
ingress-nginx     external-dns-private-75b5897dd8-2htbp              1/1     Running     0              2m17s
ingress-nginx     external-dns-public-66d4c45d44-7tm4m               1/1     Running     0              2m17s
ingress-nginx     forecastle-575486b647-xc6q8                        1/1     Running     0              2m16s
ingress-nginx     nginx-ingress-controller-external-ccmjp            1/1     Running     0              2m14s
ingress-nginx     nginx-ingress-controller-external-dldrm            1/1     Running     0              2m14s
ingress-nginx     nginx-ingress-controller-external-krt8x            1/1     Running     0              2m14s
ingress-nginx     nginx-ingress-controller-internal-7fvg9            1/1     Running     0              2m13s
ingress-nginx     nginx-ingress-controller-internal-k4q7q            1/1     Running     0              2m14s
ingress-nginx     nginx-ingress-controller-internal-kd6lw            1/1     Running     0              2m13s
kube-system       aws-load-balancer-controller-84f6747899-wcjvg      1/1     Running     0              2m16s
kube-system       aws-node-4756w                                     1/1     Running     0              4m31s
kube-system       aws-node-5jgsp                                     1/1     Running     0              4m39s
kube-system       aws-node-7zl94                                     1/1     Running     0              4m36s
kube-system       aws-node-8phlq                                     1/1     Running     0              4m36s
kube-system       aws-node-9p7t9                                     1/1     Running     0              4m35s
kube-system       aws-node-c7x69                                     1/1     Running     0              4m35s
kube-system       aws-node-cxdtb                                     1/1     Running     0              4m37s
kube-system       aws-node-l9m7t                                     1/1     Running     0              4m34s
kube-system       aws-node-nmm8s                                     1/1     Running     0              4m36s
kube-system       aws-node-qqhsx                                     1/1     Running     0              4m36s
kube-system       aws-node-smrt6                                     1/1     Running     0              4m40s
kube-system       aws-node-termination-handler-5c5db                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-cb2tv                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-ckrcn                 1/1     Running     0              2m12s
kube-system       aws-node-termination-handler-d4kds                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-dhqgf                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-dl2d8                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-jxncc                 1/1     Running     0              2m12s
kube-system       aws-node-termination-handler-ljxgz                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-p45ph                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-sjnfk                 1/1     Running     0              2m13s
kube-system       aws-node-termination-handler-wj8tv                 1/1     Running     0              2m12s
kube-system       aws-node-termination-handler-z2xsx                 1/1     Running     0              2m13s
kube-system       aws-node-vk7v5                                     1/1     Running     0              4m39s
kube-system       cluster-autoscaler-5b888576b9-g48qd                1/1     Running     0              2m16s
kube-system       coredns-f65767455-28hdz                            1/1     Running     0              5m17s
kube-system       coredns-f65767455-68dfh                            1/1     Running     0              5m17s
kube-system       ebs-csi-controller-6cc8848749-2kptd                6/6     Running     0              2m16s
kube-system       ebs-csi-controller-6cc8848749-spp24                6/6     Running     0              2m16s
kube-system       ebs-csi-node-242h7                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-4xvj8                                 3/3     Running     0              2m13s
kube-system       ebs-csi-node-7kkpx                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-brcnt                                 3/3     Running     0              2m13s
kube-system       ebs-csi-node-g4zm5                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-m7khn                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-nqnhc                                 3/3     Running     0              2m13s
kube-system       ebs-csi-node-q6x2q                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-sfrzz                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-tbptd                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-tmcqz                                 3/3     Running     0              2m12s
kube-system       ebs-csi-node-tzhqx                                 3/3     Running     0              2m12s
kube-system       kube-proxy-4dcmd                                   1/1     Running     0              4m31s
kube-system       kube-proxy-5xbx8                                   1/1     Running     0              4m35s
kube-system       kube-proxy-6n8pg                                   1/1     Running     0              4m37s
kube-system       kube-proxy-7j7ws                                   1/1     Running     0              4m34s
kube-system       kube-proxy-8nkzp                                   1/1     Running     0              4m36s
kube-system       kube-proxy-9f2pk                                   1/1     Running     0              4m36s
kube-system       kube-proxy-gvvzj                                   1/1     Running     0              4m36s
kube-system       kube-proxy-kfk4t                                   1/1     Running     0              4m40s
kube-system       kube-proxy-m2brp                                   1/1     Running     0              4m36s
kube-system       kube-proxy-m9n4n                                   1/1     Running     0              4m35s
kube-system       kube-proxy-vt9g4                                   1/1     Running     0              4m39s
kube-system       kube-proxy-xgkkz                                   1/1     Running     0              4m39s
kube-system       snapshot-controller-78df8ccd7-f6vtr                1/1     Running     0              2m16s
kube-system       velero-864f67c49c-zrmhq                            1/1     Running     0              2m16s
logging           infra-fluentbit-529hn                              1/1     Running     0              87s
logging           infra-fluentbit-gpd46                              1/1     Running     0              87s
logging           infra-fluentbit-j7jjz                              1/1     Running     0              87s
logging           infra-fluentbit-jmths                              1/1     Running     0              87s
logging           infra-fluentbit-kjcrt                              1/1     Running     0              87s
logging           infra-fluentbit-m7brf                              1/1     Running     0              87s
logging           infra-fluentbit-p8zkc                              1/1     Running     0              87s
logging           infra-fluentbit-pcjkn                              1/1     Running     0              87s
logging           infra-fluentbit-qtt52                              1/1     Running     0              87s
logging           infra-fluentbit-wzcts                              1/1     Running     0              87s
logging           infra-fluentbit-zgxnc                              1/1     Running     0              87s
logging           infra-fluentbit-zsbvf                              1/1     Running     0              87s
logging           infra-fluentd-0                                    2/2     Running     0              89s
logging           infra-fluentd-1                                    2/2     Running     0              71s
logging           infra-fluentd-configcheck-2165551f                 0/1     Completed   0              113s
logging           kubernetes-event-tailer-0                          1/1     Running     0              117s
logging           logging-operator-6686dc8667-zbw5p                  1/1     Running     0              2m15s
logging           loki-distributed-compactor-5f7559d884-m8jx7        1/1     Running     0              2m15s
logging           loki-distributed-distributor-5577d49f98-tl9gh      1/1     Running     0              2m15s
logging           loki-distributed-gateway-8688cc5dc6-l8ncr          1/1     Running     0              2m15s
logging           loki-distributed-ingester-0                        1/1     Running     0              2m15s
logging           loki-distributed-querier-0                         1/1     Running     0              2m15s
logging           loki-distributed-query-frontend-59d854554d-md5nl   1/1     Running     0              2m15s
logging           minio-logging-0                                    1/1     Running     0              2m15s
logging           minio-logging-1                                    1/1     Running     0              2m14s
logging           minio-logging-2                                    1/1     Running     0              2m14s
logging           minio-logging-buckets-setup-5zf89                  1/1     Running     3 (58s ago)    2m11s
logging           systemd-common-host-tailer-6nnlj                   4/4     Running     0              118s
logging           systemd-common-host-tailer-6zsxh                   4/4     Running     0              117s
logging           systemd-common-host-tailer-7ttvq                   4/4     Running     0              117s
logging           systemd-common-host-tailer-8bb2l                   4/4     Running     0              117s
logging           systemd-common-host-tailer-blxwm                   4/4     Running     0              117s
logging           systemd-common-host-tailer-fv74p                   4/4     Running     0              117s
logging           systemd-common-host-tailer-gccmm                   4/4     Running     0              117s
logging           systemd-common-host-tailer-h2gpw                   4/4     Running     0              118s
logging           systemd-common-host-tailer-k6lqb                   4/4     Running     0              118s
logging           systemd-common-host-tailer-mx7vj                   4/4     Running     0              117s
logging           systemd-common-host-tailer-rgpcn                   4/4     Running     0              117s
logging           systemd-common-host-tailer-v5nnp                   4/4     Running     0              117s
monitoring        alertmanager-main-0                                2/2     Running     1 (118s ago)   2m3s
monitoring        blackbox-exporter-8dd99677f-4zhtv                  3/3     Running     0              2m14s
monitoring        grafana-59f69d7f7b-8vzzm                           3/3     Running     0              2m14s
monitoring        kube-proxy-metrics-25mj5                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-26q7z                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-52k9v                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-5dlbf                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-6fbt7                           1/1     Running     0              2m12s
monitoring        kube-proxy-metrics-6jc86                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-7bmv6                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-7bzcq                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-7t49b                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-bv8gs                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-dflgm                           1/1     Running     0              2m11s
monitoring        kube-proxy-metrics-lfjfh                           1/1     Running     0              2m11s
monitoring        kube-state-metrics-d5f5bfd8f-mmpfk                 3/3     Running     0              2m14s
monitoring        node-exporter-2ppw4                                2/2     Running     0              2m11s
monitoring        node-exporter-5xdkp                                2/2     Running     0              2m11s
monitoring        node-exporter-8pk8g                                2/2     Running     0              2m11s
monitoring        node-exporter-8t5xj                                2/2     Running     0              2m11s
monitoring        node-exporter-k82hw                                2/2     Running     0              2m11s
monitoring        node-exporter-lct58                                2/2     Running     0              2m11s
monitoring        node-exporter-m6kqg                                2/2     Running     0              2m11s
monitoring        node-exporter-n8sq9                                2/2     Running     0              2m11s
monitoring        node-exporter-s4h8q                                2/2     Running     0              2m11s
monitoring        node-exporter-tx4v6                                2/2     Running     0              2m11s
monitoring        node-exporter-wclq4                                2/2     Running     0              2m11s
monitoring        node-exporter-z96cd                                2/2     Running     0              2m11s
monitoring        prometheus-adapter-844ff6c898-s8nvm                1/1     Running     0              2m14s
monitoring        prometheus-k8s-0                                   2/2     Running     0              2m2s
monitoring        prometheus-operator-86d9b4594d-95hcl               2/2     Running     0              2m14s
monitoring        x509-certificate-exporter-bc49cbc5d-np5h6          1/1     Running     0              2m13s
monitoring        x509-certificate-exporter-data-plane-cmfh9         1/1     Running     0              2m10s
monitoring        x509-certificate-exporter-data-plane-ft6qr         1/1     Running     0              2m10s
monitoring        x509-certificate-exporter-data-plane-gmdhp         1/1     Running     0              2m10s
monitoring        x509-certificate-exporter-data-plane-sftj9         1/1     Running     0              2m10s
monitoring        x509-certificate-exporter-data-plane-swxxk         1/1     Running     0              2m10s
monitoring        x509-certificate-exporter-data-plane-x6255         1/1     Running     0              2m10s
tigera-operator   tigera-operator-5f8c79d5bb-wmjwm                   1/1     Running     0              2m13s
```

## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.56.16](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.16))

And deploy a Sonobuoy pod to your cluster with:

```bash
curl -LOs https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_linux_amd64.tar.gz
tar -zxvf sonobuoy_0.56.16_linux_amd64.tar.gz
export KUBECONFIG=kubeconfig
./sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
./sonobuoy status
```

Retrieve the results

```bash
outfile=$(./sonobuoy retrieve)
```

Extract files:

```bash
mkdir ./results; tar xzf $outfile -C ./results
```

And get the files under: `results/plugins/e2e/results/global/{e2e.log,junit_01.xml}`
