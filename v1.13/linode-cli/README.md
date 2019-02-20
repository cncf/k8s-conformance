# linode-cli

The Linode CLI is a tool for managing Linode infrasture, which includes plugins such as the `k8s-alpha` plugin, described at https://linode.com/kubernetes .

## Requirements

You will need a [Linode account](https://login.linode.com/signup) and a [Linode APIv4 Personal Access Token](https://developers.linode.com/api/v4#section/Personal-Access-Token).

```
$ pip install --upgrade linode-cli
```

## Provision a Cluster

Create a cluster using the Linode CLI.

```console
linode-cli k8s-alpha create \
  --region=us-east \
  --master-type=g6-standard-2 \
  --node-type=g6-standard-2 \
  --ssh-public-key=~/.ssh/id_rsa.pub \
  --nodes=3 \
  k8s-conformance
```

The `linode-cli` command will inject the cluster context into the `kubectl` config.  The configuration file can be accessed directly at `~/.k8s-alpha-linode/k8s-conformance/k8s-conformance.conf` (where `k8s-conformance` is replaced with the cluster name).

After waiting for the process to complete, inspect the running pods with:

```
kubectl get --all-namespaces pods
```

## Run Sonobuoy

From this point on we follow [the official conformance instructions](https://github.com/cncf/k8s-conformance/blob/fcedf22631ea53912232a235633407242a65cb07/instructions.md).

Running all the conformance tests often takes about an hour.

```bash
# start sonobuoy
sonobuoy run
# wait for the run to complete
sonobuoy logs -f
```

## Obtain the Conformance Results

When you see `level=info msg="no-exit was specified, sonobuoy is now blocking"`
in the sonobuoy logs, you can fetch your test results.

```bash
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Your untarred results should now be in `results` on your host machine.

The needed test files are:

- `results/plugins/e2e/results/e2e.log`
- `results/plugins/e2e/results/junit_01.xml`

## Cleanup

Delete the cluster with:

```bash
linode-cli k8s-alpha delete k8s-conformance
```
