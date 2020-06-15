# Docker Desktop for Windows

Docker Desktop - Windows is Docker designed to run on Windows 10. It is a native Windows application that provides an easy-to-use development environment for building, shipping, and running dockerized apps.

## Setup

- Download and install Docker Desktop for Windows version 2.3.1.0 Edge Channel: https://desktop.docker.com/win/edge/45408/Docker%20Desktop%20Installer.exe
- In Docker Desktop for Windows preferences, enable Kubernetes to create a cluster on your local machine.

## Reproduce Conformance Tests

Download the last binary release of Sonobuoy

```
$ tar -xzf sonobuoy_0.16.5_windows_amd64.tar.gz
```

Run Sonobuoy on the cluster
```
$ ./sonobuoy run --mode=certified-conformance --e2e-skip "should rollback without unnecessary restarts"
```

Validate the tests result
```
$ ./sonobuoy.exe e2e $(sonobuoy retrieve .)
```

Clean up Kubernetes objects created by Sonobuoy
```
$ ./sonobuoy.exe delete
```