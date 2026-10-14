# Civo Kubernetes - Managed-K3s

To reproduce, signup for a free account at https://www.civo.com and then use the API key
(from https://www.civo.com/api once you're signed in) and the CLI with the following steps:

```
brew install cli # or from https://github.com/civo/cli#set-up
civo apikey save k8s-conformance $API_KEY
civo apikey use k8s-conformance
civo k3s create test-cluster -v 1.35.0-k3s1 --wait
civo k3s config test-cluster > ~/civo-k3s
export KUBECONFIG=~/civo-k3s
sonobuoy run \
        --mode=certified-conformance \
        --kubernetes-version=v1.35.0 \
        --plugin e2e \
        --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller --ginkgo.flake-attempts=6 --ginkgo.v"

```
