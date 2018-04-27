Conformance report created with:

* Platform: bare-metal (packet.net)

## Recreate

1. Install a [Kontena Pharos](https://www.pharos.sh/docs/install.html) cluster.
2. SSH into master host.
3. Run the sonobuoy conformance tests.

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

4. Follow the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to collect the logs.
