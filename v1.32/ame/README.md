# Conformance tests for Avisi Cloud AME

## Cluster setup to reproduce using AWS as the cloud provider

### Prerequisites

- Access to an organization which has an [AWS cloud account][createCloudAccount] configured
- Our CLI `acloud` installed (`brew install avisi-cloud/tools/acloud --cask`)

[createCloudAccount]: https://docs.avisi.cloud/docs/product/tasks/how-to/how-to-cloud-accounts#creating-a-cloud-account

### Steps

#### 1. Login to AME and create a context

```bash
acloud auth login --create-context
```

#### 2. Switch to the organization with the cloud account you want to use

```bash
acloud config use-organisation <your-org>
```

#### 3. Create the cluster

To create the cluster you'll need to know the cloud account identity and region. You can find those in the AME Console or by using the `acloud` CLI:

```bash
acloud cloud-accounts get
```

Create the cluster using the information gathered from the above command:

```bash
acloud clusters create --name k8s-conformance --cloud-account <cloud-account-identity> --region <region> --environment development
```

#### 4. Open shell with kubeconfig set to new cluster

After the cluster has been provisioned, you can open a shell with the kubeconfig set to the new cluster:

```bash
acloud shell <organization>/development/k8s-conformance
```

Or, if you have `fzf` installed, you can just run the command without the parameters and it will open fuzzy finder to select the cluster:

```bash
acloud shell
```

#### 5. Run the conformance tests

```bash
go get -u -v github.com/vmware-tanzu/sonobuoy

sonobuoy run --mode=certified-conformance

sonobuoy retrieve ./results
```
