# Install Portworx based on https://docs.portworx.com/scheduler/kubernetes/

$ go get -u -v github.com/heptio/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
