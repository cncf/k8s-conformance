# Conformance tests for SIGHUP Distribution

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.35.0 installed: https://github.com/sighupio/furyctl/releases/tag/v0.35.0
- AWS requirments:
  - Administrator AWS Credentials.
  - An existing bucket on AWS to store opentofu states

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
  name: k8s-conformance-135
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.35.0
  toolsConfiguration:
    opentofu:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-fury2-135
          keyPrefix: k8s-fury-1.35.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance2-135"
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
        - stefanoghinelli
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
          type: none
        haproxy:
          overrides:
            nodeSelector:
              node.kubernetes.io/role: ingress
          type: dual
          tls:
            provider: certManager
        certManager:
          clusterIssuer:
            name: letsencrypt-fury
            email: stefano.ghinelli@sighup.io
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
            bucketName: kfd-conformance-velero2-135
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
INFO Tools ready (8 installed via mise)
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
NAME                                          STATUS   ROLES    AGE   VERSION               ROLE
ip-10-150-1-101.eu-west-1.compute.internal    Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-11-187.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-17-23.eu-west-1.compute.internal    Ready    <none>   10m   v1.35.6-eks-8f14419   ingress
ip-10-150-19-203.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-23-162.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-26-164.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   worker
ip-10-150-41-113.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   ingress
ip-10-150-46-104.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-46-123.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   worker
ip-10-150-46-194.eu-west-1.compute.internal   Ready    <none>   10m   v1.35.6-eks-8f14419   infra
ip-10-150-7-164.eu-west-1.compute.internal    Ready    <none>   10m   v1.35.6-eks-8f14419   worker
ip-10-150-9-139.eu-west-1.compute.internal    Ready    <none>   10m   v1.35.6-eks-8f14419   ingress
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                                READY   STATUS      RESTARTS       AGE
calico-system     calico-kube-controllers-54c5d4c64-5h8lz             1/1     Running     0              7m31s
calico-system     calico-node-4rc2p                                   1/1     Running     0              7m31s
calico-system     calico-node-5sc2n                                   1/1     Running     0              7m30s
calico-system     calico-node-c4l2d                                   1/1     Running     0              7m29s
calico-system     calico-node-fbk6k                                   1/1     Running     0              7m31s
calico-system     calico-node-mgsl5                                   1/1     Running     0              7m29s
calico-system     calico-node-mpg9s                                   1/1     Running     0              7m31s
calico-system     calico-node-ngr92                                   1/1     Running     0              7m31s
calico-system     calico-node-pmgvd                                   1/1     Running     0              7m32s
calico-system     calico-node-rxlkn                                   1/1     Running     0              7m32s
calico-system     calico-node-t5bj9                                   1/1     Running     0              7m30s
calico-system     calico-node-wjvsc                                   1/1     Running     0              7m32s
calico-system     calico-node-xd7fl                                   1/1     Running     0              7m29s
calico-system     calico-typha-795cbd8f95-4s2nl                       1/1     Running     0              7m32s
calico-system     calico-typha-795cbd8f95-b5wmh                       1/1     Running     0              7m26s
calico-system     calico-typha-795cbd8f95-pctzw                       1/1     Running     0              7m26s
calico-system     csi-node-driver-2gl85                               2/2     Running     0              7m29s
calico-system     csi-node-driver-42pns                               2/2     Running     0              7m32s
calico-system     csi-node-driver-7nglj                               2/2     Running     0              7m30s
calico-system     csi-node-driver-975t2                               2/2     Running     0              7m31s
calico-system     csi-node-driver-9qcqq                               2/2     Running     0              7m29s
calico-system     csi-node-driver-fpqvn                               2/2     Running     0              7m29s
calico-system     csi-node-driver-k9w4t                               2/2     Running     0              7m31s
calico-system     csi-node-driver-nrm7k                               2/2     Running     0              7m30s
calico-system     csi-node-driver-nrvmf                               2/2     Running     0              7m29s
calico-system     csi-node-driver-nst8f                               2/2     Running     0              7m29s
calico-system     csi-node-driver-ppmcf                               2/2     Running     0              7m30s
calico-system     csi-node-driver-rbh8m                               2/2     Running     0              7m30s
cert-manager      cert-manager-9b78fcdf4-vzp2t                        1/1     Running     0              7m54s
cert-manager      cert-manager-cainjector-666b6f445-q5xtn             1/1     Running     0              7m54s
cert-manager      cert-manager-webhook-69dbd99b8c-wrxw9               1/1     Running     0              7m54s
external-dns      external-dns-private-76cb944d96-8w8bn               1/1     Running     0              7m54s
external-dns      external-dns-public-6b9b6fbb46-7l7b2                1/1     Running     0              7m54s
forecastle        forecastle-6c8d549fdc-d92pt                         1/1     Running     0              7m54s
ingress-haproxy   haproxy-ingress-external-h4klb                      1/1     Running     0              7m53s
ingress-haproxy   haproxy-ingress-external-mdd9v                      1/1     Running     0              7m53s
ingress-haproxy   haproxy-ingress-external-tqtsq                      1/1     Running     0              7m52s
ingress-haproxy   haproxy-ingress-internal-crdjob-vh5st               0/1     Completed   0              7m52s
ingress-haproxy   haproxy-ingress-internal-d7slc                      1/1     Running     0              7m48s
ingress-haproxy   haproxy-ingress-internal-m9x2j                      1/1     Running     0              7m47s
ingress-haproxy   haproxy-ingress-internal-n44sb                      1/1     Running     0              7m47s
kube-system       aws-load-balancer-controller-7d9c96b4dc-xxvqx       1/1     Running     0              7m53s
kube-system       aws-node-4v68n                                      2/2     Running     0              10m
kube-system       aws-node-b7hvd                                      2/2     Running     0              10m
kube-system       aws-node-fjtv9                                      2/2     Running     0              10m
kube-system       aws-node-ftljm                                      2/2     Running     0              9m33s
kube-system       aws-node-g2t7z                                      2/2     Running     0              9m56s
kube-system       aws-node-j4l68                                      2/2     Running     0              9m25s
kube-system       aws-node-lmcq5                                      2/2     Running     0              9m56s
kube-system       aws-node-n2mrb                                      2/2     Running     0              10m
kube-system       aws-node-rmwns                                      2/2     Running     0              9m41s
kube-system       aws-node-t99vj                                      2/2     Running     0              9m37s
kube-system       aws-node-termination-handler-7fctt                  1/1     Running     0              7m50s
kube-system       aws-node-termination-handler-9scjz                  1/1     Running     0              7m48s
kube-system       aws-node-termination-handler-dg4m9                  1/1     Running     0              7m50s
kube-system       aws-node-termination-handler-gwfrr                  1/1     Running     0              7m49s
kube-system       aws-node-termination-handler-jcmzh                  1/1     Running     0              7m49s
kube-system       aws-node-termination-handler-kt9fg                  1/1     Running     0              7m48s
kube-system       aws-node-termination-handler-nvqmn                  1/1     Running     0              7m48s
kube-system       aws-node-termination-handler-sqzcz                  1/1     Running     0              7m50s
kube-system       aws-node-termination-handler-t56ck                  1/1     Running     0              7m48s
kube-system       aws-node-termination-handler-t7jrw                  1/1     Running     0              7m48s
kube-system       aws-node-termination-handler-vdh2q                  1/1     Running     0              7m49s
kube-system       aws-node-termination-handler-x865k                  1/1     Running     0              7m49s
kube-system       aws-node-vf54l                                      2/2     Running     0              9m28s
kube-system       aws-node-vrwjs                                      2/2     Running     0              9m45s
kube-system       cluster-autoscaler-54f9cd787d-hfxnj                 1/1     Running     0              7m53s
kube-system       coredns-554b698d84-mnnmv                            1/1     Running     0              10m
kube-system       coredns-554b698d84-pmhzx                            1/1     Running     0              10m
kube-system       ebs-csi-controller-8dfd777d7-cfpgj                  6/6     Running     0              10m
kube-system       ebs-csi-controller-8dfd777d7-djzhc                  6/6     Running     0              10m
kube-system       ebs-csi-node-22pbb                                  3/3     Running     0              10m
kube-system       ebs-csi-node-45b47                                  3/3     Running     0              10m
kube-system       ebs-csi-node-5b2cf                                  3/3     Running     0              10m
kube-system       ebs-csi-node-768vf                                  3/3     Running     0              10m
kube-system       ebs-csi-node-dgr2k                                  3/3     Running     0              10m
kube-system       ebs-csi-node-dhsc4                                  3/3     Running     0              10m
kube-system       ebs-csi-node-h9s6c                                  3/3     Running     0              10m
kube-system       ebs-csi-node-kvtb2                                  3/3     Running     0              10m
kube-system       ebs-csi-node-ldgr2                                  3/3     Running     0              10m
kube-system       ebs-csi-node-t5hdz                                  3/3     Running     0              10m
kube-system       ebs-csi-node-vfxx8                                  3/3     Running     0              10m
kube-system       ebs-csi-node-wdd5q                                  3/3     Running     0              10m
kube-system       kube-proxy-8d6s8                                    1/1     Running     0              10m
kube-system       kube-proxy-8rkq8                                    1/1     Running     0              10m
kube-system       kube-proxy-9l4hp                                    1/1     Running     0              10m
kube-system       kube-proxy-9zd7d                                    1/1     Running     0              9m54s
kube-system       kube-proxy-db88c                                    1/1     Running     0              9m50s
kube-system       kube-proxy-jj4dd                                    1/1     Running     0              9m46s
kube-system       kube-proxy-khdrc                                    1/1     Running     0              9m50s
kube-system       kube-proxy-qbjmh                                    1/1     Running     0              9m57s
kube-system       kube-proxy-qrt8p                                    1/1     Running     0              10m
kube-system       kube-proxy-wwmwd                                    1/1     Running     0              9m58s
kube-system       kube-proxy-z7d8b                                    1/1     Running     0              10m
kube-system       kube-proxy-z9vqq                                    1/1     Running     0              10m
kube-system       node-agent-2wks5                                    1/1     Running     0              7m43s
kube-system       node-agent-45pbl                                    1/1     Running     0              7m43s
kube-system       node-agent-67gbl                                    1/1     Running     0              7m45s
kube-system       node-agent-bqvtg                                    1/1     Running     0              7m43s
kube-system       node-agent-fb42j                                    1/1     Running     0              7m43s
kube-system       node-agent-fccdk                                    1/1     Running     0              7m46s
kube-system       node-agent-jqhwg                                    1/1     Running     0              7m45s
kube-system       node-agent-kmnbj                                    1/1     Running     0              7m45s
kube-system       node-agent-kp749                                    1/1     Running     0              7m43s
kube-system       node-agent-tdtrg                                    1/1     Running     0              7m45s
kube-system       node-agent-v274f                                    1/1     Running     0              7m45s
kube-system       node-agent-xzt8s                                    1/1     Running     0              7m45s
kube-system       snapshot-controller-7fc4668d6d-f6skn                1/1     Running     0              10m
kube-system       snapshot-controller-7fc4668d6d-qh7p4                1/1     Running     0              10m
kube-system       velero-7567586466-4w7ms                             1/1     Running     0              7m53s
logging           infra-fluentbit-5rf7l                               1/1     Running     0              7m7s
logging           infra-fluentbit-5vc6f                               1/1     Running     0              7m6s
logging           infra-fluentbit-c586t                               1/1     Running     0              7m6s
logging           infra-fluentbit-ffh9f                               1/1     Running     0              7m7s
logging           infra-fluentbit-h69w7                               1/1     Running     0              7m7s
logging           infra-fluentbit-k5w58                               1/1     Running     0              7m6s
logging           infra-fluentbit-k9kqq                               1/1     Running     0              7m6s
logging           infra-fluentbit-k9tr9                               1/1     Running     0              7m6s
logging           infra-fluentbit-lmrlk                               1/1     Running     0              7m7s
logging           infra-fluentbit-xrfb2                               1/1     Running     0              7m7s
logging           infra-fluentbit-z8n2g                               1/1     Running     0              7m7s
logging           infra-fluentbit-znvdk                               1/1     Running     0              7m7s
logging           infra-fluentd-0                                     2/2     Running     0              7m7s
logging           infra-fluentd-1                                     2/2     Running     0              6m46s
logging           infra-fluentd-configcheck-8097a17e                  0/1     Completed   0              7m31s
logging           kubernetes-event-tailer-0                           1/1     Running     0              7m36s
logging           logging-operator-5bc7fc9869-4cnw4                   1/1     Running     0              7m53s
logging           loki-distributed-compactor-0                        1/1     Running     1 (7m9s ago)   7m50s
logging           loki-distributed-distributor-7bbb44ccfb-b4f6v       1/1     Running     0              7m53s
logging           loki-distributed-gateway-5cf9cbc648-bslxt           2/2     Running     0              7m53s
logging           loki-distributed-index-gateway-0                    1/1     Running     0              7m53s
logging           loki-distributed-ingester-0                         1/1     Running     0              7m53s
logging           loki-distributed-querier-78d75bcffd-7mdsc           1/1     Running     0              7m52s
logging           loki-distributed-query-frontend-64474fb8c4-4gr52    1/1     Running     0              7m53s
logging           loki-distributed-query-scheduler-5c566c6d58-9qrhp   1/1     Running     0              7m47s
logging           minio-logging-0                                     1/1     Running     0              7m52s
logging           minio-logging-1                                     1/1     Running     0              7m51s
logging           minio-logging-2                                     1/1     Running     0              7m51s
logging           minio-logging-buckets-setup-h9xnj                   0/1     Completed   1              7m52s
logging           systemd-common-host-tailer-4bsph                    4/4     Running     0              7m39s
logging           systemd-common-host-tailer-5c9cw                    4/4     Running     0              7m37s
logging           systemd-common-host-tailer-746hm                    4/4     Running     0              7m37s
logging           systemd-common-host-tailer-cbg8q                    4/4     Running     0              7m37s
logging           systemd-common-host-tailer-jh46j                    4/4     Running     0              7m37s
logging           systemd-common-host-tailer-jht5z                    4/4     Running     0              7m38s
logging           systemd-common-host-tailer-pxjlb                    4/4     Running     0              7m39s
logging           systemd-common-host-tailer-qmcqz                    4/4     Running     0              7m38s
logging           systemd-common-host-tailer-wc7mt                    4/4     Running     0              7m41s
logging           systemd-common-host-tailer-xgnzd                    4/4     Running     0              7m37s
logging           systemd-common-host-tailer-xrrvl                    4/4     Running     0              7m38s
logging           systemd-common-host-tailer-xw96l                    4/4     Running     0              7m38s
monitoring        alertmanager-main-0                                 2/2     Running     0              7m33s
monitoring        blackbox-exporter-6c8645f7dc-6ns5d                  3/3     Running     0              7m50s
monitoring        grafana-7d8749445f-2ssxt                            3/3     Running     0              7m49s
monitoring        kube-proxy-metrics-5jjg8                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-6sgh5                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-7l2tq                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-97qff                            1/1     Running     0              7m44s
monitoring        kube-proxy-metrics-ccjk2                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-gtqtj                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-kn6r9                            1/1     Running     0              7m44s
monitoring        kube-proxy-metrics-lj7pp                            1/1     Running     0              7m44s
monitoring        kube-proxy-metrics-pbbdt                            1/1     Running     0              7m44s
monitoring        kube-proxy-metrics-qn4hl                            1/1     Running     0              7m44s
monitoring        kube-proxy-metrics-s2kd6                            1/1     Running     0              7m45s
monitoring        kube-proxy-metrics-wdqdc                            1/1     Running     0              7m46s
monitoring        kube-state-metrics-6c4df6c9dd-8mwsv                 3/3     Running     0              7m49s
monitoring        node-exporter-5bg47                                 2/2     Running     0              7m53s
monitoring        node-exporter-5lq5w                                 2/2     Running     0              7m52s
monitoring        node-exporter-7m8gd                                 2/2     Running     0              7m52s
monitoring        node-exporter-8hzsx                                 2/2     Running     0              7m52s
monitoring        node-exporter-m4fsr                                 2/2     Running     0              7m51s
monitoring        node-exporter-mpnc6                                 2/2     Running     0              7m52s
monitoring        node-exporter-mxd92                                 2/2     Running     0              7m52s
monitoring        node-exporter-nsm57                                 2/2     Running     0              7m53s
monitoring        node-exporter-rkkg4                                 2/2     Running     0              7m51s
monitoring        node-exporter-tn7tt                                 2/2     Running     0              7m51s
monitoring        node-exporter-w9qrb                                 2/2     Running     0              7m51s
monitoring        node-exporter-wfgnc                                 2/2     Running     0              7m51s
monitoring        prometheus-adapter-56f6c668f-bgc45                  1/1     Running     0              7m50s
monitoring        prometheus-k8s-0                                    2/2     Running     0              7m32s
monitoring        prometheus-operator-5b66748c8c-m5q6d                2/2     Running     0              7m50s
monitoring        x509-certificate-exporter-695fb985c4-kxjr4          1/1     Running     0              7m48s
tigera-operator   tigera-operator-6797988b48-c4ch6                    1/1     Running     0              7m48s
```

## Run conformance tests

> Install requirements and run commands:

Download Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
