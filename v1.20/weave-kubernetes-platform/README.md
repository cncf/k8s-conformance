## To Reproduce:

Submit your contact details on https://www.weave.works/contact/ to receive a `wk` binary, the command line tool for Weave Kubernetes Platform, and your entitlements file.

#### Prerequisites

On the computer that will be used for the installation, you need to install:

- [git](https://www.atlassian.com/git/tutorials/install-git)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- The `wk` binary. You can ensure it is in your path by running `wk version`

1. Make sure your entitlements file exists at `~/.wks/entitlements`
1. Make sure to know the location of a file that contains your dockerhub password, perhaps use `~/.wks/dockerhub-password` if you wish.
1. Have the IP addresses for your nodes handy.
1. Make sure the nodes are running a supported VM (presently, only Centos 7 and RHEL 7 are supported)
1. Ensure that the following ports are open on the hosts:

  - 6443 (kubernetes api server)
  - 2379-2380 (etcd)
  - 6783-6784 (weave net)
  - 10250 (container logs)
  - 32000-32767 (node ports)

#### Install WKP on SSH Nodes

1. In a new directory, run

   ```bash
   wk setup install
   ```

1. Edit `./setup/config.yaml`:
   - ensure `track` is set to `wks-ssh`
   - set `gitProvider` to github, and `gitProviderOrg` to your github user
   - set `dockerIOUser` to your docker.io user and `dockerIOPasswordFile` to a file containing your docker.io password
   - follow the directions above `wksConfig.sshConfig.machines` to enter the IP addresses of your nodes
     - make sure your `sshUser` matches your ssh key's user configured on your nodes
     - make sure to populate the `sshKeyFile` field
       - make sure your ssh user corresponding to your `sshKeyFile` has passwordless sudo permissions on each machine
     - make sure to add the machines to the `machines` array following the documentation in the `config.yaml` file

1. run

   ```bash
   wk setup run
   ```

At the end of the cluster creation, the `KUBECONFIG` file at `~/.kube/config` will be updated to connect to the new cluster.

#### Run sonobuoy tests

Install sonobuoy:

```bash
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.50.0/sonobuoy_0.50.0_linux_amd64.tar.gz
tar -xvzf sonobuoy_0.50.0_linux_amd64.tar.gz
chmod +x sonobuoy
mv ./sonobuoy /usr/local/bin/sonobuoy
```

and run:

```bash
sonobuoy run --wait --wait-output Spinner --mode certified-conformance
results=$(sonobuoy retrieve)
sonobuoy results $results
```