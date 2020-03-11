# Reproducing the test results with StarlingX


## Create the StarlingX environment with Kubernetes

You can access the StarlingX ISO image from the following mirror: http://mirror.starlingx.cengn.ca/mirror/starlingx/release/3.0.0/

Setup a StarlingX environment based on the instructions you can find here: https://docs.starlingx.io/deploy_install_guides/r3_release/index.html

The tests were run on a duplex environment.

Make sure you have the right proxy setting to reach the docker registries in your localhost.yaml file.

## Testing      

Once the configuration has been created, then you can follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance test.
