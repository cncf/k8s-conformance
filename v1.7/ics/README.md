To reproduce:

```
% bx cs cluster-create --name conformance
% $(bx cs cluster-config conformance | grep export)
% curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -
% kubectl logs -f -n sonobuoy sonobuoy

# wait for "no-exit was specified, sonobuoy is now blocking"

% kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
