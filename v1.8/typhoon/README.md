Conformance report created with:

* Commit: 878f5a3647af3a29059876d68844f15089908eb1
* Platform: bare-metal
* k8s-conformance: 4a2f97a41886b0b4b9d27c71d9072e4150fcf735

## Recreate

1. Install a [Typhoon cluster](https://typhoon.psdn.io/bare-metal/).
2. Use the generated `kubeconfig` in `assets_dir/auth/kubeconfig`.

```
export KUBECONFIG=path/to/assets_dir/auth/kubeconfig
```

3. Run the sonobuoy conformance tests. 

```
curl -L https://github.com/cncf/k8s-conformance/blob/4a2f97a41886b0b4b9d27c71d9072e4150fcf735/sonobuoy-conformance.yaml 
```

4. Follow the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to collect the logs.
