# Docker for Windows

## Reproduce conformance results

1. Install Docker for Win from edge channel. https://docs.docker.com/docker-for-windows/install/
2. Get the latest version of sonobuoy. `go get -u github.com/heptio/sonobuoy`
3. Launch tests. `sonobuoy run --kube-conformance-image gcr.io/heptio-images/kube-conformance:v1.9.2`
4. Get results. `sonobuoy retrieve .`
