NeuVector’s solution is a lightweight container which deploys easily using Kubernetes to protect running containers and hosts.
NeuVector uses behavioral learning technology at the network and container level to automatically protect running Kubernetes pods and  containers.
Protections include a Layer-7 firewall for network inspection to detect violation and threats, host and container suspicious process detection, and vulnerability scans.

1. curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
2. kubectl logs f -n sonobuoy sonobuoy
3. wait for "no-exit was specified, sonobuoy is now blocking"
4. kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
5. untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}