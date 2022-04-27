# Docker Desktop for Mac

Docker Desktop for Mac is an easy-to-install desktop app for building, debugging, and testing Dockerized apps on a Mac.

## Setup

- Download and install Docker Desktop for Mac version 2.1.4.0 Edge Channel: https://download.docker.com/mac/edge/Docker.dmg
- In Docker Desktop for Mac preferences, enable Kubernetes to create a cluster on your local machine

## Reproduce Conformance Tests

Download the last binary release of Sonobuoy

```
$ go get -u -v github.com/heptio/sonobuoy
```

Run Sonobuoy on the cluster
```
$ sonobuoy run --e2e-skip "should rollback without unnecessary restarts"
```

Validate the tests result
```
$ sonobuoy e2e $(sonobuoy retrieve .)
```

Clean up Kubernetes objects created by Sonobuoy
```
$ sonobuoy delete
```