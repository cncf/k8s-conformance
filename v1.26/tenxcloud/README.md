# TenxCloud Container Service
Cloud native PaaS based on Kubernetes.

## Setup a Kubernetes cluster using TenxCloud Deployment Engine (tde)

1. SSH to the node that will be the K8s master:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v5.6.0 --registry index.tenxcloud.com Init)"

# wait for the process to be completed.
```

2. You'll see the prompted messages at the bottom about how to add woker nodes:
```
Your Kubernetes control-plane has initialized successfully!

Then you can join any number of worker nodes by running the following on each as root:

sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/system_containers/tde:v5.6.0 --registry index.tenxcloud.com --token <bootstrap_token> --ca-cert-hash <ca-cert-hash> Join <master>)"

Kubernetes Enterprise Edition cluster deployed successfully
```

3. Then SSH to the nodes that will be the K8s nodes, run the command below on each one:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v5.6.0 --token <bootstrap_token> --ca-cert-hash <ca-cert-hash> Join <master>)"

# wait for the process to be completed.
```
Then you'll have a Kubernetes cluster ready for conformance test.

## Run the conformance test following the official guide

Download a binary release of the sonobuoy CLI from https://github.com/heptio/sonobuoy/releases ：
```
$ sonobuoy run --mode=certified-conformance

$ sonobuoy logs -f

# wait for the message below in the log
# no-exit was specified, sonobuoy is now blocking
```

Get the results:
```
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results
```

Then grab `plugins/e2e/results/global/{e2e.log,junit_01.xml}` from results folder, add them to this PR.
