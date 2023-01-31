# Conformance tests for Compliant Kubernetes

## Install Compliant Kubernetes Kubespray v2.20.0-ck8s3 (based on Kubernetes v1.24.6)

## On API Stability

⚠️  Please note that the Elastisys Compliant Kubernetes Kubespray project frequently changes admin-facing API, i.e., configuration, in a backwards-incompatible way. Make sure to read the [change log](CHANGELOG.md) and the [migration steps](/migration). These migration steps are subject to quality assurance and are used in production environments. Hence, if properly executed, they shouldn't cause any downtime.

The user-facing API changes more rarely, usually as a result of a Kubernetes version upgrade. For details, read the [user-facing release notes](https://elastisys.io/compliantkubernetes/release-notes/#compliant-kubernetes-kubespray).

## Content

- `bin`: wrapper scripts that helps you run kubespray
- `config`: default config values
- `conformance-tests`: ck8s conformance tests for bare metal machines
- `kubespray`: git submodule of the kubespray repository

## Quick start

1. Init the kubespray config in your config path

    ```bash
    export CK8S_CONFIG_PATH=~/.ck8s/my-environment
    ./bin/ck8s-kubespray init <prefix> <flavor> [<SOPS fingerprint>]
    ```

    Arguments:
    * `prefix` will be used to differentiate this cluster from others in the same CK8S_CONFIG_PATH.
      For now you need to set this to `wc` or `sc` if you want to install compliantkubernetes apps on top afterwards, this restriction will be removed later.
    * `flavor` will determine some default values for a variety of config options.
      Supported options are `default`, `gcp`, `aws`, `vsphere`, and `openstack`.
    * `SOPS fingerprint` is the gpg fingerprint that will be used for SOPS encryption.
      You need to set this or the environment variable `CK8S_PGP_FP` the first time SOPS is used in your specified config path.

1. Edit the `inventory.ini` (found in your config path) to match the VMs (IP addresses and other settings that might be needed for your setup) that should be part of the cluster.
   Or if you have one created by a terraform script in `kubespray/contrib/terraform` you should use that one.

1. Init and update the [kubespray](https://github.com/kubernetes-sigs/kubespray) gitsubmodule:

    ```bash
    git submodule init
    git submodule update
    ```

1. Run kubespray to set up the kubernetes cluster:

   ```bash
   ./bin/ck8s-kubespray apply <prefix> [<options>]
   ```

   Any `options` added will be forwarded to ansible.

1. Done.
   You should now have a working kubernetes cluster.
   You should also have an encrypted kubeconfig at `<CK8S_CONFIG_PATH>/.state/kube_config_<prefix>.yaml` that you can use to access the cluster.

## Changing authorized SSH keys for a cluster

Authorized SSH keys can be changed for a cluster using:

```bash
./bin/ck8s-kubespray apply-ssh <prefix> [<options>]
```

It will set the public SSH key(s) found in`<CK8S_CONFIG_PATH>/<prefix>-config/group_vars/all/ck8s-ssh-keys.yaml` as authorized keys in your cluster (just add the keys you want to be authorized as elements in `ck8s_ssh_pub_keys_list`).
Note that the authorized SSH keys for the cluster will be set to these keys _exclusively_, removing any keys that may already be authorized, so make sure the list includes **every SSH key** that should be authorized.

When running this command, the SSH keys are applied to each node in the cluster sequentially, in reverse inventory order (first the workers and then the masters).
A connection test is performed after each node which has to succeed in order for the playbook to continue.
If the connection test fails, you may have lost your SSH access to the node; to recover from this, you can set up an SSH connection before running the command and keep it active so that you can change the authorized keys manually.

## Rebooting nodes

You can reboot all nodes that wants to restart (usually to finish installing new packages) by running:

```bash
./bin/ck8s-kubespray reboot-nodes <prefix> [--extra-vars manual_prompt=true] [<options>]
```

If you set `--extra-vars manual_prompt=true` then you get a manual prompt before each reboot so you can stop the playbook if you want.

Note that this playbook requires you to use ansible version >= 2.10.

## Removing nodes

You can remove a node from a ck8s cluster by running:

```bash
./bin/ck8s-kubespray remove-node <prefix> <node-name>[,<node-name-2>,...] [<options>]
```

### Known issues

- The script may fail with the message `error while evaluating conditional (kubelet_heartbeat.rc == 0): 'dict object' has no attribute 'rc'`
  - In such situations just rerun the script. It will skip the check for that node, so check that it is up and running manually afterwards.

## Running other kubespray playbooks

With the following command you can run any ansible playbook available in kubespray:

```bash
./bin/ck8s-kubespray run-playbook <prefix> <playbook> [<options>]
```

Where `playbook` is the filename of the playbook that you want to run, e.g. `cluster.yml` if you want to create a cluster (making the command functionally the same as our `ck8s-kubespray apply` command) or `scale.yml` if you want to just add more nodes. Remember to check the kubespray documentation before running a playbook.
This will use the inventory, group-vars, and ssh key in your config path and therefore requires that you first run the init command. Any `options` added will be forwarded to ansible.

## Kubeconfig

We recommend that you use OIDC kubeconfigs instead of regular cluster-admin kubeconfigs. The default settings will create OIDC kubeconfigs for you when you run `./bin/ck8s-kubespray apply <prefix>`, but there are some variables you need to set. See the variables in: `<prefix>-config/group_vars/k8s_cluster/ck8s-k8s-cluster.yaml` in your config path.

But if you need to use a regular cluster-admin kubeconfig in a break-glass situation, then you can ssh to one of the controleplane nodes and use the kubeconfig at `/etc/kubernetes/admin.conf`. We recommend that you do not copy that kubeconfig to your local host, when dealing with production clusters.

For development you can skip OIDC and instead get a regular cluster admin kubeconfig locally by setting `kubeconfig_localhost: true`. Note that you then must set `create_oidc_kubeconfig: false`.

The kubeconfig and OIDC cluster admin RBAC are managed with the playbooks `playbooks/kubeconfig.yml` and `playbooks/cluster_admin_rbac.yml`. You can run them manually with:

```bash
./bin/ck8s-kubespray run-playbook <prefix> ../playbooks/kubeconfig.yml -b
./bin/ck8s-kubespray run-playbook <prefix> ../playbooks/cluster_admin_rbac.yml -b
```

## Run Conformance Test

Download sonobuoy - check the [official documentation](https://sonobuoy.io/docs/master/) for instructions.

Deploy a Sonobuoy pod to your cluster with:

    $ sonobuoy run --mode=certified-conformance --wait

Once sonobuoy has completed, which can take more than 60 minutes, copy the output directory from the main Sonobuoy pod to a local directory:

    $ outfile=$(sonobuoy retrieve)

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

    $ mkdir ./results; tar xzf $outfile -C ./results

NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/global/{e2e.log,junit_01.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

    $ sonobuoy delete

