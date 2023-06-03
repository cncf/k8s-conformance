# Conformance tests for Ericsson Cloud Container Distribution

## Install Ericsson CCD 2.24.0 (base on Kubernetes v1.25.3)

Ericsson Cloud Container Distribution provides container management and
orchestration for the Ericsson Telco applications that have been adopted to
Cloud Native based Architecture and run in a container environment.

The following procedure were used to create an CCD cluster for the purposes of
running the Kubernetes conformance tests.

Edit env-eccd.yaml to correspond your network and openstack environment
settings.

Install the Cloud Container Distribution cluster by executing the stack create
command in OpenStack.

$ openstack stack create -t eccd.yaml -e env-eccd.yaml ccd-cncf-stack --wait

After a completed deployment, the Kubernetes cluster is ready to be used.

Should you need further instructions please refer to CPI documentation related
software package.

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following
command:

```sh
kubectl apply -f sonobuoy.yaml
```

Watch Sonobuoy's logs with:

```
kubectl logs -f -n heptio-sonobuoy e2e sonobuoy
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then
copy the results using `kubectl cp`