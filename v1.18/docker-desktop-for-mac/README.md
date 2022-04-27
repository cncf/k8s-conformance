# Docker Desktop for Mac

Docker Desktop for Mac is an easy-to-install desktop app for building, debugging, and testing Dockerized apps on a Mac.

## Setup

- Download and install Docker Desktop for Mac version 2.4.0.0 from the Stable Channel: https://desktop.docker.com/mac/stable/48506/Docker.dmg
- In Docker Desktop for Mac preferences, enable Kubernetes to create a cluster on your local machine

## Reproduce Conformance Tests

Download the binary release of Sonobuoy

```
$ tar -xzf sonobuoy_0.18.5_darwin_amd64.tar.gz
```

Run Sonobuoy on the cluster, skipping a test which requires two clusters
```
$ ./sonobuoy run --mode=certified-conformance --e2e-skip "should rollback without unnecessary restarts"
```

Retrieve the test results
```
$ ./sonobuoy retrieve .
```

Clean up Kubernetes objects created by Sonobuoy
```
$ ./sonobuoy delete
```
