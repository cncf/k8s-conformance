# Shturval Kubernetes Platform

## Install Shturval Platform Management cluster 

1. Get installation key from https://support.chislitellab.ru.
2. Download binary from https://public.shturval.tech/stc-2.6.1, rename to `stc` and make executable. 
3. Prepare infrastructure as described in https://docs.shturval.tech/2.6/setup/preinstall/preparation/.
4. If required, prepare local repo mirror for air-gapped installation as described in https://docs.shturval.tech/2.6/setup/preinstall/mirror-install/
5. Follow installation process as descibed in https://docs.shturval.tech/2.6/setup/install/installing-platform/. In generic case it is enought to execute following command and answer number of questions.
   
```sh
./stc install management --interactive --license <KEY FROM STEP 1>
```
When the cluster installation completes, credentials and endpoints of your platform instance will appear in your terminal.

6. Update or set KUBECONFIG env variable to the file, produced by stc. Previous command output will contain exact path.

```sh
export KUBECONFIG=$(pwd)/.<clustername>/clusteradmin.conf
```

## Run conformance tests

1. Run the conformance tests. 

```sh
sonobuoy run --mode=certified-conformance
```

2. Check the conformance tests status:
```sh
sonobuoy status
```

3. When the status is completed, fetch the results:
```sh
sonobuoy retrieve
```

4. After test completion, clean up cluster:

```sh
sonobuoy delete
```
