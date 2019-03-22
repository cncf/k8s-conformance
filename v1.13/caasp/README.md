# SUSE Container as a Service Platform 4.0 Beta

## Introduction

This is instructions about how to run Kubernetes conformance tests on cluster SUSE CaaS Platform 4.0.

## Download SUSE Container as a Service Platform 4.0 Beta

We are offering the following images on x86_64:
 * DVD ISOs
 * SUSE OpenStack Cloud image
 * VMWare

SUSE Container as a Service Platform 4 can be downloaded from http://beta.suse.com/private/SUSE-CaaSP-Beta/

## Install SUSE Container as a Service Platform 4.0

Please find the Deployment guide here: https://susedoc.github.io/doc-caasp/beta1/v4/caasp-deployment/single-html/ 
You must skip registration against SCC/SMT/RMT because there are no update channels or valid registration keys for this version.

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

