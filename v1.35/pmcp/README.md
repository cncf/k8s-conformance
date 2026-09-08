# Proact Managed Container Platform

## Steps-to-reproduce

1. Fetch the cluster template from the tooling and export the template with `CLUSTER_TEMPLATE=cluster-tpl.json`.
2. Update the template with values from IPAM, the desired GIT branch, kubernetes version and customer defined settings.
3. Update the inventory with `dooctl -u ${CLUSTER_TEMPLATE}`.
4. The template will normally be picked up by the runner within 5-10 minutes, but in case of hurry:
   ```
   git switch <desired branch/channel>
   export DOO_TARGET_CLUSTER=<the cluster>
   DOO_ACCESS_TOKEN=<access token>
   ansible-playbook -i inventory/tuesday site.yml
   ```
5. run and submit the conformance test according to https://github.com/cncf/k8s-conformance/blob/master/instructions.md
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
contact_email_address: pmcp-monitoring@conoa.se
EOF
```
