# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.27.8 installed: https://github.com/sighupio/furyctl/releases/tag/v0.27.8 
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
  name: k8s-conformance-128
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.28.0-rc.3
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: k8s-fury-1.28.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-128"
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
            bucketName: kfd-conformance-velero
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
ip-10-150-10-227.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
ip-10-150-15-131.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-15-28.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-18-109.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-18-27.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
ip-10-150-19-110.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-19-23.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-19-84.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-2-162.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
ip-10-150-27-77.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-28-128.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
ip-10-150-3-151.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-30-196.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-32-116.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-35-135.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-37-134.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-38-98.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-39-179.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
ip-10-150-39-84.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-4-118.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-4-121.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-4-85.eu-west-1.compute.internal     Ready    <none>   23m   v1.28.5-eks-5e0fdde   ingress
ip-10-150-41-233.eu-west-1.compute.internal   Ready    <none>   23m   v1.28.5-eks-5e0fdde   infra
ip-10-150-47-68.eu-west-1.compute.internal    Ready    <none>   23m   v1.28.5-eks-5e0fdde   worker
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                               READY   STATUS      RESTARTS        AGE
calico-system     calico-kube-controllers-bf6bbc584-l5sfp            1/1     Running     0               42m
calico-system     calico-node-4m4t8                                  1/1     Running     0               42m
calico-system     calico-node-4zmd9                                  1/1     Running     0               42m
calico-system     calico-node-5c62b                                  1/1     Running     0               42m
calico-system     calico-node-5vmkh                                  1/1     Running     0               42m
calico-system     calico-node-6tfgq                                  1/1     Running     0               42m
calico-system     calico-node-6vng6                                  1/1     Running     0               42m
calico-system     calico-node-9598q                                  1/1     Running     0               42m
calico-system     calico-node-bzmmp                                  1/1     Running     0               42m
calico-system     calico-node-c9ckx                                  1/1     Running     0               42m
calico-system     calico-node-mz9dq                                  1/1     Running     0               42m
calico-system     calico-node-nrqsc                                  1/1     Running     0               42m
calico-system     calico-node-ntgm5                                  1/1     Running     0               42m
calico-system     calico-node-pkhv7                                  1/1     Running     0               42m
calico-system     calico-node-pnvb7                                  1/1     Running     0               42m
calico-system     calico-node-ppt2n                                  1/1     Running     0               42m
calico-system     calico-node-rn4kj                                  1/1     Running     0               42m
calico-system     calico-node-rnscw                                  1/1     Running     0               42m
calico-system     calico-node-rrkl5                                  1/1     Running     0               42m
calico-system     calico-node-rz4xp                                  1/1     Running     0               42m
calico-system     calico-node-szjj8                                  1/1     Running     0               42m
calico-system     calico-node-trls5                                  1/1     Running     0               42m
calico-system     calico-node-w792l                                  1/1     Running     0               42m
calico-system     calico-node-wmz2t                                  1/1     Running     0               42m
calico-system     calico-node-zfkvw                                  1/1     Running     0               42m
calico-system     calico-typha-56fd478d98-dz98j                      1/1     Running     0               42m
calico-system     calico-typha-56fd478d98-mqxgv                      1/1     Running     0               42m
calico-system     calico-typha-56fd478d98-x28jq                      1/1     Running     0               42m
calico-system     csi-node-driver-2qqw2                              2/2     Running     0               42m
calico-system     csi-node-driver-4ww54                              2/2     Running     0               42m
calico-system     csi-node-driver-59l4m                              2/2     Running     0               42m
calico-system     csi-node-driver-5xcbf                              2/2     Running     0               42m
calico-system     csi-node-driver-67qzn                              2/2     Running     0               42m
calico-system     csi-node-driver-68kgs                              2/2     Running     0               42m
calico-system     csi-node-driver-84t5n                              2/2     Running     0               42m
calico-system     csi-node-driver-865sx                              2/2     Running     0               42m
calico-system     csi-node-driver-88chv                              2/2     Running     0               42m
calico-system     csi-node-driver-8rg88                              2/2     Running     0               42m
calico-system     csi-node-driver-ddwkj                              2/2     Running     0               42m
calico-system     csi-node-driver-dtt9f                              2/2     Running     0               42m
calico-system     csi-node-driver-fg5sx                              2/2     Running     0               42m
calico-system     csi-node-driver-kv7zl                              2/2     Running     0               42m
calico-system     csi-node-driver-lb8q8                              2/2     Running     0               42m
calico-system     csi-node-driver-mhgcs                              2/2     Running     0               42m
calico-system     csi-node-driver-nmzxr                              2/2     Running     0               42m
calico-system     csi-node-driver-pgfb5                              2/2     Running     0               42m
calico-system     csi-node-driver-r8hjl                              2/2     Running     0               42m
calico-system     csi-node-driver-r8q8t                              2/2     Running     0               42m
calico-system     csi-node-driver-slwjr                              2/2     Running     0               42m
calico-system     csi-node-driver-vs6sf                              2/2     Running     0               42m
calico-system     csi-node-driver-xgsqb                              2/2     Running     0               42m
calico-system     csi-node-driver-zrf7b                              2/2     Running     0               42m
cert-manager      cert-manager-76c46d8584-ljkbd                      1/1     Running     0               43m
cert-manager      cert-manager-cainjector-6dcd56d446-dhns4           1/1     Running     0               43m
cert-manager      cert-manager-webhook-85dd948746-ndvvs              1/1     Running     0               43m
ingress-nginx     external-dns-private-7b6df96d47-f7zpm              1/1     Running     7 (9m16s ago)   43m
ingress-nginx     external-dns-public-9d97b84cf-kx67l                1/1     Running     11 (10m ago)    43m
ingress-nginx     forecastle-c6786b695-qxz5g                         1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-2whxp            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-7trw7            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-8m22v            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-jg55c            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-jrqp8            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-external-s9dn9            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-brbms            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-bwmxp            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-h5g8z            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-mg5mw            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-tvxnk            1/1     Running     0               43m
ingress-nginx     nginx-ingress-controller-internal-wrj79            1/1     Running     0               43m
kube-system       aws-load-balancer-controller-dbcd7b987-mcv6b       1/1     Running     0               43m
kube-system       aws-node-2g522                                     2/2     Running     0               45m
kube-system       aws-node-2j567                                     2/2     Running     0               45m
kube-system       aws-node-2msfw                                     2/2     Running     0               45m
kube-system       aws-node-2pqhw                                     2/2     Running     0               45m
kube-system       aws-node-4mng7                                     2/2     Running     0               45m
kube-system       aws-node-5nq5r                                     2/2     Running     0               45m
kube-system       aws-node-9kkgl                                     2/2     Running     0               45m
kube-system       aws-node-gwp6q                                     2/2     Running     0               45m
kube-system       aws-node-h8d5h                                     2/2     Running     0               45m
kube-system       aws-node-hhpsl                                     2/2     Running     0               45m
kube-system       aws-node-k5tsj                                     2/2     Running     0               45m
kube-system       aws-node-kjtkl                                     2/2     Running     0               45m
kube-system       aws-node-p4hfr                                     2/2     Running     0               45m
kube-system       aws-node-plrt8                                     2/2     Running     0               45m
kube-system       aws-node-pp2kk                                     2/2     Running     0               45m
kube-system       aws-node-qtdkc                                     2/2     Running     0               45m
kube-system       aws-node-r6tkr                                     2/2     Running     0               45m
kube-system       aws-node-sglnr                                     2/2     Running     0               45m
kube-system       aws-node-termination-handler-27749                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-4cqbr                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-676x4                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-6hdlw                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-75d62                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-7hnhb                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-bz7tj                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-c2fzd                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-ftzd7                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-fvbz5                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-g29p8                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-g2v5v                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-hrfpr                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-kvwvz                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-nhwgr                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-ntgln                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-qgrfg                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-ss5jj                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-vf4lk                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-vgd4k                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-w5nv4                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-xfd6p                 1/1     Running     0               42m
kube-system       aws-node-termination-handler-xl94n                 1/1     Running     0               43m
kube-system       aws-node-termination-handler-xpdt9                 1/1     Running     0               43m
kube-system       aws-node-ttvnt                                     2/2     Running     0               45m
kube-system       aws-node-wjhmc                                     2/2     Running     0               45m
kube-system       aws-node-xjsbt                                     2/2     Running     0               45m
kube-system       aws-node-z4wcc                                     2/2     Running     0               45m
kube-system       aws-node-zqwzx                                     2/2     Running     0               45m
kube-system       aws-node-zvnj9                                     2/2     Running     0               45m
kube-system       cluster-autoscaler-6f79b8445-j5hfw                 1/1     Running     0               43m
kube-system       coredns-69dcfb58cb-nn85w                           1/1     Running     0               45m
kube-system       coredns-69dcfb58cb-pcxd8                           1/1     Running     0               45m
kube-system       ebs-csi-controller-745d974464-9j6pv                6/6     Running     0               45m
kube-system       ebs-csi-controller-745d974464-sdljs                6/6     Running     0               45m
kube-system       ebs-csi-node-296mm                                 3/3     Running     0               45m
kube-system       ebs-csi-node-6v8v7                                 3/3     Running     0               45m
kube-system       ebs-csi-node-7ltgx                                 3/3     Running     0               45m
kube-system       ebs-csi-node-8ddtc                                 3/3     Running     0               45m
kube-system       ebs-csi-node-8lcdt                                 3/3     Running     0               45m
kube-system       ebs-csi-node-8rk44                                 3/3     Running     0               45m
kube-system       ebs-csi-node-bc6lj                                 3/3     Running     0               45m
kube-system       ebs-csi-node-czsr5                                 3/3     Running     0               45m
kube-system       ebs-csi-node-d7wg4                                 3/3     Running     0               45m
kube-system       ebs-csi-node-dc7vg                                 3/3     Running     0               45m
kube-system       ebs-csi-node-dsd2m                                 3/3     Running     0               45m
kube-system       ebs-csi-node-fhxvk                                 3/3     Running     0               45m
kube-system       ebs-csi-node-gw9q6                                 3/3     Running     0               45m
kube-system       ebs-csi-node-hq5p5                                 3/3     Running     0               45m
kube-system       ebs-csi-node-jcqn7                                 3/3     Running     0               45m
kube-system       ebs-csi-node-k5mvc                                 3/3     Running     0               45m
kube-system       ebs-csi-node-lfgl8                                 3/3     Running     0               45m
kube-system       ebs-csi-node-ltxzf                                 3/3     Running     0               45m
kube-system       ebs-csi-node-mtgtl                                 3/3     Running     0               45m
kube-system       ebs-csi-node-nxvrk                                 3/3     Running     0               45m
kube-system       ebs-csi-node-p5hgv                                 3/3     Running     0               45m
kube-system       ebs-csi-node-q6qlw                                 3/3     Running     0               45m
kube-system       ebs-csi-node-sgdx7                                 3/3     Running     0               45m
kube-system       ebs-csi-node-t2gmd                                 3/3     Running     0               45m
kube-system       kube-proxy-2bc8m                                   1/1     Running     0               45m
kube-system       kube-proxy-2r4tk                                   1/1     Running     0               45m
kube-system       kube-proxy-44vs4                                   1/1     Running     0               45m
kube-system       kube-proxy-5dgnk                                   1/1     Running     0               45m
kube-system       kube-proxy-5ssfj                                   1/1     Running     0               45m
kube-system       kube-proxy-6f7k5                                   1/1     Running     0               45m
kube-system       kube-proxy-6tff8                                   1/1     Running     0               45m
kube-system       kube-proxy-8rhgg                                   1/1     Running     0               45m
kube-system       kube-proxy-cmmlh                                   1/1     Running     0               45m
kube-system       kube-proxy-f298r                                   1/1     Running     0               45m
kube-system       kube-proxy-f86bs                                   1/1     Running     0               45m
kube-system       kube-proxy-fwtr9                                   1/1     Running     0               45m
kube-system       kube-proxy-hbvht                                   1/1     Running     0               45m
kube-system       kube-proxy-l5pw5                                   1/1     Running     0               45m
kube-system       kube-proxy-nftqk                                   1/1     Running     0               45m
kube-system       kube-proxy-pcfcr                                   1/1     Running     0               45m
kube-system       kube-proxy-qm9bn                                   1/1     Running     0               45m
kube-system       kube-proxy-r2sdq                                   1/1     Running     0               45m
kube-system       kube-proxy-rjtqk                                   1/1     Running     0               45m
kube-system       kube-proxy-sdkmw                                   1/1     Running     0               45m
kube-system       kube-proxy-w49kj                                   1/1     Running     0               45m
kube-system       kube-proxy-wkknx                                   1/1     Running     0               45m
kube-system       kube-proxy-xh5p5                                   1/1     Running     0               45m
kube-system       kube-proxy-z8nht                                   1/1     Running     0               45m
kube-system       snapshot-controller-8659758d48-k96sd               1/1     Running     0               43m
kube-system       velero-66b55fffd6-5vb9b                            1/1     Running     0               43m
logging           infra-fluentbit-2cqv8                              1/1     Running     0               42m
logging           infra-fluentbit-5dbtp                              1/1     Running     0               42m
logging           infra-fluentbit-5dk99                              1/1     Running     0               42m
logging           infra-fluentbit-5w9qb                              1/1     Running     0               42m
logging           infra-fluentbit-6gxw5                              1/1     Running     0               42m
logging           infra-fluentbit-77nhb                              1/1     Running     0               42m
logging           infra-fluentbit-bgxxm                              1/1     Running     0               42m
logging           infra-fluentbit-c62ls                              1/1     Running     0               42m
logging           infra-fluentbit-c7wkp                              1/1     Running     0               42m
logging           infra-fluentbit-dj4wn                              1/1     Running     0               42m
logging           infra-fluentbit-ghjq2                              1/1     Running     0               42m
logging           infra-fluentbit-h8t8p                              1/1     Running     0               42m
logging           infra-fluentbit-kd8kv                              1/1     Running     0               42m
logging           infra-fluentbit-nrprz                              1/1     Running     0               42m
logging           infra-fluentbit-ppxc4                              1/1     Running     0               42m
logging           infra-fluentbit-rcvq9                              1/1     Running     0               42m
logging           infra-fluentbit-rfztr                              1/1     Running     0               42m
logging           infra-fluentbit-rkxb5                              1/1     Running     0               42m
logging           infra-fluentbit-sjb58                              1/1     Running     0               42m
logging           infra-fluentbit-vzrfq                              1/1     Running     0               42m
logging           infra-fluentbit-ws67r                              1/1     Running     0               42m
logging           infra-fluentbit-x296l                              1/1     Running     0               42m
logging           infra-fluentbit-x5hvf                              1/1     Running     0               42m
logging           infra-fluentbit-x7tcj                              1/1     Running     0               42m
logging           infra-fluentd-0                                    2/2     Running     0               42m
logging           infra-fluentd-1                                    2/2     Running     0               42m
logging           infra-fluentd-configcheck-a6ee17e7                 0/1     Completed   0               42m
logging           kubernetes-event-tailer-0                          1/1     Running     0               42m
logging           logging-operator-5484b79c5-jq46c                   1/1     Running     0               43m
logging           loki-distributed-compactor-859b76c4fc-j2xt5        1/1     Running     0               43m
logging           loki-distributed-distributor-547db994fb-bm4k4      1/1     Running     0               43m
logging           loki-distributed-gateway-768b87db68-wnx2w          1/1     Running     0               43m
logging           loki-distributed-ingester-0                        1/1     Running     0               43m
logging           loki-distributed-querier-0                         1/1     Running     0               43m
logging           loki-distributed-query-frontend-764459db7d-vp9ds   1/1     Running     0               43m
logging           minio-logging-0                                    1/1     Running     0               43m
logging           minio-logging-1                                    1/1     Running     0               43m
logging           minio-logging-2                                    1/1     Running     0               43m
logging           minio-logging-buckets-setup-k7h68                  0/1     Completed   0               68s
logging           systemd-common-host-tailer-2b7np                   4/4     Running     0               42m
logging           systemd-common-host-tailer-2bdnf                   4/4     Running     0               42m
logging           systemd-common-host-tailer-2v5jm                   4/4     Running     0               42m
logging           systemd-common-host-tailer-4fd4x                   4/4     Running     0               42m
logging           systemd-common-host-tailer-4q2h2                   4/4     Running     0               42m
logging           systemd-common-host-tailer-5s6xk                   4/4     Running     0               42m
logging           systemd-common-host-tailer-6q86f                   4/4     Running     0               42m
logging           systemd-common-host-tailer-7tdfn                   4/4     Running     0               42m
logging           systemd-common-host-tailer-blqdv                   4/4     Running     0               42m
logging           systemd-common-host-tailer-bwtwn                   4/4     Running     0               42m
logging           systemd-common-host-tailer-cd4wr                   4/4     Running     0               42m
logging           systemd-common-host-tailer-gkvds                   4/4     Running     0               42m
logging           systemd-common-host-tailer-k4ntg                   4/4     Running     0               42m
logging           systemd-common-host-tailer-k9lpb                   4/4     Running     0               42m
logging           systemd-common-host-tailer-mvqzj                   4/4     Running     0               42m
logging           systemd-common-host-tailer-mwdjq                   4/4     Running     0               42m
logging           systemd-common-host-tailer-mx5qc                   4/4     Running     0               42m
logging           systemd-common-host-tailer-n2f9l                   4/4     Running     0               42m
logging           systemd-common-host-tailer-nmn56                   4/4     Running     0               42m
logging           systemd-common-host-tailer-pjpjh                   4/4     Running     0               42m
logging           systemd-common-host-tailer-qhsc2                   4/4     Running     0               42m
logging           systemd-common-host-tailer-thpzx                   4/4     Running     0               42m
logging           systemd-common-host-tailer-z6czd                   4/4     Running     0               42m
logging           systemd-common-host-tailer-zpfdb                   4/4     Running     0               42m
monitoring        alertmanager-main-0                                2/2     Running     0               42m
monitoring        blackbox-exporter-7fb7c77b45-77t6m                 3/3     Running     0               43m
monitoring        grafana-58f4d4f454-bf5lx                           3/3     Running     0               43m
monitoring        kube-proxy-metrics-2rtvp                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-5lns8                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-5qmbl                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-67s5g                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-8fqw2                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-9mvgc                           1/1     Running     0               43m
monitoring        kube-proxy-metrics-dhbp5                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-dk7wd                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-drcgj                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-dxss2                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-j87hz                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-l9gz9                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-lfxg6                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-q9qzb                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-tv54q                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-vnzqf                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-wd8xp                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-xp9xg                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-xvk4m                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-z2nkw                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-z7t78                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-z8qwf                           1/1     Running     0               42m
monitoring        kube-proxy-metrics-zswxt                           1/1     Running     0               43m
monitoring        kube-proxy-metrics-zx8hh                           1/1     Running     0               43m
monitoring        kube-state-metrics-86bd795f74-tkrw5                3/3     Running     0               43m
monitoring        node-exporter-27xp4                                2/2     Running     0               42m
monitoring        node-exporter-2j2kf                                2/2     Running     0               42m
monitoring        node-exporter-2ldgn                                2/2     Running     0               42m
monitoring        node-exporter-4jwkp                                2/2     Running     0               42m
monitoring        node-exporter-5vt6g                                2/2     Running     0               42m
monitoring        node-exporter-5xrjr                                2/2     Running     0               42m
monitoring        node-exporter-7g2nw                                2/2     Running     0               42m
monitoring        node-exporter-8qr4w                                2/2     Running     0               42m
monitoring        node-exporter-9kl79                                2/2     Running     0               42m
monitoring        node-exporter-crcrv                                2/2     Running     0               42m
monitoring        node-exporter-d8fpn                                2/2     Running     0               42m
monitoring        node-exporter-g8lrk                                2/2     Running     0               42m
monitoring        node-exporter-gvpv9                                2/2     Running     0               42m
monitoring        node-exporter-jvxqh                                2/2     Running     0               42m
monitoring        node-exporter-jw7tm                                2/2     Running     0               42m
monitoring        node-exporter-njhxv                                2/2     Running     0               42m
monitoring        node-exporter-ps7ff                                2/2     Running     0               42m
monitoring        node-exporter-pvrnd                                2/2     Running     0               42m
monitoring        node-exporter-qgvtg                                2/2     Running     0               42m
monitoring        node-exporter-rxh7s                                2/2     Running     0               42m
monitoring        node-exporter-t8zql                                2/2     Running     0               42m
monitoring        node-exporter-tdhfs                                2/2     Running     0               42m
monitoring        node-exporter-z2nf6                                2/2     Running     0               42m
monitoring        node-exporter-z4mrg                                2/2     Running     0               42m
monitoring        prometheus-adapter-6c95cb4488-zqtdn                1/1     Running     0               43m
monitoring        prometheus-k8s-0                                   2/2     Running     0               42m
monitoring        prometheus-operator-85cb5fd4c6-4fgsk               2/2     Running     0               43m
monitoring        x509-certificate-exporter-6fdf596cd-69h6r          1/1     Running     0               43m
monitoring        x509-certificate-exporter-data-plane-4r2jl         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-5cfkd         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-98nw2         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-d7p99         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-jk4ts         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-lr5v6         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-lvjgq         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-lzzwp         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-n8j45         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-nsv79         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-v8ntl         1/1     Running     0               42m
monitoring        x509-certificate-exporter-data-plane-vp9jq         1/1     Running     0               42m
tigera-operator   tigera-operator-d5b946745-4drbk                    1/1     Running     0               43m
```

## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.57.1](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.1))

And deploy a Sonobuoy pod to your cluster with:

#### If using linux

```bash
curl -LOs https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
tar -zxvf sonobuoy_0.57.1_linux_amd64.tar.gz
export KUBECONFIG=kubeconfig
./sonobuoy run --mode=certified-conformance
```

#### If using MacOS

```bash
curl -LOs https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_darwin_amd64.tar.gz
tar -zxvf sonobuoy_0.57.1_darwin_amd64.tar.gz
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
