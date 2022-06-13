# Conformance results for v1.20/aistack-k8s

## How to Reproduce

## Login

Login in to AI-Stack Web UI with the admin account

Create/Retrieve the credentials of the admin console

Connect to the admin console vai ssh with the credentials

### Run Conformance Test

Download and extract a binary release of sonobuoy into the work directory

```
curl -OL https://github.com/vmware-tanzu/sonobuoy/releases/download/$VERSION/sonobuoy_$VERSION_linux_amd64.tar.gz
tar xf sonobuoy*.tar.gz
```

Run the test and wait for the result (60 mins)

```
sonobuoy run --mode=certified-conformance --wait
```

Get the result and extract files into result directory

```
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results
```
