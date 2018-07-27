# Docker Desktop for Mac

## Reproduce conformance results

1. Download and  install Docker Desktop for Mac 18.06.0-ce-mac70 (Stable channel) : https://download.docker.com/mac/stable/26399/Docker.dmg
2. In Docker Desktop preferences, in the Kubernetes pane, enable Kubernetes to create a cluster on your local machine. 
3. Follow conformance test instructions from https://github.com/cncf/k8s-conformance/blob/master/instructions.md
: run `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`, and get the results using `kubectl cp`
