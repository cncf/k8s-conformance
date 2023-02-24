# Civo Kubernetes - Managed-K3s

To reproduce, signup for a free account at https://www.civo.com and then use the API key
(from https://www.civo.com/api once you're signed in) and the CLI with the following steps:

```
brew install cli # or from https://github.com/civo/cli#set-up
civo apikey save k8s-conformance $API_KEY
civo apikey use k8s-conformance
civo kubernetes create --cluster-type talos --version 1.25.5  conformance --wait
civo k3s config conformance > ~/civo-k3s
export KUBECONFIG=~/civo-k3s
sonobuoy run --mode=certified-conformance --kubernetes-version=v1.23.6 --plugin e2e
```
