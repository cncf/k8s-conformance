# Symbiosis

The following commands were run to create a Symbiosis cluster for the purposes of running Kubernetes conformance tests. An admin api-key needs to be generated through the UI at https://app.symbiosis.host/api-keys after signing in.

```bash
# Create a single node Symbiosis cluster
curl -XPOST -H "Content-Type: application/json" -H "X-Auth-ApiKey: <SYMBIOSIS-API-KEY>" \
  -d '{"name": "symbiosis-conformance", "kubeVersion": "1.24.4", "regionName": "germany-1", "nodes": [{"quantity": 2, "nodeTypeName": "general-1"}]}' \
  https://api.symbiosis.host/rest/v1/cluster

# wait until cluster state is ACTIVE
curl -H "Content-Type: application/json" -H "X-Auth-ApiKey: <SYMBIOSIS-API-KEY>" \
  https://api.symbiosis.host/rest/v1/cluster/symbiosis-conformance

# Install jq tool to parse the kubeConfig from json
brew install jq

# Download the kubeconfig
curl -XPOST -H "Content-Type: application/json" -H "X-Auth-ApiKey: <SYMBIOSIS-API-KEY>" \
  https://api.symbiosis.host/rest/v1/cluster/symbiosis-conformance/user-service-account | jq -r '.kubeConfig' >symbiosis-cfg

# Run conformance tests
KUBECONFIG=symbiosis-cfg sonobuoy run --mode=certified-conformance
```
