# KubeOne

https://github.com/kubermatic/kubeone

Official documentation: https://github.com/kubermatic/kubeone/tree/master/docs

By following these steps you may reproduce the KubeOne Conformance e2e
results.

## Creating infrastructure

In order to install Kubernetes using KubeOne, you need to have infrastructure
on which you will install and provision Kubernetes control plane.

You can create the infrastructure manually or use the provided [Terraform scripts][1].

In case you decide to use Terraform, you need to install Terraform by following the
[official installation instructions][2]. Note that KubeOne v0.9 and later
**require** Terraform **v0.12+**.

With Terraform in place, select the provider which you want to use and
check out the appropriate KubeOne [quickstart guide][3] to find out how
to use Terraform scripts for the selected provider. For example, the
[following guide][4] shows how to do it for AWS.

## Provisioning the cluster

Once you have the needed infrastructure and instances, you will
need a KubeOne configuration manifest which describes the desired
cluster.

If you used the provided Terraform scripts to provision the infrastructure,
KubeOne can read the Terraform's output to find out information about the
infrastructure and information needed to create worker nodes.

In such case, you can use the following configuration manifest:
```yaml
apiVersion: kubeone.io/v1alpha1
kind: KubeOneCluster
versions:
  kubernetes: '1.15.0'
cloudProvider:
  name: 'aws'
```

In case you didn't use Terraform, you can manually provide all needed
information. You can use `kubeone config print --full` command to print
the configuration file reference.

The cluster is provisioned using the following command, where `config.yaml`
is the configuration manifest and `tf.json` is output from the
`terraform output -json` command:

```
kubeone install config.yaml -t tf.json
```

Once the command is done, wait several minutes for the worker nodes to get
created and appear, and then run conformance tests using Sonobuoy.
You can find instructions for running conformance tests [here][5].

## Cleanup

Before destroying the infrastructure, run the following command
to destroy the worker nodes and revert what has been done by KubeOne:

```
kubeone reset config.yaml -t tf.json
```

Then proceed to destroy the infrastructure. If you used Terraform,
that can be done by using the `terraform destroy` command.

[1]: https://github.com/kubermatic/kubeone/tree/master/examples/terraform
[2]: https://learn.hashicorp.com/terraform/getting-started/install.html
[3]: https://github.com/kubermatic/kubeone/tree/master/docs#documentation-index
[4]: https://github.com/kubermatic/kubeone/blob/master/docs/quickstart-aws.md
[5]: https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running
