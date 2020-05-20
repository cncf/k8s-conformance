# Conformance tests for the asus-cloudinfra

## System requirements

* CentOS 7
* 2 GB or more of RAM per machine
* 2 CPUs or more
* Swap disabled
* At least 3 master nodes

## Install Highly-Available Kubernetes Cluster

Installation instructions will be available at https://www.asuswebstorage.com/navigate/a/#/s/1CB3AB7F5FA548F1A98B2FD69DD48A91Y when asus-cloudinfra goes public.

After installation, please wait some time for the cluster to run.

Note: Kubernetes v1.16 conformance tests require NodePort ports to be added to the control plane and workers firewall (SecurityGroup in case of AWS), so Services can be reached externally. By default, those ports are 30000-32767.


## Run the conformance tests

Follow the official guide: https://github.com/revelrylabs/k8s-conformance/blob/master/instructions.md


1. Once you HA Kubernetes cluster is active, Login to any master nodes.

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
$ sonobuoy run --mode certified-conformance
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ outfile=$(sonobuoy retrieve)
```

7. This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```