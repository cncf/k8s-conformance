# Kubernetes Conformance Tests for YAOOK/k8s

## Steps to Create a YAOOK/k8s Cluster on OpenStack

Follow the instructions to create a YAOOK/k8s cluster on OpenStack and continue with the next steps:

1. Log in to the OpenStack Dashboard
Access the OpenStack dashboard using your credentials.
2. Select Project
From the drop-down menu, choose the project for which you need to download the OpenStack RC file.
3. Load OpenStack RC File
Source the openrc.sh file to populate the necessary environment variables `source openrc.sh`.
4. Test OpenStack platform
Verify your OpenStack setup by running: `openstack server list`.
5. Install System Requirements
[Ensure all necessary system dependencies are installed on your local machine.](https://yaook.gitlab.io/k8s/release/v6.1/user/guide/initialization.html#initialization-install-system-requirements)
6. Create Required Resources
[Set up the resources needed for the Kubernetes cluster.](https://yaook.gitlab.io/k8s/release/v6.1/user/guide/initialization.html#initialization-required-system-resources)
7. Initialize Cluster Repository
[Prepare the cluster repository for further configuration.](https://yaook.gitlab.io/k8s/release/v6.1/user/guide/initialization.html#initialization-create-and-initialize-cluster-repository)
8. Configure Kubernetes Cluster
[Specify your Kubernetes cluster settings](https://yaook.gitlab.io/k8s/release/v6.1/user/reference/cluster-configuration.html) in `config.toml` configuration file.
9. Initialize Vault
[Set up and initialize HashiCorp Vault for secure secret management.](https://yaook.gitlab.io/k8s/release/v6.1/user/guide/initialization.html#initialization-initialize-vault-for-a-development-setup)
10. Deploy the Cluster
Deploy cluster by executing the `./managed-k8s/actions/apply-all.sh` script.

## Run Conformance Test

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to trigger the tests and get back the results.

1. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of sonobuoy:
```sh
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
$ tar -xfz sonobuoy_0.57.1_linux_amd64.tar.gz 
```

2. Run sonobuoy:
```sh
$ ./sonobuoy version
$ ./sonobuoy run --mode certified-conformance
```

3. Check the status:
```sh
$ ./sonobuoy status
```

4. Inspect the logs:

```sh
$ sudo ./sonobuoy logs
```

5. Retrieve results and extract plugins/e2e/results/global/e2e.log and plugins/e2e/results/global/junit_01.xml required for submission
```sh
$ download=$(./sonobuoy retrieve)
$ mkdir ./sonoboy_results; tar xzf $download -C ./sonoboy_results
```
