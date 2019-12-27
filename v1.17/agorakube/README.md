# Agorakube

Official documentation:
 - https://github.com/ilkilab/agorakube
 - https://github.com/ilkilab/agorakube/blob/master/docs/instructions.md

By following these steps you may reproduce the Agorakube Conformance e2e
results.

# Install Agorakube For Local Development & CNCF Conformance Test Environment

You can create a local environment by using Vagrant. 
The document below describes pre-requisites for Agorakube local environment and how you can start using them.

## Pre-requisites

* Vagrant
* VirtualBox

## Environment customization

There are two files which can be modified to customize the local environment, especially in terms of number of nodes. By default, it works with single node which acts as : 
- Agorakube deployment node used to deploy all components
- master and worker node for Kubernetes

The configuration files for Vagrant based local environment are located in [test_lab folder](/test_lab).

**Note :** First, you can choose the base OS (Ubuntu or CentOS) of you local environment by modifying [Vagrantfile](/test_lab/Vagrantfile). 

If you want to change the number of nodes :
1. You can first modify the [Vagrantfile](/test_lab/Vagrantfile) by uncommenting blocks corresponding to node1 and node2.
   - **Note :** Only uncomment the lines between *# Node[12] Block START* and *# Node[12] Block END*
2. Next, adjust [hosts.vagrant](/test_lab/hosts.vagrant) file accordingly by uncommenting the desired lines.
   - **Note :** Make sure to update the *advertise_ip_masters* :
     - In case of a single node deployment (default), the IP must correspond to the deployment node IP
     - In case of multi-node deployment, the IP must correspond to the node1 IP 
    

## Start the environment

1) Simply open a terminal and goto test_lab folder and then run the following command:

`vagrant up`

2) One Agorakube installation is finished, connect to the deploy manachine with the following command:

`vagrant ssh deploy`

3) Kubernetes CLI "kubectl" is configured for root user, so use the following command to become root:

`sudo su`

4) You can now enjoy your Agorakube/K8S fresh cluster ! Use the following command to print K8S version:

`kubectl version`

# Run Conformance Test

1. Once you AgoraKube Kubernetes cluster is active, Fetch it's kubeconfig.yaml file (located in the /root/.kube/config file on the deploy machine) and save it locally.

2. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

3. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
$ mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

7. To clean up Kubernetes objects created by Sonobuoy, run:

```
$ sonobuoy delete
```
