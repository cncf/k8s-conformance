How to validate / reproduce [CNCF Kubernetes Conformance](https://github.com/cncf/k8s-conformance):

Setup a new kubedee instance on Hetzner Cloud with terraform; the module
can be found at https://github.com/schu/kubedee/tree/master/contrib/terraform/hetzner-cloud

Copy `terraform.tfvars.example` to `terraform.tfvars`, add your token
and sshkey name and run terraform:

```
terraform init
terraform apply
```

When applied successfully, the `admin.kubeconfig` for the cluster can
be found in this directory.

Export the `admin.kubeconfig` file for the cluster:

```
export KUBECONFIG=.../contrib/terraform/hetzner-cloud/admin.kubeconfig
```

Get the latest version of sonobuoy:

https://github.com/vmware-tanzu/sonobuoy/releases

Run sonobuoy:

```
sonobuoy run --wait
```

Wait for sonobuoy to finish (`sonobuoy status` and `sonobuoy logs` can
be run while waiting).

Retrieve the test result:

```
outfile="$(sonobuoy retrieve)"
```

Unpack it:

```
mkdir results
tar xvf "${outfile}" -C ./results/
```

Copy the required test log files:

```
cp results/plugins/e2e/results/* ...
```

`e2e.log` contains the human-readable log.

Finally, submit the conformance results:

https://github.com/cncf/k8s-conformance/blob/master/instructions.md
