# puppetlabs-kuberetes

puppetlabs-kubernetes is a Puppet module designed to install and configure Kubernetes. To bootstrap a Kubernetes cluster in a secure and extensible way, this module uses the kubeadm toolkit. 

## Setup

[Install](https://puppet.com/docs/puppet/7/modules_installing.html) this module, [generate the configuration](#generating-the-module-configuration), [add the OS and hostname yaml files to Hiera](#adding-the-`{$OS}.yaml`-and-`{$hostname}.yaml`-files-to-Hiera), and [configure your node](#configuring-your-node).

Included in this module is [Kubetool](https://github.com/puppetlabs/puppetlabs-kubernetes/blob/master/tooling/kube_tool.rb), a configuration tool that auto-generates the Hiera security parameters, the discovery token hash, and other configurations for your Kubernetes cluster. To simplify installation and use, the tool is available as a Docker image.

### Generating the module configuration

If Docker is not installed on your workstation, install it from [here](https://docs.docker.com/install/).

The Kubetool Docker image takes each parameter as an environment variable.

**Note:**: The version of Kubetool you use must match the version of the module on the Puppet Forge. For example, if using the module version 1.0.0, use `puppet/kubetool:1.0.0`.

To output a yaml file into your working directory that corresponds to the operating system you want Kubernetes to run on, and for each controller node, run either of these `docker run` commands:

```
docker run --rm -v $(pwd):/mnt -e OS=ubuntu -e VERSION=1.16.6 -e CONTAINER_RUNTIME=docker -e CNI_PROVIDER=weave -e ETCD_INITIAL_CLUSTER=kube-master:172.17.10.101,kube-replica-master-01:172.17.10.210,kube-replica-master-02:172.17.10.220 -e ETCD_IP="%{networking.ip}" -e KUBE_API_ADVERTISE_ADDRESS="%{networking.ip}" -e INSTALL_DASHBOARD=true puppet/kubetool:{$module-version}
```

The above parameters are:

* `OS`: The operating system Kubernetes runs on.
* `VERSION`: The version of Kubernetes to deploy.
* `CONTAINER_RUNTIME`: The container runtime Kubernetes uses. Set this value to `docker` (officially supported) or `cri_containerd`. Advanced Kubernetes users can use `cri_containerd`, however this requires an increased understanding of Kubernetes, specifically when running applications in a HA cluster. To run a HA cluster and access your applications, an external load balancer is required in front of your cluster. Setting this up is beyond the scope of this module. For more information, see the Kubernetes [documentation](https://kubernetes-v1-4.github.io/docs/user-guide/load-balancer/).
* `CNI_PROVIDER`: The CNI network to install. Set this value to `weave`, `flannel`, `calico` or `cilium`.
* `CNI_PROVIDER_VERSION` The CNI version to use `calico` and `cilium` use this variable to reference the correct deployment file. Current version for `calico` is `3.6` and `cilium` is `1.4.3`
* `ETCD_INITIAL_CLUSTER`: The server hostnames and IPs in the form of `hostname:ip`. When in production, include three, five, or seven nodes for etcd.
* `ETCD_IP`: The IP each etcd member listens on. We recommend passing the fact for the interface to be used by the cluster.
* `KUBE_API_ADVERTISE_ADDRESS`: The IP each etcd/apiserver instance uses on each controller. We recommend passing the fact for the interface to be used by the cluster.
* `INSTALL_DASHBOARD`: A boolean which specifies whether to install the dashboard.

Kubetool creates:

* A yaml file that corresponds to the operating system specified by the `OS` parameter. To view the file contents, run `cat Debian.yaml` for a Debian system, or run `cat RedHat.yaml` for RedHat. The yaml files produced for each member of the etcd cluster contain certificate information to bootstrap an initial etcd cluster. Ensure these are also placed in your hieradata directory at the node level.

* A discovery token hash and encoded values required by Kubernetes. To regenerate the values, including certificates and tokens, run the `kubetool` command again.

### Adding the `{$OS}.yaml` and `{$hostname}.yaml` files to Hiera

Add the `{$OS}.yaml` file to the same [control repo](https://puppet.com/docs/pe/2018.1/control_repo.html) where your [Hiera](https://puppet.com/docs/hiera) data is, usually the `data` directory. By leveraging location facts, such as the [pp_datacenter](https://puppet.com/docs/puppet/5.5/ssl_attributes_extensions.html#reference-5482) [trusted fact](https://puppet.com/docs/puppet/5.5/lang_facts_and_builtin_vars.html#trusted-facts), each cluster can be allocated its own configuration.

### Configuring your node

After the `{$OS}.yaml` and `{$hostname}.yaml` files have been added to the Hiera directory on your Puppet server, configure your node as the controller or worker.

A controller node contains the control plane and etcd. In a production cluster, you should have three, five, or seven controllers. A worker node runs your applications. You can add as many worker nodes as Kubernetes can handle. For information about nodes in Kubernetes, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/architecture/nodes/#what-is-a-node).

**Note:**: A node cannot be a controller and a worker. It must be one or the other.

To make a node a controller, add the following code to the manifest:

```puppet
class {'kubernetes':
  controller => true,
}
```

To make a node a worker, add the following code to the manifest:

```puppet
class {'kubernetes':
  worker => true,
}
```

- Alternatively the module can be deployed locally following the instructions here: https://github.com/puppetlabs/kream

## Reproduce Conformance Tests

Download the last binary release of Sonobuoy matching the Kubernetes version you have deployed.

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.16.5/sonobuoy_0.16.5_linux_amd64.tar.gz
```

Run Sonobuoy on the cluster
```
$ sonobuoy run --mode=certified-conformance
```

Get the results on local
```
$ sonobuoy retrieve .
```

Clean up Kubernetes objects created by Sonobuoy
```
$ sonobuoy delete
```

For more details on running conformance tests see follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running).