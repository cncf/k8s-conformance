# Conformance tests for Elastisys Welkin@ Cluster API v0.4.0 (based on Kubernetes v1.30.6)

## Install

First request a copy and enter the `elastisys/ck8s-cluster-api` repository.

### Requirements

- clusterctl, kind, kubectl
- helmfile, helm, helm-diff, helm-secrets
- yq (installed as `yq4`)
- AWS only: clusterawsadm
- Azure only: Azure CLI
- OpenStack only: OpenStack CLI

Supported infrastructure provider with a suitable VM image.

### Quick start

Note: Kind will be used to provision a bootstrap cluster and will manipulate the cluster named `bootstrap`.

1. Create configuration and then modify according to your needs:

    ```sh
    export CK8S_CONFIG_PATH="~/ck8s/my-environment"
    export CK8S_PGP_FP=<pgp-fingerprint>
    ```

    - `gpg-fingerprint` is the GPG fingerprint used by SOPS for secrets encryption within the `CK8S_CONFIG_PATH`.
        You need to set this or the envrionment variable `CK8S_PGP_FP` the first time SOPS is used.

    ```sh
    ./bin/ck8s-capi init <cloud> <region> <flavor>
    ```

    Arguments:
    - `cloud` will determine some default values for a variety of config options for a particular cloud see available ones in `config/cloud/`.
    - `region` will determine some default values for a variety of config options for a particular cloud region see available ones in `config/cloud-region/<cloud>/`.
    - `flavor` will determine some default values for a variety of config options see available ones in `config/flavor/`.

1. Edit the `${CK8S_CONFIG_PATH}/capi/values.yaml`
    - Update the `set-me` fields
    - Add the clusters to the `clusters` field (Note that `bc` is a reserved name for the local bootstrap cluster)
    - Set the name of the cluster that should be management clusters to the `managementCluster` field

1. Edit the `${CK8S_CONFIG_PATH}/capi/secrets.yaml`
    - Update the `set-me` fields

1. Create bootstrap cluster:

    ```sh
    ./bin/ck8s-capi create bc
    ```

1. Bootstrap the management cluster:

    ```sh
    ./bin/ck8s-capi bootstrap $(yq4 '.managementCluster' "${CK8S_CONFIG_PATH}/capi/values.yaml")
    ```

1. Bootstrap the other clusters:

    ```sh
    ./bin/ck8s-capi bootstrap <cluster-name>
    ```

Done.
You should now have working Kubernetes clusters.
You should also have an encrypted `kubeconfig`s at `${CK8S_CONFIG_PATH}/.state/kube_config_<cluster-name>.yaml` that you can use to access the clusters.

## Test

1. Download Sonobuoy - check the [official documentation](https://sonobuoy.io/docs/main/) for instructions.

1. Set the `kubeconfig` to use:

    ```sh
    export KUBECONFIG="${CK8S_CONFIG_PATH}/.state/kube_config_<cluster-name>.yaml"
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
