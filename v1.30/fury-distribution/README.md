# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.30.1 installed: https://github.com/sighupio/furyctl/releases/tag/v0.30.1 
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
  name: k8s-conformance-130
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.30.0
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: k8s-fury-1.30.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-130"
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
    nodeAllowedSshPublicKey: "{file:///Users/sighup/.ssh/id_rsa.pub}"
    nodePoolsLaunchKind: "launch_templates"
    nodePoolGlobalAmiType: "alinux2"
    apiServer:
      privateAccess: true
      publicAccess: true
      privateAccessCidrs: ['0.0.0.0/0']
      publicAccessCidrs: ['0.0.0.0/0']
    nodePools:
      - name: infra
        type: self-managed
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
        type: self-managed
        size:
          min: 3
          max: 3
        instance:
          type: t3.large
          spot: false
          volumeSize: 50
        labels:
          nodepool: ingress
          node.kubernetes.io/role: ingress
        tags:
          k8s.io/cluster-autoscaler/node-template/label/nodepool: "ingress"
          k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/role: "ingress"
      - name: worker
        type: self-managed
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
        baseDomain: internal.gamma.fury-demo.sighup.io
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
            name: "gamma.fury-demo.sighup.io"
            create: true
          private:
            name: "internal.gamma.fury-demo.sighup.io"
            create: true
      logging:
        type: loki
        minio:
          storageSize: 50Gi
        loki:
          tsdbStartDate: "2024-11-27"
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
            bucketName: kfd-conformance-velero-130
            region: eu-west-1
      auth:
        provider:
          type: none
      tracing: 
        type: none
```



#### Execute `furyctl` to create the cluster

```bash
-> furyctl apply --disable-analytics --outdir $PWD
INFO Downloading distribution...                  
INFO Validating configuration file...             
INFO Downloading dependencies...                  
INFO Validating dependencies...                   
INFO Ensure prerequisites are in place...         
INFO Running preflight checks                     
INFO Preflight checks completed successfully      
INFO Running preupgrade phase...                  
INFO Preupgrade phase completed successfully      
INFO Creating cluster...                          
INFO Creating infrastructure...                   
WARN Creating cloud resources, this could take a while... 
INFO Infrastructure created successfully          
INFO Creating Kubernetes Fury cluster...          
WARN Creating cloud resources, this could take a while... 
INFO Kubernetes cluster created successfully      
INFO Installing Kubernetes Fury Distribution...   
WARN Creating cloud resources, this could take a while... 
INFO Checking that the cluster is reachable...    
INFO Applying manifests...                        
INFO Kubernetes Fury Distribution installed successfully 
INFO Applying plugins...                          
INFO Skipping plugins phase as spec.plugins is not defined 
INFO Saving furyctl configuration file in the cluster... 
INFO Saving distribution configuration file in the cluster... 
INFO Kubernetes Fury cluster created successfully 
INFO Please remember to kill the VPN connection when you finish doing operations on the cluster 
INFO To connect to the cluster, set the path to your kubeconfig with 'export KUBECONFIG=/Users/sighup/furyctl/kubeconfig' or use the '--kubeconfig /Users/sighup/furyctl/kubeconfig' flag in following executions    
```

#### Verify that the cluster is up & running

```bash
kubectl get nodes -L node.kubernetes.io/role --kubeconfig kubeconfig
NAME                                          STATUS   ROLES    AGE   VERSION               ROLE
ip-10-150-13-101.eu-west-1.compute.internal   Ready    <none>   11m   v1.30.6-eks-94953ac   ingress
ip-10-150-15-25.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-16-88.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-21-205.eu-west-1.compute.internal   Ready    <none>   11m   v1.30.6-eks-94953ac   worker
ip-10-150-23-30.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-31-35.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   ingress
ip-10-150-34-59.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-36-249.eu-west-1.compute.internal   Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-39-57.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   worker
ip-10-150-45-46.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   ingress
ip-10-150-6-128.eu-west-1.compute.internal    Ready    <none>   11m   v1.30.6-eks-94953ac   infra
ip-10-150-9-67.eu-west-1.compute.internal     Ready    <none>   11m   v1.30.6-eks-94953ac   worker
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                               READY   STATUS      RESTARTS   AGE
calico-system     calico-kube-controllers-5db77b779c-xvqhz           1/1     Running     0          2m24s
calico-system     calico-node-2t8pq                                  1/1     Running     0          2m25s
calico-system     calico-node-4mc5x                                  1/1     Running     0          2m24s
calico-system     calico-node-b57pw                                  1/1     Running     0          2m25s
calico-system     calico-node-b7sxb                                  1/1     Running     0          2m25s
calico-system     calico-node-dldwb                                  1/1     Running     0          2m25s
calico-system     calico-node-dnw9l                                  1/1     Running     0          2m25s
calico-system     calico-node-dxnpn                                  1/1     Running     0          2m25s
calico-system     calico-node-k94kg                                  1/1     Running     0          2m25s
calico-system     calico-node-lcd8d                                  1/1     Running     0          2m25s
calico-system     calico-node-lxg5c                                  1/1     Running     0          2m25s
calico-system     calico-node-n7nlh                                  1/1     Running     0          2m25s
calico-system     calico-node-qz4v5                                  1/1     Running     0          2m25s
calico-system     calico-typha-869f7c88df-56j5q                      1/1     Running     0          2m19s
calico-system     calico-typha-869f7c88df-5tggh                      1/1     Running     0          2m25s
calico-system     calico-typha-869f7c88df-5wwvn                      1/1     Running     0          2m19s
calico-system     csi-node-driver-2jnsb                              2/2     Running     0          2m25s
calico-system     csi-node-driver-8h9dk                              2/2     Running     0          2m24s
calico-system     csi-node-driver-99nnp                              2/2     Running     0          2m24s
calico-system     csi-node-driver-9vvmv                              2/2     Running     0          2m24s
calico-system     csi-node-driver-b684b                              2/2     Running     0          2m24s
calico-system     csi-node-driver-d2mx4                              2/2     Running     0          2m24s
calico-system     csi-node-driver-gmpvp                              2/2     Running     0          2m24s
calico-system     csi-node-driver-mfnfs                              2/2     Running     0          2m25s
calico-system     csi-node-driver-ml9nx                              2/2     Running     0          2m25s
calico-system     csi-node-driver-sxlbm                              2/2     Running     0          2m25s
calico-system     csi-node-driver-tj4jp                              2/2     Running     0          2m25s
calico-system     csi-node-driver-w4lvb                              2/2     Running     0          2m24s
cert-manager      cert-manager-666d98b995-stgkl                      1/1     Running     0          3m12s
cert-manager      cert-manager-cainjector-6d5fff6785-vwwc5           1/1     Running     0          3m12s
cert-manager      cert-manager-webhook-f7d6854f7-jljs8               1/1     Running     0          3m12s
ingress-nginx     external-dns-private-7f6cfbb75f-xzq6n              1/1     Running     0          3m12s
ingress-nginx     external-dns-public-c7b859689-6znxm                1/1     Running     0          3m12s
ingress-nginx     forecastle-7c848b78f-k69fn                         1/1     Running     0          3m12s
ingress-nginx     ingress-nginx-controller-external-6r2kp            1/1     Running     0          3m10s
ingress-nginx     ingress-nginx-controller-external-qkhvf            1/1     Running     0          3m10s
ingress-nginx     ingress-nginx-controller-external-whqwg            1/1     Running     0          3m10s
ingress-nginx     ingress-nginx-controller-internal-7lbz9            1/1     Running     0          3m10s
ingress-nginx     ingress-nginx-controller-internal-jxvwp            1/1     Running     0          3m10s
ingress-nginx     ingress-nginx-controller-internal-t8rz8            1/1     Running     0          3m10s
kube-system       aws-load-balancer-controller-59844d764b-r5w9k      1/1     Running     0          3m12s
kube-system       aws-node-2tdz6                                     2/2     Running     0          10m
kube-system       aws-node-48xrb                                     2/2     Running     0          11m
kube-system       aws-node-b4g99                                     2/2     Running     0          10m
kube-system       aws-node-h6tds                                     2/2     Running     0          11m
kube-system       aws-node-hfcfn                                     2/2     Running     0          10m
kube-system       aws-node-kmsnn                                     2/2     Running     0          10m
kube-system       aws-node-ll2qp                                     2/2     Running     0          10m
kube-system       aws-node-ms65x                                     2/2     Running     0          11m
kube-system       aws-node-pvr4r                                     2/2     Running     0          11m
kube-system       aws-node-qrjnr                                     2/2     Running     0          11m
kube-system       aws-node-qv95g                                     2/2     Running     0          11m
kube-system       aws-node-rs4w8                                     2/2     Running     0          10m
kube-system       aws-node-termination-handler-4tpsv                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-5t4rh                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-956q8                 1/1     Running     0          3m9s
kube-system       aws-node-termination-handler-cbmb4                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-dh4qt                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-ksk2s                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-l5dk2                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-trln4                 1/1     Running     0          3m9s
kube-system       aws-node-termination-handler-trm9d                 1/1     Running     0          3m10s
kube-system       aws-node-termination-handler-vzqkp                 1/1     Running     0          3m9s
kube-system       aws-node-termination-handler-wpz9z                 1/1     Running     0          3m9s
kube-system       aws-node-termination-handler-z26ll                 1/1     Running     0          3m9s
kube-system       cluster-autoscaler-75ccf578d4-fgmh5                1/1     Running     0          3m12s
kube-system       coredns-56b94fc857-p2bdp                           1/1     Running     0          11m
kube-system       coredns-56b94fc857-vnztm                           1/1     Running     0          11m
kube-system       ebs-csi-controller-bd6f94987-kcr88                 6/6     Running     0          11m
kube-system       ebs-csi-controller-bd6f94987-wzg2j                 6/6     Running     0          11m
kube-system       ebs-csi-node-2hg84                                 3/3     Running     0          11m
kube-system       ebs-csi-node-2vrc7                                 3/3     Running     0          11m
kube-system       ebs-csi-node-bkvjn                                 3/3     Running     0          11m
kube-system       ebs-csi-node-fd92r                                 3/3     Running     0          11m
kube-system       ebs-csi-node-g7zqt                                 3/3     Running     0          11m
kube-system       ebs-csi-node-hthv2                                 3/3     Running     0          11m
kube-system       ebs-csi-node-mjhz4                                 3/3     Running     0          11m
kube-system       ebs-csi-node-pcddd                                 3/3     Running     0          11m
kube-system       ebs-csi-node-q6p2h                                 3/3     Running     0          11m
kube-system       ebs-csi-node-vhsp9                                 3/3     Running     0          11m
kube-system       ebs-csi-node-z7grb                                 3/3     Running     0          11m
kube-system       ebs-csi-node-zff72                                 3/3     Running     0          11m
kube-system       kube-proxy-27v8s                                   1/1     Running     0          12m
kube-system       kube-proxy-825kv                                   1/1     Running     0          12m
kube-system       kube-proxy-8b65b                                   1/1     Running     0          11m
kube-system       kube-proxy-94gqv                                   1/1     Running     0          12m
kube-system       kube-proxy-gb572                                   1/1     Running     0          12m
kube-system       kube-proxy-hd6tq                                   1/1     Running     0          12m
kube-system       kube-proxy-q7f6n                                   1/1     Running     0          12m
kube-system       kube-proxy-rg484                                   1/1     Running     0          12m
kube-system       kube-proxy-sjgwn                                   1/1     Running     0          11m
kube-system       kube-proxy-trpgw                                   1/1     Running     0          11m
kube-system       kube-proxy-wnd96                                   1/1     Running     0          12m
kube-system       kube-proxy-zdpzh                                   1/1     Running     0          11m
kube-system       snapshot-controller-77bbb65b9d-596rj               1/1     Running     0          3m12s
kube-system       velero-8775d5987-qlmzw                             1/1     Running     0          3m11s
logging           infra-fluentbit-6dxj2                              1/1     Running     0          2m17s
logging           infra-fluentbit-9t7h9                              1/1     Running     0          2m17s
logging           infra-fluentbit-csrkm                              1/1     Running     0          2m17s
logging           infra-fluentbit-gzmkw                              1/1     Running     0          2m17s
logging           infra-fluentbit-mq6gj                              1/1     Running     0          2m17s
logging           infra-fluentbit-nb9rq                              1/1     Running     0          2m17s
logging           infra-fluentbit-rlpm6                              1/1     Running     0          2m17s
logging           infra-fluentbit-s5kxm                              1/1     Running     0          2m17s
logging           infra-fluentbit-sfjlb                              1/1     Running     0          2m17s
logging           infra-fluentbit-strbb                              1/1     Running     0          2m17s
logging           infra-fluentbit-vr8dm                              1/1     Running     0          2m17s
logging           infra-fluentbit-vxzth                              1/1     Running     0          2m17s
logging           infra-fluentd-0                                    2/2     Running     0          2m42s
logging           infra-fluentd-1                                    2/2     Running     0          2m19s
logging           infra-fluentd-configcheck-e6788adb                 0/1     Completed   0          3m3s
logging           kubernetes-event-tailer-0                          1/1     Running     0          3m4s
logging           logging-operator-595cd4b46-4pvtx                   1/1     Running     0          3m11s
logging           loki-distributed-compactor-5dfb7cd798-7j9xd        1/1     Running     0          3m11s
logging           loki-distributed-distributor-7d5fd99695-kkmb5      1/1     Running     0          3m11s
logging           loki-distributed-gateway-7fbc9c8498-vnr99          1/1     Running     0          3m10s
logging           loki-distributed-ingester-0                        1/1     Running     0          3m11s
logging           loki-distributed-querier-0                         1/1     Running     0          3m11s
logging           loki-distributed-query-frontend-7c8b659d97-8tcvk   1/1     Running     0          3m10s
logging           minio-logging-0                                    1/1     Running     0          3m10s
logging           minio-logging-1                                    1/1     Running     0          3m10s
logging           minio-logging-2                                    1/1     Running     0          3m10s
logging           minio-logging-buckets-setup-4pnhr                  0/1     Completed   2          3m9s
logging           systemd-common-host-tailer-29vbk                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-5jhw6                   4/4     Running     0          3m5s
logging           systemd-common-host-tailer-c78pm                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-ccfzt                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-dkq95                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-jlgd6                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-phnn9                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-pl5fm                   4/4     Running     0          3m5s
logging           systemd-common-host-tailer-ptrrm                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-q4kzk                   4/4     Running     0          3m4s
logging           systemd-common-host-tailer-rc976                   4/4     Running     0          3m5s
logging           systemd-common-host-tailer-v49kx                   4/4     Running     0          3m4s
monitoring        alertmanager-main-0                                2/2     Running     0          2m16s
monitoring        blackbox-exporter-5dc8b5b7b5-gqz9x                 3/3     Running     0          3m10s
monitoring        grafana-68b8f454cd-knz7c                           3/3     Running     0          3m10s
monitoring        kube-proxy-metrics-7sg6n                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-9gwrn                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-jxgj5                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-pdj2m                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-pvj8n                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-rh99c                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-rkdm4                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-tb26r                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-tdcjj                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-wn4zw                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-xzrsl                           1/1     Running     0          3m10s
monitoring        kube-proxy-metrics-zqt6n                           1/1     Running     0          3m10s
monitoring        kube-state-metrics-55d9dd47b8-gqkpb                3/3     Running     0          3m9s
monitoring        node-exporter-27mkh                                2/2     Running     0          3m9s
monitoring        node-exporter-29h74                                2/2     Running     0          3m8s
monitoring        node-exporter-5jxxf                                2/2     Running     0          3m8s
monitoring        node-exporter-bcpk6                                2/2     Running     0          3m8s
monitoring        node-exporter-d77ph                                2/2     Running     0          3m8s
monitoring        node-exporter-hnj8m                                2/2     Running     0          3m8s
monitoring        node-exporter-jbvqg                                2/2     Running     0          3m9s
monitoring        node-exporter-m8g2s                                2/2     Running     0          3m8s
monitoring        node-exporter-m8hhf                                2/2     Running     0          3m9s
monitoring        node-exporter-mhf98                                2/2     Running     0          3m8s
monitoring        node-exporter-prn7l                                2/2     Running     0          3m8s
monitoring        node-exporter-vx5wc                                2/2     Running     0          3m9s
monitoring        prometheus-adapter-64cf9857-jfm7r                  1/1     Running     0          3m9s
monitoring        prometheus-k8s-0                                   2/2     Running     0          2m31s
monitoring        prometheus-operator-75845685bf-xgzs7               2/2     Running     0          3m9s
monitoring        x509-certificate-exporter-654589b659-vfg76         1/1     Running     0          3m9s
tigera-operator   tigera-operator-75fdcc44b-tnvpm                    1/1     Running     0          3m8s
```

## Run conformance tests

> Install requirements and run commands:

Dowload Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
