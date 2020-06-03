# SUSE Container as a Service Platform 4.1

## Introduction

These are instructions about how to run Kubernetes conformance tests on a `SUSE CaaS Platform 4.1 cluster.

## Download SUSE Container as a Service Platform 4.1

SUSE CaaS Platform installs as a module/extension of SUSE Linux Enterprise Server using the unified installer.

We are offering the following images on x86_64:
 * DVD ISOs
 * VMWare

SUSE Container as a Service Platform 4.1 can be downloaded from https://www.suse.com/products/caas-platform/download/

## Install SUSE Container as a Service Platform 4.1

Please find the Deployment guide here: https://documentation.suse.com/suse-caasp/4.1/single-html/caasp-deployment/

After installation, when you have a working Kubernetes cluster, install and setup kubectl (https://susedoc.github.io/doc-caasp/beta1/v4/caasp-admin/single-html/#sec.admin.kubernetes.install-kubectl)

Then, download sonobuoy from upstream:
  $ wget
https://github.com/heptio/sonobuoy/releases/download/v0.13.0/sonobuoy_0.13.0_linux_amd64.tar.gz
  $ tar xzf sonobuoy_0.13.0_linux_amd64.tar.gz

After that, prepare config for e2e only and trigger the e2e test suite

  $ cat << EOF > sonobuoy.json
   {
     "plugins": [ { "name": "e2e" } ]
   }
  EOF
 $ ./sonobuoy --config sonobuoy.json run

You can check status of the test:
  $ ./sonobuoy status

Once sonobuoy status shows the run as completed, you can retrieve logs archive by:
  $ ./sonobuoy retrieve ~/logs/

Then, you can extract the archive in ~/logs/ and check if the test passed by checking last few lines in
<archive>/plugins/e2e/results/e2e.logs:
  $ tail -n 10 e2e.log

Finally, you can do a cleanup on cluster by calling:
  $ ./sonobuoy delete

