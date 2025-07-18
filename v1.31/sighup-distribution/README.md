# Conformance tests for SIGHUP Distribution

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.31.0-rc.0 installed: https://github.com/sighupio/furyctl/releases/tag/v0.31.0-rc.0
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
  name: k8s-conformance-131
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.31.0-rc.4
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: k8s-fury-1.31.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-131"
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
            bucketName: kfd-conformance-velero-131
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
INFO Running preflight checks...                  
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
INFO To connect to the cluster, set the path to your kubeconfig with 'export KUBECONFIG=/home/sighup/eks/kubeconfig' or use the '--kubeconfig /home/sighup/eks/kubeconfig' flag in following executions   
```

#### Verify that the cluster is up & running

```bash
kubectl get nodes -L node.kubernetes.io/role --kubeconfig kubeconfig
NAME                                          STATUS   ROLES    AGE   VERSION               ROLE
ip-10-150-0-85.eu-west-1.compute.internal     Ready    <none>   42m   v1.31.3-eks-59bf375   ingress
ip-10-150-10-89.eu-west-1.compute.internal    Ready    <none>   42m   v1.31.3-eks-59bf375   worker
ip-10-150-16-144.eu-west-1.compute.internal   Ready    <none>   42m   v1.31.3-eks-59bf375   infra
ip-10-150-22-54.eu-west-1.compute.internal    Ready    <none>   42m   v1.31.3-eks-59bf375   infra
ip-10-150-26-230.eu-west-1.compute.internal   Ready    <none>   42m   v1.31.3-eks-59bf375   ingress
ip-10-150-3-82.eu-west-1.compute.internal     Ready    <none>   42m   v1.31.3-eks-59bf375   infra
ip-10-150-30-240.eu-west-1.compute.internal   Ready    <none>   42m   v1.31.3-eks-59bf375   worker
ip-10-150-33-117.eu-west-1.compute.internal   Ready    <none>   42m   v1.31.3-eks-59bf375   infra
ip-10-150-35-5.eu-west-1.compute.internal     Ready    <none>   42m   v1.31.3-eks-59bf375   worker
ip-10-150-37-215.eu-west-1.compute.internal   Ready    <none>   42m   v1.31.3-eks-59bf375   ingress
ip-10-150-43-3.eu-west-1.compute.internal     Ready    <none>   42m   v1.31.3-eks-59bf375   infra
ip-10-150-9-152.eu-west-1.compute.internal    Ready    <none>   42m   v1.31.3-eks-59bf375   infra
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                              READY   STATUS      RESTARTS   AGE
calico-system     calico-kube-controllers-5bd7bf56bb-fk7ql          1/1     Running     0          39m
calico-system     calico-node-5n5sf                                 1/1     Running     0          39m
calico-system     calico-node-7bjtz                                 1/1     Running     0          39m
calico-system     calico-node-85xlv                                 1/1     Running     0          39m
calico-system     calico-node-8m6v5                                 1/1     Running     0          39m
calico-system     calico-node-c5jgx                                 1/1     Running     0          39m
calico-system     calico-node-gjlmp                                 1/1     Running     0          39m
calico-system     calico-node-hnjq2                                 1/1     Running     0          39m
calico-system     calico-node-mvh4j                                 1/1     Running     0          39m
calico-system     calico-node-n56z7                                 1/1     Running     0          39m
calico-system     calico-node-pmmtl                                 1/1     Running     0          39m
calico-system     calico-node-qt5sd                                 1/1     Running     0          39m
calico-system     calico-node-trbbb                                 1/1     Running     0          39m
calico-system     calico-typha-b5bb87478-7m7ft                      1/1     Running     0          39m
calico-system     calico-typha-b5bb87478-psfhj                      1/1     Running     0          39m
calico-system     calico-typha-b5bb87478-zvlsp                      1/1     Running     0          39m
calico-system     csi-node-driver-48j95                             2/2     Running     0          39m
calico-system     csi-node-driver-4fg64                             2/2     Running     0          39m
calico-system     csi-node-driver-7pxz6                             2/2     Running     0          39m
calico-system     csi-node-driver-8xgtk                             2/2     Running     0          39m
calico-system     csi-node-driver-b22cq                             2/2     Running     0          39m
calico-system     csi-node-driver-bjl52                             2/2     Running     0          39m
calico-system     csi-node-driver-hjkcp                             2/2     Running     0          39m
calico-system     csi-node-driver-ln2wb                             2/2     Running     0          39m
calico-system     csi-node-driver-mckt6                             2/2     Running     0          39m
calico-system     csi-node-driver-qtrqx                             2/2     Running     0          39m
calico-system     csi-node-driver-rjvnl                             2/2     Running     0          39m
calico-system     csi-node-driver-xx6f2                             2/2     Running     0          39m
cert-manager      cert-manager-57bc5668d5-mrq8q                     1/1     Running     0          40m
cert-manager      cert-manager-cainjector-7496b766db-59m8x          1/1     Running     0          40m
cert-manager      cert-manager-webhook-68978964bd-9gqlv             1/1     Running     0          40m
ingress-nginx     external-dns-private-5b9c5d8c9-254cq              1/1     Running     0          40m
ingress-nginx     external-dns-public-7d9f879fd5-2p8s5              1/1     Running     0          40m
ingress-nginx     forecastle-6fbf9cb9d9-kdg2p                       1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-external-2vr7z           1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-external-ghvmp           1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-external-rdmwx           1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-internal-67mkv           1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-internal-7btlx           1/1     Running     0          40m
ingress-nginx     ingress-nginx-controller-internal-bvkdr           1/1     Running     0          40m
kube-system       aws-load-balancer-controller-65887dcd8f-svdwr     1/1     Running     0          40m
kube-system       aws-node-28fz4                                    2/2     Running     0          42m
kube-system       aws-node-6jbgr                                    2/2     Running     0          42m
kube-system       aws-node-9rjlk                                    2/2     Running     0          42m
kube-system       aws-node-b5wqb                                    2/2     Running     0          42m
kube-system       aws-node-cgnbv                                    2/2     Running     0          42m
kube-system       aws-node-gxcfd                                    2/2     Running     0          42m
kube-system       aws-node-ntvb4                                    2/2     Running     0          42m
kube-system       aws-node-nzftv                                    2/2     Running     0          42m
kube-system       aws-node-p795p                                    2/2     Running     0          42m
kube-system       aws-node-phcf8                                    2/2     Running     0          42m
kube-system       aws-node-rgp79                                    2/2     Running     0          42m
kube-system       aws-node-shgwk                                    2/2     Running     0          42m
kube-system       aws-node-termination-handler-4g4k9                1/1     Running     0          40m
kube-system       aws-node-termination-handler-4nt2n                1/1     Running     0          40m
kube-system       aws-node-termination-handler-5kftf                1/1     Running     0          40m
kube-system       aws-node-termination-handler-72fnk                1/1     Running     0          40m
kube-system       aws-node-termination-handler-9xhw6                1/1     Running     0          40m
kube-system       aws-node-termination-handler-hsgxj                1/1     Running     0          40m
kube-system       aws-node-termination-handler-n9q8x                1/1     Running     0          40m
kube-system       aws-node-termination-handler-p76rt                1/1     Running     0          40m
kube-system       aws-node-termination-handler-pcpst                1/1     Running     0          40m
kube-system       aws-node-termination-handler-pm4cp                1/1     Running     0          40m
kube-system       aws-node-termination-handler-rjjnc                1/1     Running     0          40m
kube-system       aws-node-termination-handler-x2g7k                1/1     Running     0          40m
kube-system       cluster-autoscaler-74ddfb7486-vhntb               1/1     Running     0          40m
kube-system       coredns-5476d9fb48-6rm66                          1/1     Running     0          42m
kube-system       coredns-5476d9fb48-vlj68                          1/1     Running     0          42m
kube-system       ebs-csi-controller-747cc7bcd7-f8npd               6/6     Running     0          42m
kube-system       ebs-csi-controller-747cc7bcd7-fxtwd               6/6     Running     0          42m
kube-system       ebs-csi-node-44z8b                                3/3     Running     0          42m
kube-system       ebs-csi-node-59qgh                                3/3     Running     0          42m
kube-system       ebs-csi-node-5hjkt                                3/3     Running     0          42m
kube-system       ebs-csi-node-6p6j4                                3/3     Running     0          42m
kube-system       ebs-csi-node-7g7jf                                3/3     Running     0          42m
kube-system       ebs-csi-node-9f5cm                                3/3     Running     0          42m
kube-system       ebs-csi-node-gmscf                                3/3     Running     0          42m
kube-system       ebs-csi-node-njnd8                                3/3     Running     0          42m
kube-system       ebs-csi-node-qrb25                                3/3     Running     0          42m
kube-system       ebs-csi-node-snhx4                                3/3     Running     0          42m
kube-system       ebs-csi-node-twcx5                                3/3     Running     0          42m
kube-system       ebs-csi-node-x84dw                                3/3     Running     0          42m
kube-system       kube-proxy-5gvkf                                  1/1     Running     0          42m
kube-system       kube-proxy-8gzqj                                  1/1     Running     0          42m
kube-system       kube-proxy-95wlv                                  1/1     Running     0          42m
kube-system       kube-proxy-d9rj4                                  1/1     Running     0          42m
kube-system       kube-proxy-db7c2                                  1/1     Running     0          42m
kube-system       kube-proxy-dmj6v                                  1/1     Running     0          42m
kube-system       kube-proxy-fbgdl                                  1/1     Running     0          42m
kube-system       kube-proxy-k4r49                                  1/1     Running     0          42m
kube-system       kube-proxy-q4h6d                                  1/1     Running     0          42m
kube-system       kube-proxy-wbjnn                                  1/1     Running     0          42m
kube-system       kube-proxy-xhsk2                                  1/1     Running     0          42m
kube-system       kube-proxy-xwvwj                                  1/1     Running     0          42m
kube-system       snapshot-controller-7c8fb6bbd6-jfg97              1/1     Running     0          40m
kube-system       velero-57c95c9986-pnfqz                           1/1     Running     0          40m
logging           infra-fluentbit-742fp                             1/1     Running     0          39m
logging           infra-fluentbit-782cn                             1/1     Running     0          39m
logging           infra-fluentbit-8lq8n                             1/1     Running     0          39m
logging           infra-fluentbit-f52xc                             1/1     Running     0          39m
logging           infra-fluentbit-glwvx                             1/1     Running     0          39m
logging           infra-fluentbit-kjb8p                             1/1     Running     0          39m
logging           infra-fluentbit-ngl7r                             1/1     Running     0          39m
logging           infra-fluentbit-tgtgr                             1/1     Running     0          39m
logging           infra-fluentbit-w7sb5                             1/1     Running     0          39m
logging           infra-fluentbit-z92nw                             1/1     Running     0          39m
logging           infra-fluentbit-zc5sf                             1/1     Running     0          39m
logging           infra-fluentbit-zc6db                             1/1     Running     0          39m
logging           infra-fluentd-0                                   2/2     Running     0          39m
logging           infra-fluentd-1                                   2/2     Running     0          39m
logging           infra-fluentd-configcheck-e6788adb                0/1     Completed   0          39m
logging           kubernetes-event-tailer-0                         1/1     Running     0          39m
logging           logging-operator-764dcff4cb-46zp4                 1/1     Running     0          40m
logging           loki-distributed-compactor-8548968f56-m2cb6       1/1     Running     0          40m
logging           loki-distributed-distributor-749bdcc87d-c2z2l     1/1     Running     0          40m
logging           loki-distributed-gateway-56ffd6d5fd-58qnv         1/1     Running     0          40m
logging           loki-distributed-ingester-0                       1/1     Running     0          40m
logging           loki-distributed-querier-0                        1/1     Running     0          40m
logging           loki-distributed-query-frontend-fb97f9f4b-cpk4v   1/1     Running     0          40m
logging           minio-logging-0                                   1/1     Running     0          40m
logging           minio-logging-1                                   1/1     Running     0          40m
logging           minio-logging-2                                   1/1     Running     0          40m
logging           minio-logging-buckets-setup-4mjkr                 0/1     Completed   0          40m
logging           systemd-common-host-tailer-9j2z6                  4/4     Running     0          39m
logging           systemd-common-host-tailer-b2tnd                  4/4     Running     0          39m
logging           systemd-common-host-tailer-dnp9g                  4/4     Running     0          39m
logging           systemd-common-host-tailer-f47bd                  4/4     Running     0          39m
logging           systemd-common-host-tailer-gcslb                  4/4     Running     0          39m
logging           systemd-common-host-tailer-jsfj9                  4/4     Running     0          39m
logging           systemd-common-host-tailer-lvcph                  4/4     Running     0          39m
logging           systemd-common-host-tailer-mrl2v                  4/4     Running     0          39m
logging           systemd-common-host-tailer-n6j6b                  4/4     Running     0          39m
logging           systemd-common-host-tailer-s74qb                  4/4     Running     0          39m
logging           systemd-common-host-tailer-sqwjm                  4/4     Running     0          39m
logging           systemd-common-host-tailer-wfd7q                  4/4     Running     0          39m
monitoring        alertmanager-main-0                               2/2     Running     0          39m
monitoring        blackbox-exporter-8697fcfcf5-4wqj4                3/3     Running     0          40m
monitoring        grafana-7856b44c69-nsrnd                          3/3     Running     0          40m
monitoring        kube-proxy-metrics-5ctsf                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-9plvb                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-c55dv                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-d2g4x                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-jhctz                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-k5x4q                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-kfqr4                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-mqjpw                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-qqj52                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-t62vf                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-ts72t                          1/1     Running     0          40m
monitoring        kube-proxy-metrics-zs2n4                          1/1     Running     0          40m
monitoring        kube-state-metrics-77f8455f67-tfbc4               3/3     Running     0          40m
monitoring        node-exporter-2hbzd                               2/2     Running     0          40m
monitoring        node-exporter-4p5xs                               2/2     Running     0          40m
monitoring        node-exporter-4rj25                               2/2     Running     0          40m
monitoring        node-exporter-6lzl4                               2/2     Running     0          40m
monitoring        node-exporter-822kd                               2/2     Running     0          40m
monitoring        node-exporter-8fwhl                               2/2     Running     0          40m
monitoring        node-exporter-9c7sd                               2/2     Running     0          40m
monitoring        node-exporter-cmmgj                               2/2     Running     0          40m
monitoring        node-exporter-ctwhl                               2/2     Running     0          40m
monitoring        node-exporter-g7x6f                               2/2     Running     0          40m
monitoring        node-exporter-gjgzx                               2/2     Running     0          40m
monitoring        node-exporter-qvpz9                               2/2     Running     0          40m
monitoring        prometheus-adapter-59cc486df8-pzhsx               1/1     Running     0          40m
monitoring        prometheus-k8s-0                                  2/2     Running     0          39m
monitoring        prometheus-operator-7664f7454d-rvt4m              2/2     Running     0          40m
monitoring        x509-certificate-exporter-84dcbb44cd-f72s2        1/1     Running     0          40m
tigera-operator   tigera-operator-57f4d7894c-8skbg                  1/1     Running     0          40m
```

## Run conformance tests

> Install requirements and run commands:

Dowload Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
