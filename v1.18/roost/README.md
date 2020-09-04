# Kubernetes Conformance test on RDE (Roost Desktop)

## About Roost Desktop

Roost Desktop is a desktop application that provides you a production-grade Kubernetes Engine (Zettabytes Kubernetes Engine ZKE or simply Roost Engine) on your local machine so that you can develop and test your code easily. For more information, visit [link](https://roost.io/page;type=page;page=feed;id=5f4a36bf3dba233caab85976).

## How to use RDE

Roost Desktop is available to download from official website. [Download Roost](https://roost.io/download). Install and launch Roost Desktop. As soon as Roost is launched, [ZKE Cluster](https://docs.roost.io/products/roost-engine) initializes with the Roost recommended cluser size. (default cluster size is decided based on avaliable RAM and CPU on the machine where Roost is installed). ZKE cluster status can be seen from right bottom corner of the Roost Desktop. ZKE status can be `ZKE Starting...`, `ZKE Running` or `ZKE Stopped`. User can start or stop ZKE cluster from Roost Desktop system tray icon or ZKE start/stop icon from within the Roost Desktop.

Once ZKE cluster status is `ZKE Running`, open `New Terminal` from Roost bottom left corner (`+` icon). Follow below mentioned steps to download Sonobuoy and run conformance test suite.

> ZKE cluster configurations can be changed from `Roost -> Preferences`.

> ZKE cluster log can be seen by clicking on `ZKE status` from right bottom corner of Roost Desktop or by viewing `Run Diagnostics` Report.

> In case of any issues, user can submit diagnostic reports from help -> Run Diagnostics (Roost Desktop menu option) or can report an issue from ( help -> Report an Issue)

## Run conformance test

1. Download and install Sonobuoy

    1. Download the latest release of [download](https://github.com/vmware-tanzu/sonobuoy/releases) .

    2. Extract the tarball:

        ```bash
            tar -xvf <RELEASE_TARBALL_NAME>.tar.gz
        ```

    Move the extracted sonobuoy executable to somewhere on your PATH.

2. Run test

    ```bash
        sonobuoy run --mode=certified-conformance --plugin-env e2e.E2E_EXTRA_ARGS="--dns-domain=zke" --kubeconfig $KUBECONFIG
    ```

3. View status

    ```bash
        sonobuoy status
    ```

4. Inspect sonobuoy log

    ```bash
        sonobuoy logs
    ```

5. Once `sonobuoy status` is completed. Retrieve the conformance test results from sonobuoy. Results can be extracted from tar.gz at `results/plugins/e2e/results/global/{e2e.log,junit_01.xml}`

    ```bash
        outfile=$(sonobuoy retrieve)
        mkdir ./results; tar xzf $outfile -C ./results
    ```

## Verify

1. Sonobuoy version

    ```bash
        $   sonobuoy version --kubeconfig $KUBECONFIG
        Sonobuoy Version: v0.18.4
        MinimumKubeVersion: 1.16.0
        MaximumKubeVersion: 1.18.99
        GitSHA: b5e4803d21f37788727f4f59099111704cd3806c
        API Version:  v1.18.3
    ```

2. Ensure all E2E Conformance test are passed by cross verifying passed e2e out of total e2e, from the extracted result file `results/plugins/e2e/results/global/e2e.log`
