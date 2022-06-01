# Conformance tests for Hitachi Kubernetes Service v1.10

## Create HKE Cluster

As per [documentation](https://knowledge.hitachivantara.com/Documents/Cloud_Services/Kubernetes_Service) create a HKE cluster from with the UI.

To do this you will need to have registered for the HKS procuct and be part of a valid organisation within the product which has an active license.

To create a HKE cluster you will need to login to the HKS cloud service here: https://console.cloud.hitachivantara.com/hks/home and follow the documentation as provided above. This may require that you create a provider in your HKS organisation, depending on which cloud service you are using (AWS, GCP, Azure). This can also be done using the VMWare provider or the manual provider.

Use the guided HKS UI workflow to create your HKE cluster using your chosen provider (AWS/GCP/Azure/VMWare or Manual).

Once the cluster has turned to a green status in the HKS UI you are then ready to perform the conformance test.


## Run Conformance Test

1. Ensure you have a system where you can run the Sonobuoy tool from - ideally this will need to have the kubectl command installed.

2. Once your HKE cluster is active (green in the UI), copy the kubeconfig for the cluster from the HKS UI and execute this code on the system where you will run the Sonobuoy tool. Check that you can see the HKE cluster by exectuing the 'kubectl get nodes -o wide' command.

3. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

4. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

5. Watch the logs:
```sh
$ sonobuoy logs
```

6. Check the status:
```sh
$ sonobuoy status
```

7. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ sonobuoy retrieve
```

8. To clean up Kubernetes objects created by Sonobuoy, run:
```
$ sonobuoy delete
