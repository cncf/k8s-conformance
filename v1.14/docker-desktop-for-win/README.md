# Docker Desktop for Windows

Docker Desktop - Windows is Docker designed to run on Windows 10. It is a native Windows application that provides an easy-to-use development environment for building, shipping, and running dockerized apps.

## Setup

- Download and install Docker Desktop for Windows version 2.0.4.0 (33772) Edge Channel: https://download.docker.com/win/edge/33772/Docker%20Desktop%20Installer.exe
- In Docker Desktop for Windows preferences, enable Kubernetes to create a cluster on your local machine.

## Reproduce Conformance Tests

Download the last binary release of Sonobuoy

```
$ wget https://github.com/heptio/sonobuoy/releases/download/v0.14.2/sonobuoy_0.14.2_windows_amd64.tar.gz
```

Run Sonobuoy on the cluster
```
$ sonobuoy run
```

Get the results on local
```
$ sonobuoy retrieve .
```

Clean up Kubernetes objects created by Sonobuoy
```
$ sonobuoy delete
```