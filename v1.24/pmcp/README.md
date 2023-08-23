# Proact Managed Container Platform

## Steps-to-reproduce

1. setup the cluster with standard tools (this is a managed service, not a
   publically available cluster that can be downloaded)
2. run and submit the conformance test according to https://github.com/cncf/k8s-conformance/blob/master/instructions.md
as outlined in the below script.


```
$ k8s_version=vX.Y
$ prod_name=example

$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance --wait
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results

$ mkdir -p ./${k8s_version}/${prod_name}
$ cp ./results/plugins/e2e/results/global/* ./${k8s_version}/${prod_name}/

$ cat << EOF > ./${k8s_version}/${prod_name}/PRODUCT.yaml
vendor: Conoa AB
name: Proact Managed Container Platform
version: v1.0
website_url: https://www.conoa.se/container-as-a-service/ 
repo_url: 
documentation_url: https://www.conoa.se/container-as-a-service/ 
product_logo_url: 
type: hosted platform
description: "Full Stack managed kubernetes platform which let's you focus on your application, we'll do the rest!"
EOF
```
