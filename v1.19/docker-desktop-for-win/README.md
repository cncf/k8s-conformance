# Docker Desktop for Windows

Docker Desktop for Windows is a native Windows 10 application that provides an easy-to-use development environment for building, shipping, and running dockerized apps.

## Setup

- Download and install Docker Desktop for Windows version 3.1.0: https://desktop.docker.com/win/stable/51484/Docker%20Desktop%20Installer.exe
- In Docker Desktop for Windows preferences, enable Kubernetes to create a cluster on your local machine.

## Reproduce Conformance Tests

Download the binary release of Sonobuoy:

```
$ tar -xzf sonobuoy_0.19.0_windows_amd64.tar.gz
```

Run Sonobuoy on the cluster:
```
$ ./sonobuoy run --mode=certified-conformance --e2e-skip "should rollback without unnecessary restarts" --e2e-skip "validates basic preemption works" --e2e-skip "validates lower priority pod preemption by critical pod"
```

Validate the tests result:
```
$ ./sonobuoy.exe e2e $(sonobuoy retrieve .)
```

Clean up Kubernetes objects created by Sonobuoy:
```
$ ./sonobuoy.exe delete
```