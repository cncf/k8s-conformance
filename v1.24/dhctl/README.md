# Reproducing the test results

 ##### 1. Create basic configuration
```console
$ cat > config.yml <<EOF
apiVersion: deckhouse.io/v1
kind: ClusterConfiguration
clusterType: Static
podSubnetCIDR: 10.111.0.0/16
serviceSubnetCIDR: 10.222.0.0/16
kubernetesVersion: "1.24"
clusterDomain: "cluster.local"
---
apiVersion: deckhouse.io/v1
kind: InitConfiguration
deckhouse:
  releaseChannel: Stable
  configOverrides:
    global:
      modules:
        publicDomainTemplate: "%s.example.com"
    cniFlannelEnabled: true
    cniFlannel:
      podNetworkMode: VXLAN
---
apiVersion: deckhouse.io/v1
kind: StaticClusterConfiguration
internalNetworkCIDRs:
- 192.168.0.0/24
EOF
```

##### 2. Run the prebuilt installation image of Deckhouse Installer
```console
$ docker run -it -v "$PWD/config.yml:/config.yml" -v "$HOME/.ssh/:/tmp/.ssh/" \
    registry.deckhouse.io/deckhouse/ce/install:stable bash
```

##### 3. Initiate the process of installation 
```console
# dhctl bootstrap \
    --ssh-user=<username> \
    --ssh-host=<master_ip> \
    --ssh-agent-private-keys=/tmp/.ssh/id_rsa \
    --config=/config.yml
```

`username` variable here refers to the user that generated the SSH key.
`master_ip` is an IP address of your machine

After the installation is complete, you will be returned to the command line.

##### 4. SSH to host machine
```console
$ ssh <username>@<master_ip>
$ sudo -i
```
Admin kubernetes config symlinked to /root/.kube/config. You can run further commands with root privilege

##### 5. Remove taints for single master configuration:
```console
# kubectl patch nodegroup master --type json -p '[{"op": "remove", "path": "/spec/nodeTemplate/taints"}]'
```

##### 5.1 Or you can add more nodes via this [guide](https://deckhouse.io/en/documentation/v1/modules/040-node-manager/faq.html#how-do-i-automatically-add-a-static-node-to-a-cluster)

## Run the tests
##### 1. Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI.
Like this:

```console
# wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
# tar xzf sonobuoy_0.56.10_linux_amd64.tar.gz
```

##### 2. Deploy a Sonobuoy pod to your cluster with:

```console
# ./sonobuoy run --mode=certified-conformance
```

##### 3. View actively running pods:

```console
# ./sonobuoy status
```

##### 4. To inspect the logs:

```console
# ./sonobuoy logs
```

##### 5. Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```console
# ./sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory. Extract the contents into `./results` with:

```console
# mkdir ./results; tar xzf *.tar.gz -C ./results
```

##### 6. To clean up Kubernetes objects created by Sonobuoy, run:

```console
# ./sonobuoy delete
```

