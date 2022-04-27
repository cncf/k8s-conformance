# KubeOne

https://github.com/kubermatic/kubeone

Official documentation: https://github.com/kubermatic/kubeone/tree/master/docs

By following these steps you may reproduce the KubeOne Conformance e2e
results.

## Downloading KubeOne

The latest version of KubeOne can be downloaded from the [GitHub Releases][kubeone-releases].
In order to manage Kubernetes v1.18 clusters, KubeOne v0.11.1 or newer is required.

The KubeOne binary comes along with the Terraform configurations used to create the
needed infrastructure for all supported providers. The configurations can be found
in the `./examples/terraform` directory.

## Creating infrastructure

In order to install Kubernetes using KubeOne, you need to have infrastructure
on which you will install and provision Kubernetes control plane.

You can create the infrastructure manually or use the provided
[Terraform configurations][terraform-config].

In case you decide to use Terraform, you need to install Terraform v0.12+ by following
the [official installation instructions][terraform-install].

With Terraform in place, select the provider which you want to use and
check out the appropriate KubeOne [quickstart guide][kubeone-quickstart]
to find out how to use the Terraform configuration for the selected provider.
This document shows how to do it for AWS.

### Using the provided AWS Terraform configuration

First, switch to the directory containing the Terraform configuration for AWS:
```
cd ./examples/terraform/aws
```

Create the `terraform.tfvars` file and define the following variables:
```
cluster_name = "k8s-conformance" # name of the cluster

ssh_public_key_file = "~/.ssh/id_rsa.pub" # ssh key to be deployed on instances

open_nodeports = true # open nodeports required for conformance tests to pass
```

With the `terraform.tfvars` file in place, create the infrastructure by
running the following Terraform command:
```
terraform apply
```
The command will show what steps will be taken and will ask for the user confirmation.
Once asked, type `yes` to proceed with the creation. The command will take 2-3 minutes
to finish creating the infrastructure.

Finally, save the Terraform output by running the following command. The Terraform
output is parsed by KubeOne to determine the information about the infrastructure.
```
terraform output -json > tf.json
```

## Provisioning the cluster

Once you have the needed infrastructure and instances, you will
need a KubeOne configuration manifest which describes the desired
cluster.

If you used the provided Terraform configuration to provision the infrastructure,
KubeOne can read the Terraform's output to find out information about the
infrastructure and information needed to create worker nodes. Otherwise, you need
to provide those information manually. You can run `kubeone config print -f` for the
configuration file reference.

You can use the following configuration manifest:
```yaml
apiVersion: kubeone.io/v1alpha1
kind: KubeOneCluster
versions:
  kubernetes: '1.18.0'
cloudProvider:
  name: 'aws'
```

The cluster is provisioned using the following command, where `config.yaml`
is the configuration manifest and `tf.json` is output from the
`terraform output -json` command:
```
kubeone install config.yaml -t tf.json
```

**Note:** If you are getting errors related to SSH, please check the
[SSH requirements document][kubeone-ssh].

Once the command is done, wait several minutes for the worker nodes to get
created and appear. You can check the progress by running `kubectl get nodes`.
There should be 3 control plane nodes and 3 worker nodes ready.

Finally, run the conformance tests using Sonobuoy.
You can find the instructions for running conformance tests [here][sonobuoy].

## Cleanup

Before destroying the infrastructure, run the following command
to destroy the worker nodes and revert what has been done by KubeOne:

```
kubeone reset config.yaml -t tf.json
```

Then proceed to destroy the infrastructure. If you used Terraform,
that can be done by running the `terraform destroy` command.

[kubeone-releases]: https://github.com/kubermatic/kubeone/releases
[terraform-config]: https://github.com/kubermatic/kubeone/tree/master/examples/terraform
[terraform-install]: https://learn.hashicorp.com/terraform/getting-started/install.html
[kubeone-quickstart]: https://github.com/kubermatic/kubeone/tree/master/docs#documentation-index
[kubeone-ssh]: https://github.com/kubermatic/kubeone/blob/master/docs/ssh.md
[sonobuoy]: https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running
