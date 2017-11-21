# To reproduce

Follow steps from https://docs.mirantis.com/mcp/latest/mcp-deployment-guide/deploy-mcp-cluster-manually/deploy-kubernetes-cluster-manually/deploy-kubernetes.html

Adjust hyperkube image according to: https://docs.mirantis.com/mcp/latest/mcp-feature-update-notes/q4-17/s17/q417-s17-k8s.html

## Launch E2E Conformance Tests

`curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`

You can follow the steps descrbed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to get the test logs
