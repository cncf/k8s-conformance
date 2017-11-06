# Cloud Foundry Container Runtime (CFCR)

Cloud Foundry Container Runtime (CFCR) utilizes [BOSH](http://bosh.io/) to deploy your Kubernetes cluster.

The Kubernetes cluster can be deployed to your choice of IaaS. This README is written for GCP.

## Bootstrapping your IaaS and Deploying BOSH

Follow the documentation in this link to bootstrap your IaaS and set up a bastion vm: https://docs-kubo.cfapps.io/installing/gcp/

Follow the documentation in this link to deploy your BOSH director: https://docs-kubo.cfapps.io/installing/gcp/deploying-bosh-gcp

## Upload dependencies to the BOSH director

### Upload dependency releases

Ensure you are on the bastion vm when interacting with the BOSH director. The BOSH CLI requires network connectivity to the BOSH director vm.

Run the following the upload the dependency releases:

```
export BOSH_ENVIRONMENT=<your-environment-name>
mkdir -p /tmp/releases

# kubo-etcd release
pushd /tmp/releases
curl -O https://github.com/pivotal-cf-experimental/kubo-etcd/releases/download/v2/kubo-etcd.2.tgz
popd
bosh upload-release /tmp/releases/kubo-etcd.2.tgz

# kubo release
pushd /tmp/releases
curl -O https://github.com/cloudfoundry-incubator/kubo-release/releases/download/v0.8.0/kubo-release-0.8.0.tgz
popd
bosh upload-release /tmp/releases/kubo-release-0.8.0.tgz


# docker release
bosh upload-release https://bosh.io/d/github.com/cf-platform-eng/docker-boshrelease?v=28.0.1 --sha1 448eaa2f478dc8794933781b478fae02aa44ed6b

# haproxy release
bosh upload-release https://bosh.io/d/github.com/cloudfoundry-community/haproxy-boshrelease?v=8.4.0 --sha1 c14bd7683c04ea9802deb209b7ac648c8ea57712

```

On the bastion vm, navigate to the `/share/kubo-deployment` directory and modify the `manifests/kubo.yml` deployment manifest.

Update the releases section to the following:

```
  releases:
  - name: kubo-etcd
    version: 2
  - name: kubo
    version: latest
  - name: docker
    version: 28.0.1
  - name: haproxy
    version: 8.4.0
```

### Upload compatible stemcell

A stemcell is a VM image that BOSH uses to create vms.

Run the following to upload the stemcell:

```
bosh upload-stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3468.5
```

On the bastion vm, navigate to the `/share/kubo-deployment` directory and modify the `manifests/kubo.yml` deployment manifest.

Update the stemcells section to the following:

```
  stemcells:
  - alias: trusty
    os: ubuntu-trusty
    version: "3468.5"
```

## Deploying Kubernetes

Run the following script from the bastion vm to deploy the Kubernetes cluster:

```
/share/kubo-deployment/bin/deploy_k8s <path-to-your-env-configuration-dir> my-kubo skip
```

### Set kubectl

Run the follow script from the bastion vm to set your kubectl config:

```
/share/kubo-deployment/bin/set_kubeconfig <path-to-your-env-configuration-dir> my-kubo
```
