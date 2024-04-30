# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.28.0 installed: https://github.com/sighupio/furyctl/releases/tag/v0.28.0 
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
  name: k8s-conformance-129
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.29.0-rc.1
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury
          keyPrefix: k8s-fury-1.29.0/
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
            bucketName: kfd-conformance-velero-129
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
NAME                                          STATUS   ROLES    AGE     VERSION
ip-10-150-0-221.eu-west-1.compute.internal    Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
ip-10-150-0-85.eu-west-1.compute.internal     Ready    <none>   6m41s   v1.29.0-eks-5e0fdde
ip-10-150-1-255.eu-west-1.compute.internal    Ready    <none>   6m40s   v1.29.0-eks-5e0fdde
ip-10-150-14-183.eu-west-1.compute.internal   Ready    <none>   6m38s   v1.29.0-eks-5e0fdde
ip-10-150-15-167.eu-west-1.compute.internal   Ready    <none>   6m38s   v1.29.0-eks-5e0fdde
ip-10-150-16-183.eu-west-1.compute.internal   Ready    <none>   6m37s   v1.29.0-eks-5e0fdde
ip-10-150-17-1.eu-west-1.compute.internal     Ready    <none>   6m39s   v1.29.0-eks-5e0fdde
ip-10-150-17-74.eu-west-1.compute.internal    Ready    <none>   6m35s   v1.29.0-eks-5e0fdde
ip-10-150-25-140.eu-west-1.compute.internal   Ready    <none>   6m40s   v1.29.0-eks-5e0fdde
ip-10-150-26-138.eu-west-1.compute.internal   Ready    <none>   6m34s   v1.29.0-eks-5e0fdde
ip-10-150-27-36.eu-west-1.compute.internal    Ready    <none>   6m34s   v1.29.0-eks-5e0fdde
ip-10-150-27-49.eu-west-1.compute.internal    Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
ip-10-150-31-219.eu-west-1.compute.internal   Ready    <none>   6m33s   v1.29.0-eks-5e0fdde
ip-10-150-34-149.eu-west-1.compute.internal   Ready    <none>   6m31s   v1.29.0-eks-5e0fdde
ip-10-150-35-114.eu-west-1.compute.internal   Ready    <none>   6m38s   v1.29.0-eks-5e0fdde
ip-10-150-35-200.eu-west-1.compute.internal   Ready    <none>   6m40s   v1.29.0-eks-5e0fdde
ip-10-150-37-119.eu-west-1.compute.internal   Ready    <none>   6m35s   v1.29.0-eks-5e0fdde
ip-10-150-37-6.eu-west-1.compute.internal     Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
ip-10-150-39-228.eu-west-1.compute.internal   Ready    <none>   6m37s   v1.29.0-eks-5e0fdde
ip-10-150-39-246.eu-west-1.compute.internal   Ready    <none>   6m38s   v1.29.0-eks-5e0fdde
ip-10-150-4-108.eu-west-1.compute.internal    Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
ip-10-150-4-132.eu-west-1.compute.internal    Ready    <none>   6m35s   v1.29.0-eks-5e0fdde
ip-10-150-4-54.eu-west-1.compute.internal     Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
ip-10-150-45-247.eu-west-1.compute.internal   Ready    <none>   6m36s   v1.29.0-eks-5e0fdde
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                               READY   STATUS      RESTARTS      AGE
calico-system     calico-kube-controllers-84d4f457f6-67nl9           1/1     Running     0             5m16s
calico-system     calico-node-2fppn                                  1/1     Running     0             5m16s
calico-system     calico-node-4q7lr                                  1/1     Running     0             5m17s
calico-system     calico-node-5gkkf                                  1/1     Running     0             5m16s
calico-system     calico-node-7tds6                                  1/1     Running     0             5m16s
calico-system     calico-node-8hxv9                                  1/1     Running     0             5m17s
calico-system     calico-node-bvwtl                                  1/1     Running     0             5m16s
calico-system     calico-node-cs9w6                                  1/1     Running     0             5m16s
calico-system     calico-node-hm6gq                                  1/1     Running     0             5m16s
calico-system     calico-node-jr2zw                                  1/1     Running     0             5m16s
calico-system     calico-node-mnfbg                                  1/1     Running     0             5m16s
calico-system     calico-node-qbkg4                                  1/1     Running     0             5m17s
calico-system     calico-node-qgg48                                  1/1     Running     0             5m16s
calico-system     calico-node-rkbzl                                  1/1     Running     0             5m16s
calico-system     calico-node-rxldp                                  1/1     Running     0             5m16s
calico-system     calico-node-s5q9v                                  1/1     Running     0             5m16s
calico-system     calico-node-shj4g                                  1/1     Running     0             5m16s
calico-system     calico-node-t7wvm                                  1/1     Running     0             5m16s
calico-system     calico-node-tlbqm                                  1/1     Running     0             5m16s
calico-system     calico-node-tpl4f                                  1/1     Running     0             5m16s
calico-system     calico-node-vms9n                                  1/1     Running     0             5m16s
calico-system     calico-node-vpqnh                                  1/1     Running     0             5m16s
calico-system     calico-node-w2pmv                                  1/1     Running     0             5m16s
calico-system     calico-node-xpfbj                                  1/1     Running     0             5m16s
calico-system     calico-node-zc5pc                                  1/1     Running     0             5m16s
calico-system     calico-typha-7cdf6c7d9-5gnwd                       1/1     Running     0             5m10s
calico-system     calico-typha-7cdf6c7d9-65b2d                       1/1     Running     0             5m10s
calico-system     calico-typha-7cdf6c7d9-qv6pk                       1/1     Running     0             5m17s
calico-system     csi-node-driver-2vsp9                              2/2     Running     0             5m16s
calico-system     csi-node-driver-4gwjv                              2/2     Running     0             5m15s
calico-system     csi-node-driver-4krqj                              2/2     Running     0             5m15s
calico-system     csi-node-driver-4sllh                              2/2     Running     0             5m16s
calico-system     csi-node-driver-4tbfh                              2/2     Running     0             5m15s
calico-system     csi-node-driver-8g6s4                              2/2     Running     0             5m15s
calico-system     csi-node-driver-9n596                              2/2     Running     0             5m16s
calico-system     csi-node-driver-b7fb4                              2/2     Running     0             5m15s
calico-system     csi-node-driver-djggd                              2/2     Running     0             5m15s
calico-system     csi-node-driver-j5zkh                              2/2     Running     0             5m16s
calico-system     csi-node-driver-jqrlg                              2/2     Running     0             5m16s
calico-system     csi-node-driver-lg882                              2/2     Running     0             5m16s
calico-system     csi-node-driver-p6244                              2/2     Running     0             5m16s
calico-system     csi-node-driver-rn7sh                              2/2     Running     0             5m15s
calico-system     csi-node-driver-stnkd                              2/2     Running     0             5m15s
calico-system     csi-node-driver-tfxh4                              2/2     Running     0             5m15s
calico-system     csi-node-driver-txw7f                              2/2     Running     0             5m16s
calico-system     csi-node-driver-v2fgg                              2/2     Running     0             5m16s
calico-system     csi-node-driver-v6bkv                              2/2     Running     0             5m15s
calico-system     csi-node-driver-vmjh2                              2/2     Running     0             5m15s
calico-system     csi-node-driver-wm6m6                              2/2     Running     0             5m15s
calico-system     csi-node-driver-zcztk                              2/2     Running     0             5m16s
calico-system     csi-node-driver-zf7w2                              2/2     Running     0             5m16s
calico-system     csi-node-driver-zm6tb                              2/2     Running     0             5m15s
cert-manager      cert-manager-76c46d8584-shwb6                      1/1     Running     0             6m2s
cert-manager      cert-manager-cainjector-6dcd56d446-blshk           1/1     Running     0             6m2s
cert-manager      cert-manager-webhook-85dd948746-hwbtq              1/1     Running     0             6m2s
ingress-nginx     external-dns-private-68f697cdc4-zzlsj              1/1     Running     4 (51s ago)   6m2s
ingress-nginx     external-dns-public-f47867f48-z72xs                1/1     Running     4 (47s ago)   6m2s
ingress-nginx     forecastle-c6786b695-wpm7w                         1/1     Running     0             6m2s
ingress-nginx     nginx-ingress-controller-external-445k8            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-external-6kr58            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-external-7j2hf            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-external-pjh4f            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-external-rz7wt            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-external-xlq9d            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-internal-8dkwf            1/1     Running     0             5m59s
ingress-nginx     nginx-ingress-controller-internal-cx6rt            1/1     Running     0             5m59s
ingress-nginx     nginx-ingress-controller-internal-gt69w            1/1     Running     0             5m59s
ingress-nginx     nginx-ingress-controller-internal-jfhlf            1/1     Running     0             5m59s
ingress-nginx     nginx-ingress-controller-internal-s65nj            1/1     Running     0             6m
ingress-nginx     nginx-ingress-controller-internal-zg469            1/1     Running     0             6m
kube-system       aws-load-balancer-controller-5489596848-7fj69      1/1     Running     0             6m1s
kube-system       aws-node-259rl                                     2/2     Running     0             8m19s
kube-system       aws-node-4f9mq                                     2/2     Running     0             8m15s
kube-system       aws-node-4nsjn                                     2/2     Running     0             8m19s
kube-system       aws-node-5h4x4                                     2/2     Running     0             8m14s
kube-system       aws-node-72hd2                                     2/2     Running     0             8m18s
kube-system       aws-node-7b7xs                                     2/2     Running     0             8m21s
kube-system       aws-node-8nmrk                                     2/2     Running     0             8m20s
kube-system       aws-node-ccq8g                                     2/2     Running     0             8m19s
kube-system       aws-node-cgwdd                                     2/2     Running     0             8m8s
kube-system       aws-node-dg8p5                                     2/2     Running     0             8m20s
kube-system       aws-node-dxzr7                                     2/2     Running     0             8m14s
kube-system       aws-node-gbmmp                                     2/2     Running     0             8m13s
kube-system       aws-node-ngp7h                                     2/2     Running     0             8m18s
kube-system       aws-node-q75nk                                     2/2     Running     0             8m18s
kube-system       aws-node-qr994                                     2/2     Running     0             8m19s
kube-system       aws-node-r4v45                                     2/2     Running     0             8m12s
kube-system       aws-node-r8bqv                                     2/2     Running     0             8m16s
kube-system       aws-node-sls6s                                     2/2     Running     0             8m11s
kube-system       aws-node-t55j2                                     2/2     Running     0             8m8s
kube-system       aws-node-t9tlp                                     2/2     Running     0             8m14s
kube-system       aws-node-termination-handler-5fl99                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-5g8nt                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-5pqns                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-5qbxf                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-6l926                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-6qw22                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-8zlqp                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-c99kq                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-dfvj9                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-fkbz7                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-gm892                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-j7lq5                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-kkdpz                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-kvmgn                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-lskdc                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-mmwlj                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-nh7qc                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-r8sz8                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-sf8qk                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-t97rv                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-v5sbw                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-vb7vb                 1/1     Running     0             5m58s
kube-system       aws-node-termination-handler-xq27k                 1/1     Running     0             5m59s
kube-system       aws-node-termination-handler-zf4qs                 1/1     Running     0             5m59s
kube-system       aws-node-txl55                                     2/2     Running     0             8m17s
kube-system       aws-node-wvk6m                                     2/2     Running     0             8m19s
kube-system       aws-node-xrp88                                     2/2     Running     0             8m18s
kube-system       aws-node-zsw8c                                     2/2     Running     0             8m17s
kube-system       cluster-autoscaler-7bc6c5f8f9-wfkfk                1/1     Running     0             6m1s
kube-system       coredns-9b4b8d69c-nh22c                            1/1     Running     0             8m28s
kube-system       coredns-9b4b8d69c-xnpms                            1/1     Running     0             8m28s
kube-system       ebs-csi-controller-5fd5db97fb-8p5wq                6/6     Running     0             8m24s
kube-system       ebs-csi-controller-5fd5db97fb-gkh4g                6/6     Running     0             8m24s
kube-system       ebs-csi-node-2hvdz                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-4b4fd                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-4j667                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-4t2jl                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-5fhlm                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-5s8v4                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-6xrbt                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-7llq4                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-7pcs4                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-88mv2                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-cqlb7                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-dgwnr                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-fcd46                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-hrcbk                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-hsw7j                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-lld49                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-lxmkk                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-nskpz                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-qj62x                                 3/3     Running     0             8m24s
kube-system       ebs-csi-node-tz4p2                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-tzzts                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-w9ns4                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-wlgdg                                 3/3     Running     0             8m25s
kube-system       ebs-csi-node-zj5bk                                 3/3     Running     0             8m24s
kube-system       kube-proxy-24xj4                                   1/1     Running     0             8m25s
kube-system       kube-proxy-2r6xv                                   1/1     Running     0             7m46s
kube-system       kube-proxy-59df6                                   1/1     Running     0             8m4s
kube-system       kube-proxy-76hnr                                   1/1     Running     0             7m48s
kube-system       kube-proxy-8jtjk                                   1/1     Running     0             8m22s
kube-system       kube-proxy-b652p                                   1/1     Running     0             7m42s
kube-system       kube-proxy-bn5cd                                   1/1     Running     0             7m42s
kube-system       kube-proxy-cvvs7                                   1/1     Running     0             8m20s
kube-system       kube-proxy-fjk9d                                   1/1     Running     0             8m6s
kube-system       kube-proxy-h6rkl                                   1/1     Running     0             8m13s
kube-system       kube-proxy-j29l7                                   1/1     Running     0             8m1s
kube-system       kube-proxy-lh5j7                                   1/1     Running     0             8m7s
kube-system       kube-proxy-mt4tx                                   1/1     Running     0             7m55s
kube-system       kube-proxy-sf7zl                                   1/1     Running     0             8m11s
kube-system       kube-proxy-smflm                                   1/1     Running     0             7m53s
kube-system       kube-proxy-t28sn                                   1/1     Running     0             8m9s
kube-system       kube-proxy-t7znn                                   1/1     Running     0             7m55s
kube-system       kube-proxy-tq5vm                                   1/1     Running     0             8m3s
kube-system       kube-proxy-trl62                                   1/1     Running     0             8m
kube-system       kube-proxy-tz82l                                   1/1     Running     0             8m18s
kube-system       kube-proxy-xlzgb                                   1/1     Running     0             7m58s
kube-system       kube-proxy-xmcj2                                   1/1     Running     0             7m43s
kube-system       kube-proxy-z72vs                                   1/1     Running     0             7m50s
kube-system       kube-proxy-zch2t                                   1/1     Running     0             7m51s
kube-system       snapshot-controller-8659758d48-z8zn7               1/1     Running     0             6m1s
kube-system       velero-66b55fffd6-c7f9t                            1/1     Running     0             6m1s
logging           infra-fluentbit-4568t                              1/1     Running     0             5m9s
logging           infra-fluentbit-6srwc                              1/1     Running     0             5m9s
logging           infra-fluentbit-6tbgl                              1/1     Running     0             5m9s
logging           infra-fluentbit-blq2l                              1/1     Running     0             5m9s
logging           infra-fluentbit-dsjxn                              1/1     Running     0             5m9s
logging           infra-fluentbit-fdkxj                              1/1     Running     0             5m9s
logging           infra-fluentbit-fp2dv                              1/1     Running     0             5m9s
logging           infra-fluentbit-g6nsb                              1/1     Running     0             5m9s
logging           infra-fluentbit-hgqxr                              1/1     Running     0             5m9s
logging           infra-fluentbit-jkfng                              1/1     Running     0             5m9s
logging           infra-fluentbit-kqg9t                              1/1     Running     0             5m9s
logging           infra-fluentbit-kx7zc                              1/1     Running     0             5m9s
logging           infra-fluentbit-nkhfb                              1/1     Running     0             5m9s
logging           infra-fluentbit-pdgjn                              1/1     Running     0             5m9s
logging           infra-fluentbit-pvmrf                              1/1     Running     0             5m9s
logging           infra-fluentbit-rmmdz                              1/1     Running     0             5m9s
logging           infra-fluentbit-sb5xh                              1/1     Running     0             5m9s
logging           infra-fluentbit-svrk6                              1/1     Running     0             5m9s
logging           infra-fluentbit-t9scn                              1/1     Running     0             5m9s
logging           infra-fluentbit-t9xxr                              1/1     Running     0             5m9s
logging           infra-fluentbit-vrn4z                              1/1     Running     0             5m9s
logging           infra-fluentbit-w8xpf                              1/1     Running     0             5m9s
logging           infra-fluentbit-wt7wv                              1/1     Running     0             5m9s
logging           infra-fluentbit-xwhnw                              1/1     Running     0             5m9s
logging           infra-fluentd-0                                    2/2     Running     0             5m32s
logging           infra-fluentd-1                                    2/2     Running     0             5m10s
logging           infra-fluentd-configcheck-a6ee17e7                 0/1     Completed   0             5m53s
logging           kubernetes-event-tailer-0                          1/1     Running     0             5m54s
logging           logging-operator-5484b79c5-8ghhs                   1/1     Running     0             6m1s
logging           loki-distributed-compactor-66bd57c7b6-ldb5z        1/1     Running     0             6m1s
logging           loki-distributed-distributor-c865b5f89-8hzzg       1/1     Running     0             6m
logging           loki-distributed-gateway-86555d4476-q9b66          1/1     Running     0             6m
logging           loki-distributed-ingester-0                        1/1     Running     0             6m
logging           loki-distributed-querier-0                         1/1     Running     0             6m
logging           loki-distributed-query-frontend-794b5bf96f-79hd7   1/1     Running     0             6m
logging           minio-logging-0                                    1/1     Running     0             6m
logging           minio-logging-1                                    1/1     Running     0             6m
logging           minio-logging-2                                    1/1     Running     0             6m
logging           minio-logging-buckets-setup-5r25k                  0/1     Completed   2             5m58s
logging           systemd-common-host-tailer-2m6vt                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-2rdjq                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-8zffr                   4/4     Running     0             5m54s
logging           systemd-common-host-tailer-8zwvn                   4/4     Running     0             5m52s
logging           systemd-common-host-tailer-97kn5                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-9ffxs                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-9jr7c                   4/4     Running     0             5m54s
logging           systemd-common-host-tailer-cxxt5                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-fglt4                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-fkk9c                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-jzz4x                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-kcfs8                   4/4     Running     0             5m54s
logging           systemd-common-host-tailer-lwxbt                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-mgnn9                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-mx7zh                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-n7b89                   4/4     Running     0             5m54s
logging           systemd-common-host-tailer-ngwvj                   4/4     Running     0             5m52s
logging           systemd-common-host-tailer-p9vjn                   4/4     Running     0             5m52s
logging           systemd-common-host-tailer-qb8j5                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-r6vqw                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-rzjp2                   4/4     Running     0             5m52s
logging           systemd-common-host-tailer-w6qps                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-xbzz5                   4/4     Running     0             5m53s
logging           systemd-common-host-tailer-xjgd2                   4/4     Running     0             5m54s
monitoring        alertmanager-main-0                                2/2     Running     0             5m53s
monitoring        blackbox-exporter-7fb7c77b45-99ztd                 3/3     Running     0             6m
monitoring        grafana-58f4d4f454-zwgx7                           3/3     Running     0             5m59s
monitoring        kube-proxy-metrics-27bqt                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-4cxb8                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-7bbzv                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-7gc26                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-7q25n                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-85vv9                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-bxd9q                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-d59w9                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-dd7mq                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-g7nml                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-jmqm9                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-jt9m9                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-m7vg5                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-n5g89                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-p5z2l                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-q7jvn                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-qdp5l                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-rbzhw                           1/1     Running     0             5m58s
monitoring        kube-proxy-metrics-rr2tq                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-vm587                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-wsbl6                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-wsm5l                           1/1     Running     0             5m59s
monitoring        kube-proxy-metrics-zff8d                           1/1     Running     0             5m57s
monitoring        kube-proxy-metrics-zgx2m                           1/1     Running     0             5m59s
monitoring        kube-state-metrics-86bd795f74-jm9r5                3/3     Running     0             5m59s
monitoring        node-exporter-4jsfs                                2/2     Running     0             5m55s
monitoring        node-exporter-6f5sh                                2/2     Running     0             5m55s
monitoring        node-exporter-6h2m7                                2/2     Running     0             5m55s
monitoring        node-exporter-7r24b                                2/2     Running     0             5m56s
monitoring        node-exporter-8kn78                                2/2     Running     0             5m56s
monitoring        node-exporter-99btj                                2/2     Running     0             5m55s
monitoring        node-exporter-dxl99                                2/2     Running     0             5m56s
monitoring        node-exporter-fg8r2                                2/2     Running     0             5m55s
monitoring        node-exporter-fwmbj                                2/2     Running     0             5m56s
monitoring        node-exporter-gx7z8                                2/2     Running     0             5m56s
monitoring        node-exporter-lfww2                                2/2     Running     0             5m57s
monitoring        node-exporter-lz9wf                                2/2     Running     0             5m56s
monitoring        node-exporter-mq45g                                2/2     Running     0             5m56s
monitoring        node-exporter-mqjpz                                2/2     Running     0             5m56s
monitoring        node-exporter-mx74l                                2/2     Running     0             5m56s
monitoring        node-exporter-nc7sj                                2/2     Running     0             5m55s
monitoring        node-exporter-pgcfv                                2/2     Running     0             5m55s
monitoring        node-exporter-pq8kt                                2/2     Running     0             5m55s
monitoring        node-exporter-svm5h                                2/2     Running     0             5m55s
monitoring        node-exporter-tbzvn                                2/2     Running     0             5m56s
monitoring        node-exporter-tmvkq                                2/2     Running     0             5m56s
monitoring        node-exporter-v2kdj                                2/2     Running     0             5m56s
monitoring        node-exporter-vhkzc                                2/2     Running     0             5m56s
monitoring        node-exporter-zf4ct                                2/2     Running     0             5m56s
monitoring        prometheus-adapter-6c95cb4488-6sk78                1/1     Running     0             5m59s
monitoring        prometheus-k8s-0                                   2/2     Running     0             5m7s
monitoring        prometheus-operator-85cb5fd4c6-nxpqk               2/2     Running     0             5m59s
monitoring        x509-certificate-exporter-6fdf596cd-bwgjj          1/1     Running     0             5m59s
monitoring        x509-certificate-exporter-data-plane-5d628         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-5djqz         1/1     Running     0             5m54s
monitoring        x509-certificate-exporter-data-plane-8shtm         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-gtmj5         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-gzjqw         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-hqlcr         1/1     Running     0             5m54s
monitoring        x509-certificate-exporter-data-plane-jr5h4         1/1     Running     0             5m56s
monitoring        x509-certificate-exporter-data-plane-kd9xv         1/1     Running     0             5m56s
monitoring        x509-certificate-exporter-data-plane-qvtxs         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-t59n4         1/1     Running     0             5m55s
monitoring        x509-certificate-exporter-data-plane-x5gms         1/1     Running     0             5m56s
monitoring        x509-certificate-exporter-data-plane-x7pxt         1/1     Running     0             5m55s
tigera-operator   tigera-operator-5965d7b49-rq9lc                    1/1     Running     0             5m58s
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
