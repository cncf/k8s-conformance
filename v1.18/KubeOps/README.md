## In the following I'll explain my steps reproducably:


### Creating cluster
1. I created four clean VM's using Centos7 as bootsystem. (1x Admin/Dev(node), 1x Clustermaster(node), 2x worker(nodes))  ;
2. Downloaded the .rpm at http://kubernative.net/de/produkte/download-area and installed it at Admin/Dev (node)  ;
3. On Admin/Dev I created the folders clusterStorage and yamlFiles at root directory. In the yamlFiles I created createCluster.yaml and addNode.yaml  ;

#### Input for createCluster.yaml:

```yaml
apiVersion: lima/clusterconfig/v1alpha1
spec:
  clusterName: Testcluster
  kubernetesVersion: 1.18.6
  debug: true
  registry: registry.kubernative.net
  ignoreFirewallError: true
  useInsecureRegistry: true
  apiEndpoint: 192.168.75.146:6443
  serviceSubnet: 192.168.128.0/24
  podSubnet: 192.168.129.0/24
  masterHost: 192.168.75.146
  masterUser: root
  masterPassword: root
  weavePassword: dsffd12edfkslkf
```

#### Input for addNode.yaml:

```yaml
apiVersion: lima/nodeconfig/v1alpha1
clusterName: Testcluster
spec:
  workers:
  - host: 192.168.75.148
    user: root
    password: root
  - host: 192.168.75.149
    user: root
    password: root
```

4. After, I used the command: `echo 'export KUBEOPSROOT="<your path>"' >> $HOME/.bashrc`  ;
5. Next I used those commands: `systemctl start docker` and: `systemctl enable docker`  ;
6. Now I start creating the cluster like: `lima create -f /root/yamlFiles/createCluster.yaml`  ;
7. After that, I let the nodes join the cluster like: `lima create -f /root/yamlFiles/addNode.yaml`  ;

### Conformance-Test
8. Finaly I downloaded sonobuoy as .tar at: https://github.com/vmware-tanzu/sonobuoy/releases ;and unpacked it with the command: `tar -xzf sonobuoy_0.19.0_linux_amd64.tar.gz`  ;
9. After I moved in sonobuoy I moved sunobuoy like that: `mv sonobuoy /usr/local/bin`  ;
10. In the End I started the conformance-test like this: `sonobuoy run --mode=certified-conformance`  ;
11. After the conformance-test I followed your steps: `outfile=$(sonobuoy retrieve)`  ; 
12. Then as next I did this command: `mkdir ./results; tar xzf $outfile -C ./results`  ;
13. While I am in /root/ I used following command: `cd results/plugins/e2e/results/global/`  ;
14. Here we got those 2 files we needed for the conformance-test
