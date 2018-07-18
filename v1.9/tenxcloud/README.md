# TenxCloud Container Service
Cloud native platform based on Kubernetes.

## How to Reproduce

SSH to the node that will be the k8s master:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v3.0.0 Init)"

# wait for the process to be completed.
```

SSH to the nodes that will be the k8s nodes, run the command below on each one:
```
$ sudo bash -c "$(docker run --rm -v /tmp:/tmp index.tenxcloud.com/tenx_containers/tde:v3.0.0 --token <bootstrap_token> --ca-cert-hash <ca-cert-hash> Join <master>)" 

# wait for the process to be completed.
```

Run the conformance test following the official guide:
```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f sonobuoy -n sonobuoy

# wait for the message below in the log
# no-exit was specified, sonobuoy is now blocking
```

Get the results:
```
$ kubectl cp sonobuoy:/tmp/sonobuoy/ ./results -n sonobuoy
$ tar xf results/*.tar.gz
```

Then grab `plugins/e2e/results/{e2e.log,junit_01.xml,nethealth.txt}`, add them to this PR.

Run 'kubectl version > version.txt' to get the version info, and add it to this PR.
