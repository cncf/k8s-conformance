# Koris Conformance tests

Assuming you have already an Openstack tenant, download your OpenStackRCv3 
file.

source this file:

```sh
source your-openstack-rc.sh
```

Download the koris binray from the release page:

```
wget https://github.com/noris-network/koris/releases/download/v1.3.1/koris-1.3.1-linux-amd64
```

Download a sample configuration file from the documentation directory:

```
wget https://gitlab.com/noris-network/koris/raw/master/docs/examples/example-config.yml
```

Edit the configuration and run koris to create your cluster:

```
koris apply example-config.yml
```

You can run sonobuoy as described in the conformance suite
[instructions][1] to run the conformance test.


[1]: https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running.
