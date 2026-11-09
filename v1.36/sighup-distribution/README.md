# Conformance tests for SIGHUP Distribution

## Cluster Provisioning

### Install the Kubernetes cluster on AWS with `furyctl`

#### Requirements

This Project project requires:

- furyctl 0.36.1 installed: https://github.com/sighupio/furyctl/releases/tag/v0.36.1
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
  name: k8s-conformance-136
spec:
  # This value defines which KFD version will be installed and in consequence the Kubernetes version to use to create the cluster
  distributionVersion: v1.36.0
  toolsConfiguration:
    opentofu:
      state:
        s3:
          # This should be an existing bucket name on AWS
          bucketName: k8s-conformance-sd-136
          keyPrefix: k8s-sd-1.36.0/
          region: eu-west-1
  # This value defines in which AWS region the cluster and all the related resources will be created
  region: eu-west-1
  # This map defines which will be the common tags that will be added to all the resources created on AWS
  tags:
    env: "development"
    k8s: "k8s-conformance-136"
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
            bucketName: kfd-conformance-velero-136
            region: eu-west-1
      auth:
        provider:
          type: none
      tracing: 
        type: none
```



#### Execute `furyctl` to create the cluster

```bash
-> furyctl apply --outdir $PWD
INFO Downloading distribution...
INFO Validating configuration file...
INFO Downloading dependencies...
INFO Tools ready (8 installed via mise)
INFO Validating dependencies...
INFO Ensure prerequisites are in place...
INFO Running preflight checks...
INFO Preflight checks completed successfully
INFO Applying the configuration...
INFO Creating infrastructure...
WARN Creating cloud resources, this could take a while...
INFO Infrastructure configured successfully
INFO Generating VPN client certificate...
INFO Configuring SIGHUP Distribution cluster...
WARN Creating cloud resources, this could take a while...
INFO Kubernetes cluster configured successfully
INFO Installing SIGHUP Distribution...
WARN Creating cloud resources, this could take a while...
INFO Checking that the cluster is reachable...
INFO Applying Distribution modules...
INFO SIGHUP Distribution installed successfully
INFO Applying plugins...
INFO Skipping plugins phase as spec.plugins is not defined
INFO Saving furyctl configuration file in the cluster...
INFO Saving distribution configuration file in the cluster...
INFO SIGHUP Distribution cluster configured successfully
INFO Please remember to kill the VPN connection when you finish doing operations on the cluster
INFO To connect to the cluster, set the path to your kubeconfig with 'export KUBECONFIG=/home/sighup/eks/kubeconfig' or use the '--kubeconfig /home/sighup/eks/kubeconfig' flag in following executions
```

#### Verify that the cluster is up & running

```bash
kubectl get nodes -L node.kubernetes.io/role --kubeconfig kubeconfig
NAME                                          STATUS   ROLES    AGE   VERSION               ROLE
ip-10-150-13-245.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   ingress
ip-10-150-14-132.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
ip-10-150-14-218.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   worker
ip-10-150-19-227.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   worker
ip-10-150-2-189.eu-west-1.compute.internal    Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
ip-10-150-24-106.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
ip-10-150-30-116.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
ip-10-150-31-8.eu-west-1.compute.internal     Ready    <none>   15m   v1.36.5-eks-6e7947a   ingress
ip-10-150-39-128.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   ingress
ip-10-150-42-158.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   worker
ip-10-150-45-150.eu-west-1.compute.internal   Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
ip-10-150-46-79.eu-west-1.compute.internal    Ready    <none>   15m   v1.36.5-eks-6e7947a   infra
```

Wait until everything is up and running:

```bash
kubectl get pods -A --kubeconfig kubeconfig
NAMESPACE         NAME                                                READY   STATUS      RESTARTS      AGE
calico-system     calico-kube-controllers-f6b7955b9-hr6bj             1/1     Running     0             12m
calico-system     calico-node-57nrj                                   1/1     Running     0             12m
calico-system     calico-node-6m46f                                   1/1     Running     0             12m
calico-system     calico-node-bcxg7                                   1/1     Running     0             12m
calico-system     calico-node-frr7r                                   1/1     Running     0             12m
calico-system     calico-node-ggsp5                                   1/1     Running     0             12m
calico-system     calico-node-h5k2q                                   1/1     Running     0             12m
calico-system     calico-node-kbps2                                   1/1     Running     0             12m
calico-system     calico-node-kt6cd                                   1/1     Running     0             12m
calico-system     calico-node-n8dkf                                   1/1     Running     0             12m
calico-system     calico-node-n9kcc                                   1/1     Running     0             12m
calico-system     calico-node-qbfpx                                   1/1     Running     0             12m
calico-system     calico-node-ztfwx                                   1/1     Running     0             12m
calico-system     calico-typha-7dc4576b58-c49bh                       1/1     Running     0             12m
calico-system     calico-typha-7dc4576b58-jtmtj                       1/1     Running     0             12m
calico-system     calico-typha-7dc4576b58-tgqb7                       1/1     Running     0             12m
calico-system     csi-node-driver-8lvjn                               2/2     Running     0             12m
calico-system     csi-node-driver-fbp9l                               2/2     Running     0             12m
calico-system     csi-node-driver-fcqjc                               2/2     Running     0             12m
calico-system     csi-node-driver-fgxhd                               2/2     Running     0             12m
calico-system     csi-node-driver-frgqh                               2/2     Running     0             12m
calico-system     csi-node-driver-fxrm6                               2/2     Running     0             12m
calico-system     csi-node-driver-q47hn                               2/2     Running     0             12m
calico-system     csi-node-driver-q96k4                               2/2     Running     0             12m
calico-system     csi-node-driver-rm62x                               2/2     Running     0             12m
calico-system     csi-node-driver-rrh7p                               2/2     Running     0             12m
calico-system     csi-node-driver-t9gr2                               2/2     Running     0             12m
calico-system     csi-node-driver-vghzd                               2/2     Running     0             12m
cert-manager      cert-manager-c9b48bdc6-fvtg8                        1/1     Running     0             12m
cert-manager      cert-manager-cainjector-867f4c4bbb-8nmpf            1/1     Running     0             12m
cert-manager      cert-manager-webhook-7864fb9cd8-8pxqw               1/1     Running     0             12m
external-dns      external-dns-private-5f49c5fb9b-bldl7               1/1     Running     0             12m
external-dns      external-dns-public-59495f79d-tm5cf                 1/1     Running     0             12m
forecastle        forecastle-5f6b885b56-4qxnx                         1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-external-4fdpw                      1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-external-f4txd                      1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-external-z8sdt                      1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-internal-2ddsx                      1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-internal-h87hj                      1/1     Running     0             12m
ingress-haproxy   haproxy-ingress-internal-k2mw2                      1/1     Running     0             12m
kube-system       aws-load-balancer-controller-54bdcb896d-k8c7f       1/1     Running     0             12m
kube-system       aws-node-4vqw2                                      2/2     Running     0             14m
kube-system       aws-node-6k7sv                                      2/2     Running     0             14m
kube-system       aws-node-8jnkx                                      2/2     Running     0             14m
kube-system       aws-node-b5btq                                      2/2     Running     0             14m
kube-system       aws-node-cj5hd                                      2/2     Running     0             14m
kube-system       aws-node-fg5nx                                      2/2     Running     0             14m
kube-system       aws-node-jw2bh                                      2/2     Running     0             14m
kube-system       aws-node-k5l5c                                      2/2     Running     0             14m
kube-system       aws-node-kjst6                                      2/2     Running     0             14m
kube-system       aws-node-njtch                                      2/2     Running     0             14m
kube-system       aws-node-termination-handler-26b4k                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-2knx8                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-6kmmz                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-bbpf8                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-cfc4c                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-fqzr7                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-fvjxr                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-hntrl                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-hxvb7                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-rr76g                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-wfkpq                  1/1     Running     0             12m
kube-system       aws-node-termination-handler-zjlfd                  1/1     Running     0             12m
kube-system       aws-node-v7ptz                                      2/2     Running     0             14m
kube-system       aws-node-wb4r8                                      2/2     Running     0             14m
kube-system       cluster-autoscaler-767d456cb4-rwffm                 1/1     Running     0             12m
kube-system       coredns-598f7c454d-7pd76                            1/1     Running     0             15m
kube-system       coredns-598f7c454d-9fcsl                            1/1     Running     0             15m
kube-system       ebs-csi-controller-58957d8fd4-7pcbd                 6/6     Running     0             14m
kube-system       ebs-csi-controller-58957d8fd4-j6jz4                 6/6     Running     0             14m
kube-system       ebs-csi-node-4hjfk                                  3/3     Running     0             14m
kube-system       ebs-csi-node-5vnlj                                  3/3     Running     0             14m
kube-system       ebs-csi-node-89rv9                                  3/3     Running     0             14m
kube-system       ebs-csi-node-98qgg                                  3/3     Running     0             14m
kube-system       ebs-csi-node-blprm                                  3/3     Running     0             14m
kube-system       ebs-csi-node-h5j2z                                  3/3     Running     0             14m
kube-system       ebs-csi-node-j52s6                                  3/3     Running     0             14m
kube-system       ebs-csi-node-mflhc                                  3/3     Running     0             14m
kube-system       ebs-csi-node-qpp5n                                  3/3     Running     0             14m
kube-system       ebs-csi-node-rvz8j                                  3/3     Running     0             14m
kube-system       ebs-csi-node-sdnfd                                  3/3     Running     0             14m
kube-system       ebs-csi-node-whdjn                                  3/3     Running     0             14m
kube-system       kube-proxy-45n8c                                    1/1     Running     0             15m
kube-system       kube-proxy-6fwjf                                    1/1     Running     0             15m
kube-system       kube-proxy-8482f                                    1/1     Running     0             15m
kube-system       kube-proxy-8f5w4                                    1/1     Running     0             15m
kube-system       kube-proxy-cjdb6                                    1/1     Running     0             15m
kube-system       kube-proxy-g8f8p                                    1/1     Running     0             15m
kube-system       kube-proxy-h5mpx                                    1/1     Running     0             15m
kube-system       kube-proxy-k56f8                                    1/1     Running     0             15m
kube-system       kube-proxy-lk8sc                                    1/1     Running     0             15m
kube-system       kube-proxy-rj924                                    1/1     Running     0             15m
kube-system       kube-proxy-swc4z                                    1/1     Running     0             15m
kube-system       kube-proxy-vdvfl                                    1/1     Running     0             15m
kube-system       node-agent-4v6tl                                    1/1     Running     0             12m
kube-system       node-agent-5sqqs                                    1/1     Running     0             12m
kube-system       node-agent-cckdm                                    1/1     Running     0             12m
kube-system       node-agent-dv28v                                    1/1     Running     0             12m
kube-system       node-agent-fs6cs                                    1/1     Running     0             12m
kube-system       node-agent-gx6fw                                    1/1     Running     0             12m
kube-system       node-agent-jpk28                                    1/1     Running     0             12m
kube-system       node-agent-pk695                                    1/1     Running     0             12m
kube-system       node-agent-q4jfp                                    1/1     Running     0             12m
kube-system       node-agent-q94cq                                    1/1     Running     0             12m
kube-system       node-agent-spr2m                                    1/1     Running     0             12m
kube-system       node-agent-vgqpf                                    1/1     Running     0             12m
kube-system       snapshot-controller-674b486f5b-g275h                1/1     Running     0             14m
kube-system       snapshot-controller-674b486f5b-qdsq4                1/1     Running     0             14m
kube-system       velero-5bd4b9b999-tl45l                             1/1     Running     0             12m
logging           infra-fluentbit-5jjfl                               1/1     Running     0             11m
logging           infra-fluentbit-5t5q6                               1/1     Running     0             11m
logging           infra-fluentbit-9lpgg                               1/1     Running     0             11m
logging           infra-fluentbit-gk8km                               1/1     Running     0             11m
logging           infra-fluentbit-gl6rv                               1/1     Running     0             11m
logging           infra-fluentbit-hq6bx                               1/1     Running     0             11m
logging           infra-fluentbit-hqs6f                               1/1     Running     0             11m
logging           infra-fluentbit-lflq9                               1/1     Running     0             11m
logging           infra-fluentbit-nm4lw                               1/1     Running     0             11m
logging           infra-fluentbit-qfnx4                               1/1     Running     0             11m
logging           infra-fluentbit-s8js6                               1/1     Running     0             11m
logging           infra-fluentbit-w2b9d                               1/1     Running     0             11m
logging           infra-fluentd-0                                     2/2     Running     0             11m
logging           infra-fluentd-1                                     2/2     Running     0             10m
logging           infra-fluentd-configcheck-d04fbb2                   0/1     Completed   0             11m
logging           kubernetes-event-tailer-0                           1/1     Running     0             12m
logging           logging-operator-cc884558b-6gbzv                    1/1     Running     0             12m
logging           loki-distributed-compactor-0                        1/1     Running     1 (11m ago)   12m
logging           loki-distributed-distributor-5bd498b98c-qdktv       1/1     Running     0             12m
logging           loki-distributed-gateway-7d4bb8b7f5-h8nfw           2/2     Running     0             12m
logging           loki-distributed-index-gateway-0                    1/1     Running     0             12m
logging           loki-distributed-ingester-0                         1/1     Running     0             12m
logging           loki-distributed-querier-5b849558d9-zjwbt           1/1     Running     0             12m
logging           loki-distributed-query-frontend-6cdf694d49-hmd45    1/1     Running     0             12m
logging           loki-distributed-query-scheduler-769b9b85dc-fm8t2   1/1     Running     0             12m
logging           minio-logging-0                                     1/1     Running     0             12m
logging           minio-logging-1                                     1/1     Running     0             12m
logging           minio-logging-2                                     1/1     Running     0             12m
logging           minio-logging-buckets-setup-ks5qc                   0/1     Completed   0             12m
logging           systemd-common-host-tailer-4kqjz                    4/4     Running     0             12m
logging           systemd-common-host-tailer-5ggrp                    4/4     Running     0             12m
logging           systemd-common-host-tailer-64b6f                    4/4     Running     0             12m
logging           systemd-common-host-tailer-6xjnh                    4/4     Running     0             12m
logging           systemd-common-host-tailer-7dbg9                    4/4     Running     0             12m
logging           systemd-common-host-tailer-8f86s                    4/4     Running     0             12m
logging           systemd-common-host-tailer-d2vrq                    4/4     Running     0             12m
logging           systemd-common-host-tailer-fk4hc                    4/4     Running     0             12m
logging           systemd-common-host-tailer-fqjcv                    4/4     Running     0             12m
logging           systemd-common-host-tailer-gvf5p                    4/4     Running     0             12m
logging           systemd-common-host-tailer-rrhn4                    4/4     Running     0             12m
logging           systemd-common-host-tailer-zslkz                    4/4     Running     0             12m
monitoring        alertmanager-main-0                                 2/2     Running     0             12m
monitoring        blackbox-exporter-79c6f76bcd-2jz9k                  3/3     Running     0             12m
monitoring        grafana-6455f96c6b-prcql                            3/3     Running     0             12m
monitoring        kube-proxy-metrics-2ws6t                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-bflhp                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-bnl5m                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-dhtp4                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-djvw7                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-phn8g                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-rpbx7                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-sr59l                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-thdhr                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-tl6l5                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-vjhld                            1/1     Running     0             12m
monitoring        kube-proxy-metrics-wbvfz                            1/1     Running     0             12m
monitoring        kube-state-metrics-5fd5b74959-jqbvm                 3/3     Running     0             12m
monitoring        node-exporter-2x8sn                                 2/2     Running     0             12m
monitoring        node-exporter-6lqj4                                 2/2     Running     0             12m
monitoring        node-exporter-86xj4                                 2/2     Running     0             12m
monitoring        node-exporter-bwlqb                                 2/2     Running     0             12m
monitoring        node-exporter-cjc5t                                 2/2     Running     0             12m
monitoring        node-exporter-dq9vg                                 2/2     Running     0             12m
monitoring        node-exporter-gn75x                                 2/2     Running     0             12m
monitoring        node-exporter-h8kw5                                 2/2     Running     0             12m
monitoring        node-exporter-p5cz8                                 2/2     Running     0             12m
monitoring        node-exporter-psxdq                                 2/2     Running     0             12m
monitoring        node-exporter-qcdlc                                 2/2     Running     0             12m
monitoring        node-exporter-xfnz4                                 2/2     Running     0             12m
monitoring        prometheus-adapter-d9d96cc54-8hq84                  1/1     Running     0             12m
monitoring        prometheus-k8s-0                                    2/2     Running     0             12m
monitoring        prometheus-operator-64cc669bc-b94hj                 2/2     Running     0             12m
monitoring        x509-certificate-exporter-7f88c9f8f8-q98w5          1/1     Running     0             12m
tigera-operator   tigera-operator-77fc4c6485-7kj5s                    1/1     Running     0             12m
```

## Run conformance tests

> Install requirements and run commands:

Download Hydrophone https://github.com/kubernetes-sigs/hydrophone 

And run:

```bash
hydrophone --conformance
```

And get the files under: `./{e2e.log,junit_01.xml}`
