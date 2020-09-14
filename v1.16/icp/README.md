# To reproduce:

## Create IBM Cloud Private Cluster

Take IBM Cloud Private Cluster community edition as an example. Of course you can install the enterprise edition once you get license and follow doc [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.2.1/installing/installing.html)

1) Pull the installation image from docker hub.
```
docker pull ibmcom/icp-inception:3.2.1
```

2) Get cluster installation configuration.
```
docker run --rm -e LICENSE=accept -t -v $(wd):/data ibmcom/icp-inception:3.2.1 cp -r /installer/cluster /data/
```
The command will copy the installtion template to the current directory.

Plan your cluster with master, management, proxy and worker nodes. Add your cluster topology in `cluster/hosts` file.

Configure passwordless ssh access between your boot node to other cluster nodes. Add your private ssh key to `cluster/ssh_key` file

There are many other cluster configurations in `cluster/config.yaml`. You can refer to [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.2.1/installing/install_configuration.html) for more detail. For a simple installation you can keep them all default.

3) Install your cluster

Get into the installation director and run below command.
```
docker run --rm -e LICENSE=accept -t -v $(pwd):/installer/cluster --net host ibmcom/icp-inception:3.2.1 install
```

Be patient and wait for the installation to be finished.


## Config kubectl CLI

1) Get IBM Cloud Private CLI cloudctl
```
docker run --rm -e LICENSE=accept -t -v /usr/local/bin:/data ibmcom/icp-inception:3.2.1 cp /usr/local/platform-api/cloudctl /data/
```

2) Logon the cluster via cloudctl CLI
```
cloudctl login -a https://<cluster url>/ -u admin -p <admin password> --skip-ssl-validation
```

The cloudctl CLI will help configure kubectl on the node.


## Launch e2e Conformance Tests

1) Change default image policy of ICP cluster to allow all. Run the following command to update the image policy

```
kubectl edit clusterimagepolicy ibmcloud-default-cluster-image-policy
```

For exmaple, a wildcard (*) character is allowed in the repository name. You can also refer to [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.2.1/manage_images/image_security.html) for more detail.

```
    - name: "*"
```


2) Run the conformance test

The standard tool for running these tests is [Sonobuoy](https://github.com/heptio/sonobuoy). Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```console
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```console
$ sonobuoy run --mode=certified-conformance
```

View actively running pods:

```console
$ sonobuoy status
```

To inspect the logs:

```console
$ sonobuoy logs
```

Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

```console
$ sonobuoy retrieve .
```

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

```console
mkdir ./results; tar xzf *.tar.gz -C ./results
```

NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

```console
sonobuoy delete
