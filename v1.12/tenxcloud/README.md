# TenxCloud Container Service
Cloud native platform based on Kubernetes.

## How to Reproduce

SSH to the node that will be the k8s master:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v4.0 Init)"

# wait for the process to be completed.
```

SSH to the nodes that will be the k8s nodes, run the command below on each one:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v4.0 --token <bootstrap_token> --ca-cert-hash <ca-cert-hash> Join <master>)"

# wait for the process to be completed.
```

Run the conformance test following the official guide:
```
Download a binary release of the sonobuoy CLI from https://github.com/heptio/sonobuoy/releases：

$ sonobuoy run

$ sonobuoy logs -f

# wait for the message below in the log
# no-exit was specified, sonobuoy is now blocking
```

Get the results:
```
$ sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```

Then grab `plugins/e2e/results/{e2e.log,junit_01.xml,nethealth.txt}` from results folder, add them to this PR.

Run 'kubectl version > version.txt' to get the version info, and add it to this PR.
