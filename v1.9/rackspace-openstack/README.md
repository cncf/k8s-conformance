# Rackspace Kubernetes-as-a-Service

Rackspace Kubernetes-as-a-Service is a fully managed service deployed by
Rackspace operations and certified Kubernetes Administrators.

Once your organization has a demo account (by contacting sales) or a deployed
environment in your own data center or a Rackspace data center, follow the
[documentation](https://developer.rackspace.com/docs/rkaas/1.0.x/rkaas-userguide-external/mk8s-overview/#authentication-and-authorization)
to configure your locally installed `kubectl` CLI tool and point it to the
Rackspace KaaS system.

## Running the k8s conformance tests

Set your kubectl to point your CLI to the deployed kubernetes cluster. Per the
instructions above. You can then run the k8s conformance test by running the
following command:

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Please note that the compliance tests need external connectivity and routing to
complete. In highly restricted environments this may require additional ports
or network routes to be open within the environment for all tests to pass.
