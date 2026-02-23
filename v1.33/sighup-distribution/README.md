# Conformance tests for SIGHUP Distribution

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.33.0 installed: https://github.com/sighupio/furyctl/releases/tag/v0.33.0
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
  name: k8s-conformance-133
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.33.0
  toolsConfiguration:
    terraform:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury-133
          keyPrefix: k8s-fury-1.33.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-133"
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
    nodePoolGlobalAmiType: "alinux2023"
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
        type: prometheus
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
            bucketName: kfd-conformance-velero-133
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
INFO Generating VPN client certificate...
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
NAME                                          STATUS   ROLES    AGE     VERSION               ROLE
ip-10-150-15-39.eu-west-1.compute.internal    Ready    <none>   8m52s   v1.33.5-eks-113cf36   infra
ip-10-150-17-105.eu-west-1.compute.internal   Ready    <none>   8m50s   v1.33.5-eks-113cf36   ingress
ip-10-150-20-97.eu-west-1.compute.internal    Ready    <none>   8m51s   v1.33.5-eks-113cf36   infra
ip-10-150-22-157.eu-west-1.compute.internal   Ready    <none>   8m53s   v1.33.5-eks-113cf36   infra
ip-10-150-31-100.eu-west-1.compute.internal   Ready    <none>   8m52s   v1.33.5-eks-113cf36   worker
ip-10-150-32-230.eu-west-1.compute.internal   Ready    <none>   8m46s   v1.33.5-eks-113cf36   ingress
ip-10-150-36-154.eu-west-1.compute.internal   Ready    <none>   8m53s   v1.33.5-eks-113cf36   worker
ip-10-150-4-84.eu-west-1.compute.internal     Ready    <none>   8m46s   v1.33.5-eks-113cf36   worker
ip-10-150-43-168.eu-west-1.compute.internal   Ready    <none>   8m53s   v1.33.5-eks-113cf36   infra
ip-10-150-46-21.eu-west-1.compute.internal    Ready    <none>   8m50s   v1.33.5-eks-113cf36   infra
ip-10-150-6-181.eu-west-1.compute.internal    Ready    <none>   8m51s   v1.33.5-eks-113cf36   ingress
ip-10-150-6-249.eu-west-1.compute.internal    Ready    <none>   8m53s   v1.33.5-eks-113cf36   infra
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
calico-system     calico-kube-controllers-64c65786fd-xf4tf            1/1     Running     0               5m57s
calico-system     calico-node-227zd                                   1/1     Running     0               5m57s
calico-system     calico-node-97dvb                                   1/1     Running     0               5m57s
calico-system     calico-node-fsjbs                                   1/1     Running     0               5m58s
calico-system     calico-node-ft2n7                                   1/1     Running     0               5m58s
calico-system     calico-node-fzt2n                                   1/1     Running     0               5m57s
calico-system     calico-node-gxzcq                                   1/1     Running     0               5m57s
calico-system     calico-node-mcxhg                                   1/1     Running     0               5m57s
calico-system     calico-node-n8bn8                                   1/1     Running     0               5m57s
calico-system     calico-node-rkxhk                                   1/1     Running     0               5m57s
calico-system     calico-node-sp8gl                                   1/1     Running     0               5m57s
calico-system     calico-node-w8xc5                                   1/1     Running     0               5m58s
calico-system     calico-node-x7hh6                                   1/1     Running     0               5m57s
calico-system     calico-typha-5b64b6d77b-fmgxw                       1/1     Running     0               5m50s
calico-system     calico-typha-5b64b6d77b-nhfzm                       1/1     Running     0               5m58s
calico-system     calico-typha-5b64b6d77b-td6hk                       1/1     Running     0               5m51s
calico-system     csi-node-driver-27b78                               2/2     Running     0               5m57s
calico-system     csi-node-driver-8qh6w                               2/2     Running     0               5m58s
calico-system     csi-node-driver-f28hz                               2/2     Running     0               5m57s
calico-system     csi-node-driver-grs76                               2/2     Running     0               5m57s
calico-system     csi-node-driver-kj7wn                               2/2     Running     0               5m57s
calico-system     csi-node-driver-l9lpn                               2/2     Running     0               5m57s
calico-system     csi-node-driver-mkltv                               2/2     Running     0               5m57s
calico-system     csi-node-driver-nmfj5                               2/2     Running     0               5m57s
calico-system     csi-node-driver-r4lfs                               2/2     Running     0               5m57s
calico-system     csi-node-driver-rjl79                               2/2     Running     0               5m57s
calico-system     csi-node-driver-wp26l                               2/2     Running     0               5m57s
calico-system     csi-node-driver-zglbk                               2/2     Running     0               5m57s
cert-manager      cert-manager-777db8ddc6-6wp85                       1/1     Running     0               6m7s
cert-manager      cert-manager-cainjector-754d5bf7b4-g74lr            1/1     Running     0               6m7s
cert-manager      cert-manager-webhook-5ff47684b6-kqcvn               1/1     Running     0               6m7s
ingress-nginx     external-dns-private-7b64447d7b-dslzj               1/1     Running     0               6m7s
ingress-nginx     external-dns-public-5bcb946cb7-cks6g                1/1     Running     0               6m7s
ingress-nginx     forecastle-848d5d4f67-5d2qw                         1/1     Running     0               6m7s
ingress-nginx     ingress-nginx-controller-external-lc24q             1/1     Running     0               6m2s
ingress-nginx     ingress-nginx-controller-external-p24nw             1/1     Running     0               6m2s
ingress-nginx     ingress-nginx-controller-external-tp2vg             1/1     Running     0               6m2s
ingress-nginx     ingress-nginx-controller-internal-2jckn             1/1     Running     0               6m3s
ingress-nginx     ingress-nginx-controller-internal-fzxcn             1/1     Running     0               6m2s
ingress-nginx     ingress-nginx-controller-internal-nm4bb             1/1     Running     0               6m2s
kube-system       aws-load-balancer-controller-68bfb7dc6b-5s8fk       1/1     Running     0               6m4s
kube-system       aws-node-4znv6                                      2/2     Running     0               8m24s
kube-system       aws-node-5vq65                                      2/2     Running     0               8m34s
kube-system       aws-node-9fqm6                                      2/2     Running     0               8m19s
kube-system       aws-node-d2pqc                                      2/2     Running     0               8m14s
kube-system       aws-node-f6tgj                                      2/2     Running     0               8m23s
kube-system       aws-node-ggzvh                                      2/2     Running     0               8m40s
kube-system       aws-node-gxgnp                                      2/2     Running     0               8m11s
kube-system       aws-node-jwshs                                      2/2     Running     0               8m27s
kube-system       aws-node-khfjj                                      2/2     Running     0               8m15s
kube-system       aws-node-lxsgs                                      2/2     Running     0               8m42s
kube-system       aws-node-ppnpt                                      2/2     Running     0               8m36s
kube-system       aws-node-r5zwn                                      2/2     Running     0               8m20s
kube-system       aws-node-termination-handler-5xqmq                  1/1     Running     0               6m4s
kube-system       aws-node-termination-handler-87wn5                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-8rxdj                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-9p8xr                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-cfjh9                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-cfls6                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-dqzqh                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-f65v8                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-qqd9h                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-sbfjw                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-vblfx                  1/1     Running     0               6m3s
kube-system       aws-node-termination-handler-vvgmk                  1/1     Running     0               6m3s
kube-system       cluster-autoscaler-6cb9b9f676-dc7lw                 1/1     Running     0               6m6s
kube-system       coredns-7d6f4d5d4f-4f8sb                            1/1     Running     0               8m44s
kube-system       coredns-7d6f4d5d4f-zlz2z                            1/1     Running     0               8m43s
kube-system       ebs-csi-controller-f4956b75c-69lrr                  6/6     Running     0               8m40s
kube-system       ebs-csi-controller-f4956b75c-jw2vz                  6/6     Running     0               8m40s
kube-system       ebs-csi-node-989vk                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-n9kfx                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-nljz5                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-nr6l4                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-p5fsc                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-p7bcl                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-p9r7l                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-pqtp6                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-r7p48                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-vc87n                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-x9vhj                                  3/3     Running     0               8m40s
kube-system       ebs-csi-node-z6lcw                                  3/3     Running     0               8m40s
kube-system       kube-proxy-8h6fm                                    1/1     Running     0               8m26s
kube-system       kube-proxy-8xrhh                                    1/1     Running     0               8m42s
kube-system       kube-proxy-9bszc                                    1/1     Running     0               8m20s
kube-system       kube-proxy-hh5vd                                    1/1     Running     0               8m32s
kube-system       kube-proxy-hm4zv                                    1/1     Running     0               8m21s
kube-system       kube-proxy-nwv28                                    1/1     Running     0               8m36s
kube-system       kube-proxy-qjdzx                                    1/1     Running     0               8m26s
kube-system       kube-proxy-shmmg                                    1/1     Running     0               8m18s
kube-system       kube-proxy-vz65m                                    1/1     Running     0               8m16s
kube-system       kube-proxy-w49kr                                    1/1     Running     0               8m36s
kube-system       kube-proxy-w9wl2                                    1/1     Running     0               8m42s
kube-system       kube-proxy-wnvdq                                    1/1     Running     0               8m16s
kube-system       node-agent-72xtf                                    1/1     Running     0               6m4s
kube-system       node-agent-8gdq4                                    1/1     Running     0               6m4s
kube-system       node-agent-bgl2r                                    1/1     Running     0               6m4s
kube-system       node-agent-dgrw2                                    1/1     Running     0               6m5s
kube-system       node-agent-klxng                                    1/1     Running     0               6m5s
kube-system       node-agent-lkgmq                                    1/1     Running     0               6m4s
kube-system       node-agent-n6znq                                    1/1     Running     0               6m5s
kube-system       node-agent-plx7w                                    1/1     Running     0               6m4s
kube-system       node-agent-sfhxt                                    1/1     Running     0               6m6s
kube-system       node-agent-tjllp                                    1/1     Running     0               6m6s
kube-system       node-agent-wt5m4                                    1/1     Running     0               6m5s
kube-system       node-agent-xxt6n                                    1/1     Running     0               6m5s
kube-system       snapshot-controller-697d4f44fb-d4tj4                1/1     Running     0               8m41s
kube-system       snapshot-controller-697d4f44fb-g8rm4                1/1     Running     0               8m41s
kube-system       velero-85686b5784-28n88                             1/1     Running     0               6m5s
logging           infra-fluentbit-2lrtf                               1/1     Running     0               5m37s
logging           infra-fluentbit-47w9v                               1/1     Running     0               5m37s
logging           infra-fluentbit-6sxdp                               1/1     Running     0               5m37s
logging           infra-fluentbit-8z68v                               1/1     Running     0               5m37s
logging           infra-fluentbit-9g5nf                               1/1     Running     0               5m37s
logging           infra-fluentbit-k5nr9                               1/1     Running     0               5m37s
logging           infra-fluentbit-r6x6p                               1/1     Running     0               5m37s
logging           infra-fluentbit-rrtl6                               1/1     Running     0               5m37s
logging           infra-fluentbit-vbcrv                               1/1     Running     0               5m37s
logging           infra-fluentbit-vqr8w                               1/1     Running     0               5m37s
logging           infra-fluentbit-wx55t                               1/1     Running     0               5m37s
logging           infra-fluentbit-z4tp6                               1/1     Running     0               5m37s
logging           infra-fluentd-0                                     2/2     Running     0               5m37s
logging           infra-fluentd-1                                     2/2     Running     0               5m21s
logging           infra-fluentd-configcheck-9491fd7d                  0/1     Completed   0               6m1s
logging           kubernetes-event-tailer-0                           1/1     Running     0               6m4s
logging           logging-operator-bc6c7db64-d7ntl                    1/1     Running     0               6m11s
logging           loki-distributed-compactor-0                        1/1     Running     2 (5m37s ago)   6m6s
logging           loki-distributed-distributor-b7fd57cf9-t4q8d        1/1     Running     0               6m10s
logging           loki-distributed-gateway-55cfbf8767-vvg7h           1/1     Running     0               6m10s
logging           loki-distributed-index-gateway-0                    1/1     Running     0               6m6s
logging           loki-distributed-ingester-0                         1/1     Running     0               6m6s
logging           loki-distributed-querier-5bf5d48b97-c86v5           1/1     Running     0               6m10s
logging           loki-distributed-query-frontend-558b765c7f-cxnhv    1/1     Running     0               6m10s
logging           loki-distributed-query-scheduler-54c469fc46-mm5jx   1/1     Running     0               6m10s
logging           minio-logging-0                                     1/1     Running     0               6m6s
logging           minio-logging-1                                     1/1     Running     0               6m5s
logging           minio-logging-2                                     1/1     Running     0               6m5s
logging           minio-logging-buckets-setup-6ndhd                   0/1     Completed   0               6m6s
logging           systemd-common-host-tailer-4bz7d                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-4fvgs                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-8xjfz                    4/4     Running     0               6m2s
logging           systemd-common-host-tailer-btz87                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-g67j2                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-jgqf5                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-jltgc                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-lbl6c                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-q9xfn                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-qvsm9                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-vj67h                    4/4     Running     0               6m1s
logging           systemd-common-host-tailer-wcfsq                    4/4     Running     0               6m1s
monitoring        alertmanager-main-0                                 2/2     Running     0               5m55s
monitoring        blackbox-exporter-dfc99fcbc-dz6tq                   3/3     Running     0               6m10s
monitoring        grafana-674c4c5c57-jjrxz                            3/3     Running     0               6m5s
monitoring        kube-proxy-metrics-4f9hb                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-85bkf                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-ckg74                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-gthvn                            1/1     Running     0               6m5s
monitoring        kube-proxy-metrics-mp5tl                            1/1     Running     0               6m5s
monitoring        kube-proxy-metrics-pqctk                            1/1     Running     0               6m5s
monitoring        kube-proxy-metrics-qrhrc                            1/1     Running     0               6m5s
monitoring        kube-proxy-metrics-vg8pj                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-vx2wz                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-x75jm                            1/1     Running     0               6m6s
monitoring        kube-proxy-metrics-z85q5                            1/1     Running     0               6m5s
monitoring        kube-proxy-metrics-zxlwl                            1/1     Running     0               6m6s
monitoring        kube-state-metrics-ffd9b4f7f-t5zwg                  3/3     Running     0               6m7s
monitoring        node-exporter-2v667                                 2/2     Running     0               6m3s
monitoring        node-exporter-8qxwb                                 2/2     Running     0               6m4s
monitoring        node-exporter-b7xlb                                 2/2     Running     0               6m4s
monitoring        node-exporter-bt9sd                                 2/2     Running     0               6m4s
monitoring        node-exporter-cmmff                                 2/2     Running     0               6m4s
monitoring        node-exporter-gnf7k                                 2/2     Running     0               6m4s
monitoring        node-exporter-h25kn                                 2/2     Running     0               6m4s
monitoring        node-exporter-hms9v                                 2/2     Running     0               6m4s
monitoring        node-exporter-kbwn6                                 2/2     Running     0               6m4s
monitoring        node-exporter-lp4nr                                 2/2     Running     0               6m3s
monitoring        node-exporter-szpff                                 2/2     Running     0               6m4s
monitoring        node-exporter-t2n77                                 2/2     Running     0               6m4s
monitoring        prometheus-adapter-59fb457fdd-4vhg9                 1/1     Running     0               6m6s
monitoring        prometheus-k8s-0                                    2/2     Running     0               5m55s
monitoring        prometheus-operator-78dbb887b7-4w55m                2/2     Running     0               6m7s
monitoring        x509-certificate-exporter-555d4d7b57-xp8cc          1/1     Running     0               6m6s
tigera-operator   tigera-operator-dd7d9f675-qnl5z                     1/1     Running     0               6m6s
```

## Run conformance tests

> Install requirements and run commands:

Dowload Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
