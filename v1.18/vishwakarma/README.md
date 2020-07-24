# vishwakarma

## Setup
1. Clone [Vishwakarma](https://github.com/getamis/vishwakarma.git) from GitHub to local, and execute the following command:

```sh
$ git clone https://github.com/getamis/vishwakarma.git
$ cd examples/kubernetes-cluster
```

2. Sign up for [AWS](https://aws.amazon.com/).
3. Configure your AWS credentials using one of the [supported methods for AWS CLI
   tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html), such as setting the
   `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. If you're using the `~/.aws/config` file for profiles then export `AWS_SDK_LOAD_CONFIG` as "True".
4. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.

5. Execute the following command to setup:

```sh
# initial for sync terraform module and install provider plugins
$ terraform init

# create the network infrastructure
$ terraform apply -target=module.network

# create the kubernetes master compoment
$ terraform apply -target=module.master

# create the general and spot k8s worker group
$ terraform apply
```

6. Get the kubeconfig from AWS S3(The bucket name looks like test-getamis-xxxxxxxx), and execute the following command to check nodes:

```sh
$ kubectl get node

NAME                          STATUS    ROLES     AGE       VERSION
ip-10-0-48-247.ec2.internal   Ready     master    9m        v1.18.6
ip-10-0-48-117.ec2.internal   Ready     master    9m        v1.18.6
ip-10-0-66-127.ec2.internal   Ready     on-demand 5m        v1.18.6
ip-10-0-66-127.ec2.internal   Ready     on-demand 6m        v1.18.6
ip-10-0-71-121.ec2.internal   Ready     spot      3m        v1.18.6
ip-10-0-86-182.ec2.internal   Ready     spot      4m        v1.18.6
```

## Reproduce Conformance Results

Use the `sonobuoy` command line tool (requires Go).

```
go get -u -v github.com/vmware-tanzu/sonobuoy
sonobuoy run
sonobuoy status
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Inspect the results in `plugins/e2e/results/{e2e.log,junit.xml}`.

When you're done, execute below command to destroy:

```sh
$ terraform destroy -target=module.worker_on_demand
$ terraform destroy -target=module.worker_spot
$ terraform destroy -target=module.master
$ terraform destroy -target=module.network
```