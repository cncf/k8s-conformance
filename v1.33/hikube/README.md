# Start a Kubernetes Cluster on Hikube

To start a Kubernetes cluster on [**Hikube**](https://hikube.cloud), simply define your cluster configuration in a YAML manifest, apply it with `kubectl`, and retrieve the generated kubeconfig to access your environment — Hikube automates control plane provisioning, node scaling, and network setup across **three Swiss datacenters**.

## Example with a GPU

```yaml
apiVersion: apps.cozystack.io/v1alpha1
kind: Kubernetes
metadata:
  name: my-first-cluster
spec:
  controlPlane:
    replicas: 3
  nodeGroups:
    general:
      minReplicas: 1
      maxReplicas: 5
      instanceType: "s1.large"
      ephemeralStorage: 50Gi
      gpus:
        - name: "nvidia.com/AD102GL_L40S"
  storageClass: "replicated"
  
  addons:
    certManager:
      enabled: true
    ingressNginx:
      enabled: true
````

Then apply it with:  
~~~
kubectl apply -f my-first-cluster.yaml
~~~
