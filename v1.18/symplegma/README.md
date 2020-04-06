# Symplegma

## How to reproduce the results

Follow this [guide](https://clusterfrak-dynamics.github.io/symplegma/user-guides/aws/)

## Running e2e tests

```
wget https://github.com/heptio/sonobuoy/releases/download/v0.18.0/sonobuoy_0.18.0_linux_amd64.tar.gz
tar -zxvf sonobuoy_0.18.0_linux_amd64.tar.gz
./sonobuoy run --mode certified-conformance
./sonobuoy status
./sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```
