# Symplegma

## How to reproduce the results

Follow this [guide](https://clusterfrak-dynamics.github.io/symplegma/user-guides/aws/)

## Running e2e tests

```
go get -u -v github.com/heptio/sonobuoy
sonobuoy run
sonobuoy status
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```
