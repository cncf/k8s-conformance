# Reproducing the test results

## Prerequisites
- Organization within the mogenius platform

## Setup
- Navigate to the Cluster Overview for your organization
- Click the "+" Icon to add a new Cluster
- Follow the installation instruction 


## Executing the tests
Install sonobuoy and start the test run:
```sh
go install github.com/vmware-tanzu/sonobuoy@latest
sonobuoy run --mode=certified-conformance
```

View the test status with:
```sh
sonobuoy status
```

Once the test is completed, extract the results:
```sh
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Afterwards, delete the sonobuoy from your cluster:
```sh
sonobuoy delete
```
