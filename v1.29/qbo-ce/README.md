# Qbo CNCF Conformance (Cloud and Community Edition)

his portion provides guidance on conducting CNCF [conformance](https://www.cncf.io/certification/software-conformance/) tests for the qbo application. The testing process utilizes a diagnostic tool named [sonobuoy](https://github.com/vmware-tanzu/sonobuoy).

## Requirements
---
* Chrome or Firefox Web Browser

## Console Access
### Qbo Cloud
> To obtain access to qbo cloud, please follow these steps:
> 
> Request access by emailing support@qbo.io. In your request, include a Google email address that you intend to use for authentication in qbo cloud.
>
> Upon receiving email confirmation, proceed to log in to the qbo console at:
> 
> https://console.cloud.qbo.io

### Qbo CE
> To access the qbo web console, follow these steps:
>
> Execute the following commands in your terminal
```bash
QBO_API=$(docker inspect qbo | jq -r .[].NetworkSettings.Networks.bridge.IPAddress)
echo http://$QBO_API:9601
```

> Open your web browser and navigate to the address displayed in the output of the commands.

## Conformance Tests
---
> The execution of conformance tests involves running the `conformance` script, assisted by a typing bot named `qbot` that automates command input. Alternatively, you have the option to manually enter the commands in the shell.

The `conformance` script is designed to execute the following actions:

* Creation of a `qbo` cluster
* Configuration of `kubectl`
* Retrieval and setup of `sonobuoy`
* Execution of conformance tests on the specified version.

Usage:

```bash
./conformance help
>>> ./conformance help                 -- Show usage
>>> ./conformance list                 -- List available Kubernetes image tags
>>> ./conformance run {tag}            -- Run CNCF conformance results for qbo
```

List available Kubernetes tags:

```bash
./conformance list
```
Select version and run conformance test. Example: 
```bash
./conformance run v1.28.0
```
## Conformance Results
---
```bash
cat $HOME/sonobuoy/v1.28.0/qbo/e2e.log | grep Pass
```

# For more information visit: 
> 
> [QBO CLOUD DOCS](https://ce.qbo.io/)
>
> [QBO CE DOCS](https://ce.qbo.io/)
>
> [CERTIFIED KUBERNETES SOFTWARE CONFORMANCE](https://www.cncf.io/certification/software-conformance/)

