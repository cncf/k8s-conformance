Supergiant Kubernetes Conformance
=

<img src="http://supergiant.io/img/logo_dark.svg" width="400">

# Setup

The quickest means of getting a working instance of Supergiant is to sign up for the [hosted beta](https://beta.supergiant.io/). 

Once Supergiant is running, [link a cloud account](https://supergiant.readthedocs.io/en/v1.0.0/Using%20the%20UI/cloud_accounts/) and [create a kube](https://supergiant.readthedocs.io/en/v1.0.0/Using%20the%20UI/deploying_kubes/) of version 1.11 on any cloud!

Note: _If any problems occur running Supergiant or creating a kube, please feel welcome to [submit an issue](https://github.com/supergiant/supergiant/issues) on GitHub._

# Testing

At Supergiant, we used the browser-based [Heptio Sonobuoy Scanner](https://scanner.heptio.com/) (the "No RBAC" or `?rbac=no` option). It's a stress-free shell for the official Kubernetes conformance tests to run in. Alternatively, there are more hands-on methods, such as [running the conformance tests raw](https://github.com/kubernetes/community/blob/master/contributors/devel/conformance-tests.md).

After the tests are completed, the results can be downloaded and perused.