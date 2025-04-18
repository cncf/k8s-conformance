# Conformance tests for Elastisys Welkin® Kubespray v2.27.0-ck8s1 (based on Kubernetes v1.31.4)

## Install

First clone and enter the [elastisys/compliantkubernetes-kubespray](https://github.com/elastisys/compliantkubernetes-kubespray) repository:

```sh
git clone https://github.com/elastisys/compliantkubernetes-kubespray.git
cd compliantkubernetes-kubespray
```

### Requirements

[Terraform](https://github.com/hashicorp/terraform/releases) (tested with 1.2.9)

Install requirements using the Ansible playbook `get-requirements.yaml`:

```sh
ansible-playbook -e 'ansible_python_interpreter=/usr/bin/python3' --ask-become-pass --connection local --inventory 127.0.0.1, get-requirements.yaml
```

### Quick start

1. Init the Kubespray config in your `CK8S_CONFIG_PATH`:

    ```sh
    export CK8S_CONFIG_PATH="~/ck8s/my-environment"
    ./bin/ck8s-kubespray init <wc|sc> <flavor> [<SOPS fingerprint>]
    ```

    Arguments:
    - The init command accepts `wc` (_workload cluster_) or `sc` (_service cluster_) as first argument as to create separate folders for each cluster's configuration files.
    - `flavor` will determine some default values for a variety of config options.
      Supported options are `default`, `gcp`, `aws`, `vsphere`, `openstack` and `upcloud`.
    - `SOPS fingerprint` is the gpg fingerprint that will be used for SOPS encryption.
      You need to set this or the environment variable `CK8S_PGP_FP` the first time SOPS is used in your specified config path.

1. Edit the `inventory.ini` (found within the `CK8S_CONFIG_PATH`) to match the VMs (IP addresses and other settings that might be needed for your setup) that should be part of the cluster.
    Or if you have one created by a Terraform script in `kubespray/contrib/terraform` you should use that one.

1. Init and update the [Kubespray](https://github.com/kubernetes-sigs/kubespray) Git submodule:

    ```sh
    git submodule sync
    git submodule update --init --recursive
    ```

1. Run Kubespray to set up the Kubernetes cluster:

    ```sh
    ./bin/ck8s-kubespray apply <prefix> [options]
    ```

    Any `options` added will be forwarded to Ansible.

1. Done.
    You should now have a working kubernetes cluster.
    You should also have an encrypted kubeconfig at `<CK8S_CONFIG_PATH>/.state/kube_config_<wc|sc>.yaml` that you can use to access the cluster.

For more information check [the repository](https://github.com/elastisys/compliantkubernetes-kubespray).

## Test

1. Download Sonobuoy - check the [official documentation](https://sonobuoy.io/docs/main/) for instructions.

1. Set the `kubeconfig` to use:

    ```sh
    export KUBECONFIG="${CK8S_CONFIG_PATH}/.state/kube_config_<prefix>.yaml"
    ```

1. Run the certified conformance test:

    ```sh
    sonobuoy run --mode=certified-conformance --wait
    ```

    This might take two hours to complete.

1. Collect the results:

    ```sh
    RESULTS="$(sonobuoy retrieve)"

    mkdir results
    tar xzf "${RESULTS}" -C results
    ```

    Note that the two files required for the submission are located under `${RESULTS}/plugins/e2e/results/global/{e2e.log,junit_01.xml}`.

1. Clean up:

    ```sh
    sonobuoy delete
    ```
