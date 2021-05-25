# Docker Desktop for Windows

Docker Desktop - Windows is Docker designed to run on Windows 10. It is a native Windows application that provides an easy-to-use development environment for building, shipping, and running dockerized apps.

## Setup

- Download and install Docker Desktop for Windows version 2.4.0.0 from the Stable Channel: https://desktop.docker.com/win/stable/48506/Docker%20Desktop%20Installer.exe
- In Docker Desktop for Windows preferences, enable Kubernetes to create a cluster on your local machine.

## Reproduce Conformance Tests

Download the binary release of Sonobuoy

```
PS C:\Users\...> wsl tar -xvzf sonobuoy_0.18.5_windows_amd64.tar.gz
```

Run Sonobuoy on the cluster
```
PS C:\Users\...\sonobuoy> .\sonobuoy run --mode=certified-conformance --e2e-skip "should rollback without unnecessary restarts"
```

Retrieve the test results
```
PS C:\Users\...\sonobuoy> .\sonobuoy retrieve
```