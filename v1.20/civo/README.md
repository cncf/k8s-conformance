# Civo Kubernetes - Managed-K3s

To reproduce, signup for a free account at https://www.civo.com/kube100 and then use the API key
(from https://www.civo.com/api once you're signed in) and the CLI with the following steps:

```
brew install cli # or from https://github.com/civo/cli#set-up
civo apikey save k8s-conformance $API_KEY
civo apikey use k8s-conformance
civo k3s create test-cluster --wait
civo k3s config test-cluster > ~/civo-k3s
export KUBECONFIG=~/civo-k3s

sonobuoy run --mode=certified-conformance
```
