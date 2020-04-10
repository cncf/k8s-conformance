The following instructions will allow you to set up an environment capable of running the Sonobuoy
conformance e2e tests.

# Getting an account

Users can create a free account with the Platform9 free tier.

Sign up at https://platform9.com/.  Click `Deploy A Cluster Now` from the home page.

After a short while you will receive an email with login credentials.  Log into your environment.

# Provisioning infrastructure

There are multiple options for provisioning infrastructure.  The easiest option is to provide your
public cloud credentials to Platform9.  Other valid options are manually provisioned instances
with KVM, VirtualBox, and even bare metal nodes.  Ubuntu 16.04 (18.04 coming soon) is required if you
provide your own instances / nodes.

## Option 1: Create an AWS cloud provider

Click `Infrastructure`, then `Cloud Providers`, `Add Cloud Provider`, choose `AWS`.

Enter in your credentials.  For AWS pre-requisites see https://docs.platform9.com/kubernetes/public-cloud/aws-prerequisites.

## Option 2: Manually provision nodes

Create 4 instances by whatever means are convenient to you.  They will need to be running Ubuntu 16.04.

In the Platform9 web console click `Infrastructure`, then `Clusters`, then `Add Cluster`.

Select Bare OS and follow the instructions on the screen to make the nodes available to the Platform9 management plane.

You will need to download and run the CLI tool to your nodes, then provide the credentials to your Platform9 management account.

# Create the cluster

## Option 1: AWS

Click `Infrastructure`, then `Clusters`, then `Add Cluster`.

Choose AWS.

Choose a name for your cluster and select the `cloud provider` you created in the previous step.

For the `Cluster Template` field choose the medium or large option (multiple nodes are required to run all the conformance tests).

Choose whatever region and AZ's are appropriate for your account.

Click `Next`.

For the `Domain` field choose `platform9.net`.

Click `Next` repeatedly, continuing through the defaults until you provision the cluster.

## Option 2: BareOS

Provision 4 Ubuntu 16.04 instances or bare metal nodes however you want.  These can be instances from your favorite cloud provider, KVM,
and even VirtualBox instances.

Click `Infrastructure`, then `Clusters`, then `Add Cluster`.

Choose `BareOS`.

Choose a name for your cluster.

Click `Get the PF9 CLI` for instructions on how to download the Platform9 CLI and prep your nodes.

The CLI will prompt your for your management plane login.  These are available in the web UI right below the download link.

After running the `pf9ctl cluster prep-node` command the nodes will show up in the management plane under `Infrastructure` -> `Nodes`.

Once the nodes are prepped, click `Infrastructure`, `Clusters`, `Add Clusters`.

Select `BareOS`.

Choose a name for your cluster.

Choose one of your nodes for the master then click `Next`.

Choose the remaining 3 nodes for the worker nodes.  Click `Next`.

Click `Finish and Review` and create your cluster.

# Obtain your KUBECONFIG

After a short time your cluster will be available and appear in the cluster list (available under Instrastructure in the left side navigation).

In the cluster listing, click `Download KubeConfig`.

Leave it at the default `Token` option and download the config.

# Set the KUBECONFIG

Copy your downloaded KUBECONFIG file to whatever machine you will run the Sonobuoy tests from.  It will be named `${CLUSTER_NAME}.yaml`.

Set the KUBECONFIG environment variable:

`export KUBECONFIG=/path/to/mycluster.yaml`

# Run the tests

Download Sonobuoy and run the tests by following the instructions at: https://github.com/cncf/k8s-conformance/blob/master/instructions.md.

# Clean up (optional)

Feel free to delete the cluster when you are done in the Platform9 management web console.

Click `Infrastructure` then `Clusters`.

Select the cluster you want to delete.

Click `Delete` at the top of the cluster table.
