# Conformance testing kubernetes fury aws

## Steps to reproduce

- Install kubernetes-fury-aws following the [documentation](https://github.com/sighupio/fury-kubernetes-aws/blob/master/README.md)
- `get -u -v github.com/heptio/sonobuoy`
- `sonobuoy run --kubeconfig [path to kubeconfig]`
- `sonobuoy retrieve . --kubeconfig [path to kubeconfig]`
- `mkdir ./results; tar xzf *.tar.gz -C ./results`
