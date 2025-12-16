# Conformance tests for SIGHUP Distribution

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.32.5 installed: https://github.com/sighupio/furyctl/releases/tag/v0.32.5
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
  name: k8s-conformance-132
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.32.0
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: k8s-fury-1.32.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-132"
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
          spot: true
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
          spot: true
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
          spot: true
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
            bucketName: kfd-conformance-velero-132
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
INFO Compatibility patches applied for v1.32.0    
INFO Validating configuration file...             
INFO Downloading dependencies...                  
INFO Validating dependencies...                   
INFO Ensure prerequisites are in place...         
INFO Running preflight checks...                  
INFO Updating kubeconfig...                       
INFO Checking that the cluster is reachable...    
INFO Preflight checks completed successfully      
INFO Running preupgrade phase...                  
INFO Preupgrade phase completed successfully      
INFO Creating cluster...                          
INFO Creating infrastructure...                   
WARN Creating cloud resources, this could take a while... 
INFO Infrastructure created successfully          
INFO Configuring SIGHUP Distribution cluster...   
WARN Creating cloud resources, this could take a while... 
INFO Kubernetes cluster created successfully      
INFO Installing SIGHUP Distribution...            
WARN Creating cloud resources, this could take a while... 
INFO Checking that the cluster is reachable...    
INFO Applying Distribution modules...             
INFO SIGHUP Distribution installed successfully   
INFO Applying plugins...                          
INFO Skipping plugins phase as spec.plugins is not defined 
INFO Saving furyctl configuration file in the cluster... 
INFO Saving distribution configuration file in the cluster... 
INFO SIGHUP Distribution cluster created successfully 
INFO Please remember to kill the VPN connection when you finish doing operations on the cluster
INFO To connect to the cluster, set the path to your kubeconfig with 'export KUBECONFIG=/home/sighup/eks/kubeconfig' or use the '--kubeconfig /home/sighup/eks/kubeconfig' flag in following executions   
```

#### Verify that the cluster is up & running

```bash
kubectl get nodes -L node.kubernetes.io/role --kubeconfig kubeconfig
NAME                                          STATUS   ROLES    AGE   VERSION               ROLE
ip-10-150-0-101.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   infra
ip-10-150-12-231.eu-west-1.compute.internal   Ready    <none>   70m   v1.32.3-eks-473151a   worker
ip-10-150-2-88.eu-west-1.compute.internal     Ready    <none>   70m   v1.32.3-eks-473151a   ingress
ip-10-150-21-101.eu-west-1.compute.internal   Ready    <none>   70m   v1.32.3-eks-473151a   infra
ip-10-150-23-10.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   ingress
ip-10-150-25-21.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   worker
ip-10-150-25-58.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   infra
ip-10-150-32-162.eu-west-1.compute.internal   Ready    <none>   70m   v1.32.3-eks-473151a   infra
ip-10-150-38-96.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   ingress
ip-10-150-39-207.eu-west-1.compute.internal   Ready    <none>   70m   v1.32.3-eks-473151a   infra
ip-10-150-47-132.eu-west-1.compute.internal   Ready    <none>   70m   v1.32.3-eks-473151a   worker
ip-10-150-5-116.eu-west-1.compute.internal    Ready    <none>   70m   v1.32.3-eks-473151a   infra
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                              READY   STATUS      RESTARTS   AGE
calico-system     calico-kube-controllers-75bcd575d8-642f4            1/1     Running     0             65m
calico-system     calico-node-2rnqj                                   1/1     Running     0             65m
calico-system     calico-node-7djx7                                   1/1     Running     0             65m
calico-system     calico-node-99hgw                                   1/1     Running     0             65m
calico-system     calico-node-dsbcg                                   1/1     Running     0             65m
calico-system     calico-node-jq7k2                                   1/1     Running     0             65m
calico-system     calico-node-k8s7k                                   1/1     Running     0             65m
calico-system     calico-node-ktgfh                                   1/1     Running     0             65m
calico-system     calico-node-m7vg9                                   1/1     Running     0             65m
calico-system     calico-node-mwrvd                                   1/1     Running     0             65m
calico-system     calico-node-pjsvj                                   1/1     Running     0             65m
calico-system     calico-node-pnx6s                                   1/1     Running     0             65m
calico-system     calico-node-szvss                                   1/1     Running     0             65m
calico-system     calico-typha-74864b74f9-5xm5x                       1/1     Running     0             65m
calico-system     calico-typha-74864b74f9-jrzmr                       1/1     Running     0             65m
calico-system     calico-typha-74864b74f9-nghbt                       1/1     Running     0             65m
calico-system     csi-node-driver-5fp9q                               2/2     Running     0             65m
calico-system     csi-node-driver-9k7ql                               2/2     Running     0             65m
calico-system     csi-node-driver-gxt77                               2/2     Running     0             65m
calico-system     csi-node-driver-gzl77                               2/2     Running     0             65m
calico-system     csi-node-driver-kz2fl                               2/2     Running     0             65m
calico-system     csi-node-driver-m4g8m                               2/2     Running     0             65m
calico-system     csi-node-driver-njfn7                               2/2     Running     0             65m
calico-system     csi-node-driver-nrv55                               2/2     Running     0             65m
calico-system     csi-node-driver-pr6mp                               2/2     Running     0             65m
calico-system     csi-node-driver-qt5f4                               2/2     Running     0             65m
calico-system     csi-node-driver-ssjnr                               2/2     Running     0             65m
calico-system     csi-node-driver-tq4vh                               2/2     Running     0             65m
cert-manager      cert-manager-66468d7646-fmsnt                       1/1     Running     0             65m
cert-manager      cert-manager-cainjector-849fd5d8f8-tgjbd            1/1     Running     0             65m
cert-manager      cert-manager-webhook-5cfb89f7d4-f2j6w               1/1     Running     0             65m
ingress-nginx     external-dns-private-85cdc64844-9p7f7               1/1     Running     0             65m
ingress-nginx     external-dns-public-cd655b45c-dq24t                 1/1     Running     0             65m
ingress-nginx     forecastle-595b94fd46-ccwr9                         1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-external-2jlj2             1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-external-g8vxm             1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-external-s4p46             1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-internal-9hdz4             1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-internal-cnbwk             1/1     Running     0             65m
ingress-nginx     ingress-nginx-controller-internal-rrnj6             1/1     Running     0             65m
kube-system       aws-load-balancer-controller-69c8777d4b-7kd5h       1/1     Running     0             65m
kube-system       aws-node-5jpcv                                      2/2     Running     0             67m
kube-system       aws-node-66kvn                                      2/2     Running     0             67m
kube-system       aws-node-862d5                                      2/2     Running     0             68m
kube-system       aws-node-8dk4q                                      2/2     Running     0             68m
kube-system       aws-node-9rgrp                                      2/2     Running     0             67m
kube-system       aws-node-fpx4z                                      2/2     Running     0             68m
kube-system       aws-node-g6m4k                                      2/2     Running     0             68m
kube-system       aws-node-kqsmw                                      2/2     Running     0             67m
kube-system       aws-node-n7225                                      2/2     Running     0             67m
kube-system       aws-node-srt8g                                      2/2     Running     0             67m
kube-system       aws-node-termination-handler-45k9g                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-8whvs                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-c2j7l                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-gc2l5                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-glq2k                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-hp5jk                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-jnqfs                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-k6s97                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-lnbhj                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-qwlm5                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-rldrf                  1/1     Running     0             65m
kube-system       aws-node-termination-handler-ztw5w                  1/1     Running     0             65m
kube-system       aws-node-w25s5                                      2/2     Running     0             68m
kube-system       aws-node-x5dbf                                      2/2     Running     0             68m
kube-system       cluster-autoscaler-7c695875fd-t4rrv                 1/1     Running     0             65m
kube-system       coredns-5ff67bdd68-kvhdj                            1/1     Running     0             68m
kube-system       coredns-5ff67bdd68-pvrpb                            1/1     Running     0             68m
kube-system       ebs-csi-controller-559bdf89f-bltb5                  6/6     Running     0             68m
kube-system       ebs-csi-controller-559bdf89f-qrwfd                  6/6     Running     0             68m
kube-system       ebs-csi-node-98pg6                                  3/3     Running     0             68m
kube-system       ebs-csi-node-9rhrr                                  3/3     Running     0             68m
kube-system       ebs-csi-node-dr54j                                  3/3     Running     0             68m
kube-system       ebs-csi-node-f4wdz                                  3/3     Running     0             68m
kube-system       ebs-csi-node-g9xwq                                  3/3     Running     0             68m
kube-system       ebs-csi-node-h5ftg                                  3/3     Running     0             68m
kube-system       ebs-csi-node-k69gf                                  3/3     Running     0             68m
kube-system       ebs-csi-node-lbnrv                                  3/3     Running     0             68m
kube-system       ebs-csi-node-lszjp                                  3/3     Running     0             68m
kube-system       ebs-csi-node-ncgwd                                  3/3     Running     0             68m
kube-system       ebs-csi-node-q228c                                  3/3     Running     0             68m
kube-system       ebs-csi-node-rd4vc                                  3/3     Running     0             68m
kube-system       kube-proxy-5b4k6                                    1/1     Running     0             68m
kube-system       kube-proxy-82v56                                    1/1     Running     0             68m
kube-system       kube-proxy-cw7b5                                    1/1     Running     0             68m
kube-system       kube-proxy-fn2jl                                    1/1     Running     0             68m
kube-system       kube-proxy-ftc8z                                    1/1     Running     0             68m
kube-system       kube-proxy-k27jb                                    1/1     Running     0             68m
kube-system       kube-proxy-l2zqz                                    1/1     Running     0             68m
kube-system       kube-proxy-mm9x2                                    1/1     Running     0             68m
kube-system       kube-proxy-n6kxg                                    1/1     Running     0             68m
kube-system       kube-proxy-nnbwt                                    1/1     Running     0             68m
kube-system       kube-proxy-phfdh                                    1/1     Running     0             68m
kube-system       kube-proxy-sjvbs                                    1/1     Running     0             68m
kube-system       node-agent-57pdl                                    1/1     Running     0             65m
kube-system       node-agent-68bdh                                    1/1     Running     0             65m
kube-system       node-agent-9sxn6                                    1/1     Running     0             65m
kube-system       node-agent-cdx5v                                    1/1     Running     0             65m
kube-system       node-agent-fxn8w                                    1/1     Running     0             65m
kube-system       node-agent-jm4kn                                    1/1     Running     0             65m
kube-system       node-agent-l77bj                                    1/1     Running     0             65m
kube-system       node-agent-mdsz6                                    1/1     Running     0             65m
kube-system       node-agent-nhm6h                                    1/1     Running     0             65m
kube-system       node-agent-v5fhq                                    1/1     Running     0             65m
kube-system       node-agent-vl5fz                                    1/1     Running     0             65m
kube-system       node-agent-w8f76                                    1/1     Running     0             65m
kube-system       snapshot-controller-df5bd8577-ncxfw                 1/1     Running     0             68m
kube-system       snapshot-controller-df5bd8577-xkqzb                 1/1     Running     0             68m
kube-system       velero-c7dcf5cb9-bdgx7                              1/1     Running     0             65m
logging           infra-fluentbit-49hvd                               1/1     Running     0             64m
logging           infra-fluentbit-57kzk                               1/1     Running     0             64m
logging           infra-fluentbit-6f8sd                               1/1     Running     0             64m
logging           infra-fluentbit-ddzqz                               1/1     Running     0             64m
logging           infra-fluentbit-dmdcr                               1/1     Running     0             64m
logging           infra-fluentbit-fr9ls                               1/1     Running     0             64m
logging           infra-fluentbit-hcfnm                               1/1     Running     0             64m
logging           infra-fluentbit-ns48m                               1/1     Running     0             64m
logging           infra-fluentbit-q6znn                               1/1     Running     0             64m
logging           infra-fluentbit-rkkfs                               1/1     Running     0             64m
logging           infra-fluentbit-x488h                               1/1     Running     0             64m
logging           infra-fluentbit-xr6sd                               1/1     Running     0             64m
logging           infra-fluentd-0                                     2/2     Running     0             64m
logging           infra-fluentd-1                                     2/2     Running     0             64m
logging           infra-fluentd-configcheck-e6788adb                  0/1     Completed   0             65m
logging           kubernetes-event-tailer-0                           1/1     Running     0             65m
logging           logging-operator-668978fb68-sdkfr                   1/1     Running     0             65m
logging           loki-distributed-compactor-0                        1/1     Running     2 (64m ago)   65m
logging           loki-distributed-distributor-66965974fc-hvg8w       1/1     Running     0             48s
logging           loki-distributed-distributor-66965974fc-wtqsq       1/1     Running     0             65m
logging           loki-distributed-gateway-84c69f68-47l4p             1/1     Running     0             65m
logging           loki-distributed-index-gateway-0                    1/1     Running     0             65m
logging           loki-distributed-ingester-0                         1/1     Running     0             65m
logging           loki-distributed-querier-659fdcf7cf-fchx6           1/1     Running     0             65m
logging           loki-distributed-query-frontend-757c4f8469-vjftf    1/1     Running     0             65m
logging           loki-distributed-query-scheduler-76f648bbf6-t7jmv   1/1     Running     0             65m
logging           minio-logging-0                                     1/1     Running     0             65m
logging           minio-logging-1                                     1/1     Running     0             65m
logging           minio-logging-2                                     1/1     Running     0             65m
logging           minio-logging-buckets-setup-rg79l                   0/1     Completed   0             82s
logging           systemd-common-host-tailer-8gw78                    4/4     Running     0             65m
logging           systemd-common-host-tailer-9hxfq                    4/4     Running     0             65m
logging           systemd-common-host-tailer-fqnzq                    4/4     Running     0             65m
logging           systemd-common-host-tailer-hmbkg                    4/4     Running     0             65m
logging           systemd-common-host-tailer-jk7b2                    4/4     Running     0             65m
logging           systemd-common-host-tailer-lzd7r                    4/4     Running     0             65m
logging           systemd-common-host-tailer-njz6z                    4/4     Running     0             65m
logging           systemd-common-host-tailer-qbr5t                    4/4     Running     0             65m
logging           systemd-common-host-tailer-rcmfj                    4/4     Running     0             65m
logging           systemd-common-host-tailer-s8hxs                    4/4     Running     0             65m
logging           systemd-common-host-tailer-zvsmc                    4/4     Running     0             65m
logging           systemd-common-host-tailer-zwbcg                    4/4     Running     0             65m
monitoring        alertmanager-main-0                                 2/2     Running     0             65m
monitoring        blackbox-exporter-798b896c7f-cqw75                  3/3     Running     0             65m
monitoring        grafana-8b86bdd9c-6b889                             3/3     Running     0             65m
monitoring        kube-proxy-metrics-6cgn4                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-8l4xq                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-98n8n                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-ctjl9                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-dgj7z                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-f5jqw                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-ggjct                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-hlbbr                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-qtx5f                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-rqkpx                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-zm7b5                            1/1     Running     0             65m
monitoring        kube-proxy-metrics-zz6sc                            1/1     Running     0             65m
monitoring        kube-state-metrics-88bdf59f-8l5fn                   3/3     Running     0             65m
monitoring        node-exporter-6fk8v                                 2/2     Running     0             65m
monitoring        node-exporter-b9k8l                                 2/2     Running     0             65m
monitoring        node-exporter-brfmq                                 2/2     Running     0             65m
monitoring        node-exporter-cm86d                                 2/2     Running     0             65m
monitoring        node-exporter-dtsp7                                 2/2     Running     0             65m
monitoring        node-exporter-g227n                                 2/2     Running     0             65m
monitoring        node-exporter-jtpcl                                 2/2     Running     0             65m
monitoring        node-exporter-lctc2                                 2/2     Running     0             65m
monitoring        node-exporter-p662j                                 2/2     Running     0             65m
monitoring        node-exporter-pv4qm                                 2/2     Running     0             65m
monitoring        node-exporter-vcrgp                                 2/2     Running     0             65m
monitoring        node-exporter-zkmpm                                 2/2     Running     0             65m
monitoring        prometheus-adapter-8cb648b98-76f5n                  1/1     Running     0             65m
monitoring        prometheus-k8s-0                                    2/2     Running     0             65m
monitoring        prometheus-operator-d8788d4d4-wwwmx                 2/2     Running     0             65m
monitoring        x509-certificate-exporter-59886f95cb-ghcvf          1/1     Running     0             65m
tigera-operator   tigera-operator-5fbb6dcc7c-tfq9q                    1/1     Running     0             65m
```

## Run conformance tests

> Install requirements and run commands:

Dowload Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
