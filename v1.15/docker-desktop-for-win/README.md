# Docker Desktop for Windows

Docker Desktop - Windows is Docker designed to run on Windows 10. It is a native Windows application that provides an easy-to-use development environment for building, shipping, and running dockerized apps.

## Setup

- Download and install Docker Desktop for Windows version 2.1.4.0 Edge Channel: https://download.docker.com/win/edge/Docker%20Desktop%20Installer.exe
- In Docker Desktop for Windows preferences, enable Kubernetes to create a cluster on your local machine.

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