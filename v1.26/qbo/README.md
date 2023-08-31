# CNCF conformance for `Qbo` Cloud

## Run conformance tests from `Qbo` web console
### Requirements
---
> * Chrome or Firefox browser
> * Email authenticated by Google (Google Account)

### Request access to `Qbo` Cloud
---
> Email `support@qbo.io` and provide a google email in your request that you'll use to authenticate in Qbo Cloud.

### Login to the `Qbo` console
---
> Once you receive an email confirmation you can login to:

https://console.cloud.qbo.io:9601

### Run conformance test
---
> Conformance tests are run with `conformance`. It uses a typing bot that will type the commands for you. Alternatively you can type the command yourself in the shell


`conformance` will perform the following tasks:
* Create a `qbo` cluster
* Configure `kubectl`
* Download and configure `sonobuoy` 
* Run confomance test on the version entered.

Usage:

```bash
./conformance help
>>> ./conformance help                 -- Show usage
>>> ./conformance list                 -- List available Kubernetes image tags
>>> ./conformance run {tag}    -- Run CNCF conformance results for qbo
```

List available Kubernetes tags:

```bash
./conformance list
```
Select version and run conformance test. Example: 
```bash
./conformance run v1.28.0
```
### Get test results
---
```bash
cat /tmp/qbo/sonobuoy/v1.28.0/qbo/e2e.log | grep Pass
```
> For more information visit: https://docs.qbo.io/
