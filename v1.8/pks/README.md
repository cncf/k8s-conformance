# PKS (Pivotal Container Services)

Pivotal Container Services (PKS) utilizes [KUBO](https://pivotal.io/partners/kubo) to deploy and manage your Kubernetes cluster.

A Kubernetes cluster can be deployed to your choice of IaaS. Please follow the guide [here](https://docs-pks.cfapps.io/pks/installing.html) to install it with GCP or vSphere. A PCF (Pivotal Cloud Foundry) environment with Ops Manager will be needed.

Upon deploying Ops man with the PKS tile, create the cluster by issuing a POST request:
```
curl -k -d '{"name": "${cluster_name}","parameters": {"kubernetes_master_host": "${KUBERNETES_SERVICE_HOST}","worker_haproxy_ip_addresses": "${WORKLOAD_ADDRESS:-}"},"plan": ""}' -X POST https://{PKS_API_ENDPOINT}:9021/v1/clusters/
```

After the cluster has been created, bind it by issuing a POST request:
```
curl -k -d "{}" -X POST https://{PKS_API_ENDPOINT}:9021/v1/clusters/{CLUSTER_NAME}/binds
```
This will return a response with the kubeconfig, which can be pasted into ~/.kube/config.

## Running the k8s conformance tests

Set your kubectl to point your CLI to the deployed kubernetes cluster. See the instructions [here](https://docs-pks.cfapps.io/pks/using.html) for steps to access your cluster.

You can then run the k8s conformance test by running the following command:

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

