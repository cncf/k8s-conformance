# Docker Desktop for Mac

Docker Desktop for Mac is an easy-to-install desktop app for building, debugging, and testing Dockerized apps on a Mac.

## Setup

- Download and install Docker Desktop for Mac version 3.1.0: https://desktop.docker.com/mac/stable/51484/Docker.dmg
- In Docker Desktop for Mac preferences, enable Kubernetes to create a cluster on your local machine

## Reproduce Conformance Tests

Download the binary release of Sonobuoy:
```
$ tar -xzf sonobuoy_0.19.0_darwin_amd64.tar.gz
```

Run Sonobuoy on the cluster skipping tests that require more than one node:
```
$ ./sonobuoy run --mode=certified-conformance --e2e-skip "should rollback without unnecessary restarts" --e2e-skip "validates basic preemption works" --e2e-skip "validates lower priority pod preemption by critical pod"
```

Validate the tests result:
```
$ ./sonobuoy e2e $(sonobuoy retrieve .)
```

Clean up Kubernetes objects created by Sonobuoy:
```
$ ./sonobuoy delete
```
