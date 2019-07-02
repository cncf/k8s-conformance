# Talos

## How to reproduce the results

Follow this [guide](https://github.com/talos-systems/cluster-api-provider-talos/blob/master/docs/Packet.md) to create a Talos cluster in Packet

## Running e2e tests

```
go get -u -v github.com/heptio/sonobuoy
sonobuoy run --wait --plugin e2e
results=$(sonobuoy retrieve)
sonobuoy e2e $results
mkdir ./results; tar xzf ${results} -C ./results
```
