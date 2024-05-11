# Install CloudLink-CMP

## Download The Package

```shell
$ wget https://resource.bessystem.com/download/CloudLink%20CMP/Media/4.6.0/CLOUDLINK-CMP-4.6.0-X86_64.bin
```

## Unpack Package:

```shell
$ chmod +x CLOUDLINK-CMP-4.6.0-X86_64.bin
$ ./CLOUDLINK-CMP-4.6.0-X86_64.bin
```

## Config The Install Option

```shell
$ vi install/supports/global.config
$ vi install/supports/machines.yaml
```

## Start Install

```shell
$ ./install/bin/install.sh
```

## Wait Install Done

The script will automatically exit after the installation is complete.

# Create Cluster

## login

[+] Sign into CloudLink-CMP Console with you own account.

## Add Machines

[+] Initiating machine information. (系统->机器池->新建)

[+] Init Machine, Choose the correct version. (系统->机器池->初始化)

## Create kubernetes cluster

[+] Setting cluster name, select machines, and setting configs. (组织->业务集群)

choose kubernetes components install node（The host of api-server will be determined according to your choice）

## Create Access Token

[+] Create ClusterRole of admin. (集群->RBAC授权->角色管理->新建)

[+] Create serviceaccount. (集群->RBAC授权->服务账户->新建)

[+] Authorize serviceaccount.

[+] Get token, Config kubeconfig on machine by token.

# Run conformance tests
Start the conformance tests on your test host

```
$ sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v" --mode=certified-conformance --dns-pod-labels k8s-app=core-dns
```

Check the status:

```
$ sonobuoy status
```

Once the status commands shows the run as completed, you can download the results tar.gz file:

```
$ sonobuoy retrieve
```

Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run the scan and download the results.

