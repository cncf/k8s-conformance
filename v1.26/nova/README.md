# Nova Container Platform Conformance testing

## Setup Nova Container Platform cluster

1. Request a license key from https://www.orionsoft.ru/nova#form.

2. Pull and run `nova-ctl` installer image locally.

```
docker run -it -v $PWD:/opt/nova hub.nova-platform.io/public/nova/nova-ctl:v2.3.0
```

3. Run `nova-ctl init` and follow the instructions to generate installation manifests.

```
# nova-ctl init
```

4. Use `nova-deployment-conf.yaml` manifest from the previous step to prepare  cluster specification.

5. Run `nova-ctl bootstrap` to provision a cluster. When the cluster deployment completes, directions for accessing your cluster display in your terminal.

> NOTE: Run `nova-ctl help bootstrap` to see available command options.

6. Set the environment variable KUBECONFIG pointing to your `kubeadmin.conf` from the previous step.

```
export KUBECONFIG=PATH_TO_YOUR_KUBECONFIG
```

> NOTE: Detailed instructions how to prepare and install Nova Container Platform can be found under https://docs.nova-platform.io/2.3/installing/run-on-any-platform/.

## Run conformance tests

1. By default Nova Container Platform contains at least one `infra` node with taints which conformance testing pods can not tolerate. Below commands remove all taints from `infra` nodes. Once conformance testing is completed, you should restore taints back to default.

Get a list of your infra nodes:

```
kubectl get node -l node-role.kubernetes.io/infra=""
```

Remove node taints:

```
kubectl patch node <name_of_your_node> -p '{"spec":{"taints":[]}}'
```

2. Follow the [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance tests.

```
sonobuoy run --mode=certified-conformance
```

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```