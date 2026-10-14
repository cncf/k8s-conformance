http://docs.mnc.intern.arwinet.com/docs/kubeopsctl-2.0/getting-started/setup/

Kubeops
Prepare Admin Node

sudo rpm --install -v kosi*.rpm
after that, set the environment variable

export KUBEOPSROOT=/home/<yourUser>/kubeops
export XDG_RUNTIME_DIR=$KUBEOPSROOT
source ~/.bashrc

Adjust KOSI Configuration

mkdir ~/kubeops
cd ~/kubeops
cp -R /var/kubeops/kosi/ .
cp -R /var/kubeops/plugins/ .

Install KOSI enterprise plugins
kosi install --hub kosi-enterprise kosi/enterprise-plugins:2.0.0

Login with your user
kosi login -u <yourUser>

Create a cluster-values.yaml configuration file:
# file cluster-values.yaml
apiVersion: kubeops/kubeopsctl/cluster/beta/v1
imagePullRegistry: registry.preprod.kubeops.net/kubeops/kubeops
airgap: false
clusterName: <your cluster name>
clusterUser: <your user name>
kubernetesVersion: <your kubernetesversion>
kubeVipEnabled: false
virtualIP: <your master1 ip>
firewall: nftables
pluginNetwork: calico
containerRuntime: containerd
kubeOpsRoot: <your kubeopsroot path>
serviceSubnet: 192.168.128.0/17
podSubnet: 192.168.0.0/17
debug: true
packageRepository: https://packagerepo.preprod.kubeops.net/
changeCluster: true
zones:
# IMPORTANT: The following part has to be adapted so that every one of your masternodes and workernodes is included
# This file only includes the minimum requirements for the amount of masters and workers and an example usage of zones
# You should adapt this part to your amount of masters and workers and cluster them into as many zones as you like
- name: zone1
  nodes:
  - name: <your master1 hostname>
    iPAddress: <your master1 ip>
    type: controlplane
    kubeVersion: <kubernetesversion from above>
  - name: <your worker1 hostname>
    iPAddress: <your worker1 ip>
    type: worker
    kubeVersion: <kubernetesversion from above>
- name: zone2
  nodes:
  - name: <your master2 hostname>
    iPAddress: <your master2 ip>
    type: controlplane
    kubeVersion: <kubernetesversion from above>
  - name: <your worker2 hostname>
    iPAddress: <your worker2 ip>
    type: worker
    kubeVersion: <kubernetesversion from above>
- name: zone3
  nodes:
  - name: <your master3 hostname>
    iPAddress: <your master3 ip>
    type: controlplane
    kubeVersion: <kubernetesversion from above>
  - name: <your worker3 hostname>
    iPAddress: <your worker3 ip>
    type: worker
    kubeVersion: <kubernetesversion from above>
    
Pull required KOSI packages

kubeopsctl pull --kubernetesVersion <x.xx.x>

Install podman
kosi install -p $KUBEOPSROOT/lima/podman_5.2.2.tgz -f cluster-values.yaml

Install helm
kosi install -p $KUBEOPSROOT/lima/helm_v3.16.4.tgz

Install kubernetes tools (kubectl)
kosi install -p $KUBEOPSROOT/lima/kubernetes-tools_<your kubernetes version>.tgz -f cluster-values.yaml

Cluster Setup
kosi login -u <your username>
kubeopsctl apply -f cluster-values.yaml

after alle node on running then create a enterprise-value.yaml to Installing Applications

apiVersion: kubeops/kubeopsctl/enterprise/beta/v1
deleteNs: false
localRegistry: false
packages:
- name: opa-gatekeeper
  enabled: true
  values:
    standard:
      namespace: opa-gatekeeper
    advanced:
- name: rook-ceph
  enabled: true
  values:
    standard:
      namespace: rook-ceph
      cluster:
        resources:
          mgr:
            requests:
              cpu: "500m"
              memory: "512Mi"
          mon:
            requests:
              cpu: "1"
              memory: "1Gi"
          osd:
            requests:
              cpu: "1"
              memory: "1Gi"
        dashboard:
          enabled: true
      operator:
        data:
          rookLogLevel: "DEBUG"
- name: harbor
  enabled: true
  values:
    standard:
      namespace: harbor
      harborpass: "topsecret"
      databasePassword: "topsecret"
      redisPassword: "topsecret"
      externalURL: http://10.2.10.110:30002
      nodePort: 30002
      hostname: harbor.local
      harborPersistence:
        persistentVolumeClaim:
          registry:
            size: 40Gi
            storageClass: "rook-cephfs"
          jobservice:
            jobLog:
              size: 1Gi
              storageClass: "rook-cephfs"
          database:
            size: 1Gi
            storageClass: "rook-cephfs"
          redis:
            size: 1Gi
            storageClass: "rook-cephfs"
          trivy: 
            size: 5Gi
            storageClass: "rook-cephfs"
    advanced:
- name: kubeops-dashboard
  enabled: true
  values:
    standard:
      namespace: monitoring
      hostname: kubeops-dashboard.local
      service:
        nodePort: 30007
    advanced:
- name: filebeat-os
  enabled: false
  values:
    standard:
      namespace: logging
    advanced:

and Pull the KubeOps Compliance Applications packages

kubeopsctl pull --tools enterprise-values.yaml --kubernetesVersion <x.xx.x>

Important for only installation of the tools is that you have set your flag changeCluster to false in your cluster-values.yaml.
Validate your values and install the KubeOps Compliance Applications
kubeopsctl apply -f cluster-values.yaml -f enterprise-values.yaml

Run conformance tests
Download a binary release of the CLI, or build it yourself by running:

go install github.com/vmware-tanzu/sonobuoy@latest
Deploy a Sonobuoy pod to your cluster with:

sonobuoy run --mode=certified-conformance
View actively running pods:

sonobuoy status
To inspect the logs:

sonobuoy logs
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

outfile=$(sonobuoy retrieve)
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

mkdir ./results; tar xzf $outfile -C ./results
NOTE: The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.

Clean up
To clean up Kubernetes objects created by Sonobuoy, run:

sonobuoy delete
