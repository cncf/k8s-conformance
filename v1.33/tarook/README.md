# Kubernetes Conformance Tests for Tarook

## Steps to Create a Tarook Cluster

Follow the instructions to create a Tarook Kubernetes cluster on OpenStack and continue with the next steps:

1. Log in to the OpenStack Dashboard
Access the OpenStack dashboard using your credentials.
2. Select OpenStack Project
From the drop-down menu, choose the project for which you need to download the OpenStack RC file.
3. Load OpenStack RC File
Run `source openrc.sh` to populate the necessary environment variables for OpenStack.
4. Test OpenStack Platform
Execute `openstack server list` to verify OpenStack.
5. Install System Requirements
[Ensure all necessary system dependencies are installed on your local machine.](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/initialization.html)
6. Create Required Resources
[Set up the necessary resources.](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/initialization.html#required-system-resources)
7. Initialize Cluster Repository
[Prepare the cluster repository for further configuration.](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/initialization.html#create-and-initialize-cluster-repository)
8. Initialize Vault Backend
[Initialize HashiCorp Vault for secure secret management.](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/initialization.html#initialize-vault-secrets-backend)
9. Configure Cluster
[Specify your Kubernetes cluster settings](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/cluster.html) in `config/default.nix` configuration file. 
10. Configure Vault Backend
[Configure HashiCorp Vault for secure secret management.](https://docs.tarook.cloud/release/v10.1/user/guide/quick-start/vault.html)
11. Deploy Cluster
Run `./managed-k8s/actions/apply-all.sh` to start the deployment process.

## Run Conformance Test

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to trigger the tests and get back the results.

1. Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases).

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

5. Retrieve results and extract `plugins/e2e/results/global/e2e.log` and `plugins/e2e/results/global/junit_01.xml` required for submission
```sh
$ download=$(./sonobuoy retrieve)
$ mkdir ./sonoboy_results; tar xzf $download -C ./sonoboy_results
```
