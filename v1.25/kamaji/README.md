# CNCF Conformance suite on Kamaji Tenant Cluster

Run this conformance test suite on MS Azure. Tests are run according to the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)

## To reproduce

Jump in a container from the `kamaji-cncf-conformance` image:

```bash
docker run -it clastix/kamaji-cncf-conformance
```

Working in the container:

```bash
# Login into your MS Azure account
az login
az account set --subscription "MySubscription"

# Set Azure Region
export KAMAJI_REGION=westeurope

# Clone this repository
git clone https://github.com/clastix/kamaji-cncf-conformance
cd kamaji-cncf-conformance

# Set Kubernetes version of Tenant Cluster
export TENANT_VERSION=v1.25.0

# Run the test
make
```

Conformance results are left under the `/tmp` folder of the container.

