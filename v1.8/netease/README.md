#### How to Reproduce

1. Install an 'Netease Container Service Dedicated' kubernetes cluster based on steps from [here](https://www.163yun.com/docs/product/container-service-dedicated/introduction)

2. Launch the e2e conformance test with following command, and this will launch a pod named as sonobuoy under namespace sonobuoy.

```
curl -L https://raw.githubusercontent.com/mml/k8s-conformance/gke-v1.8/sonobuoy-conformance-1.7.yaml | kubectl apply -f -

```

**Note**: If you have trouble with pulling k8s-conformance related images because the reason of Firewall, we provide you with remedial measures [below](#pull-k8s-conformance-related-images-for-you).

3. Check logs of sonobuoy to see when this can be finished.

```
kubectl logs -f -n sonobuoy sonobuoy

```

4. Watch sonobuoy's logs with above command and wait for the line no-exit was specified, sonobuoy is now blocking. If this line appeared, it means the conformance test has been finished.

5. Use kubectl cp to bring the results to your local machine by the following command:


```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

6. Expand the tarball, and retain plugins/e2e/results/{e2e.log,junit.xml} by below command:

```
cd results
tar xfz *_sonobuoy_*.tar.gz
```



---

#### Pull k8s-conformance Related Images For You

1. Login in worker node and pull k8s-conformance related images:

```
e2e_helper pull

```
2. Login in master node. Launch the e2e conformance test with following command, and this will launch a pod named as sonobuoy under namespace sonobuoy.

```
# kubectl cordon $master_node    // set master node unschedulable

# curl -L https://raw.githubusercontent.com/mml/k8s-conformance/gke-v1.8/sonobuoy-conformance-1.7.yaml > conformance.yaml

# update conformance.yaml file：
(1) replace "gcr.io/heptio-images/kube-conformance:v1.7.3" with "hub.c.163.com/conformance/kube-conformance:v1.8.2",
(2) replace all ImagePullPolicy "Always" with "IfNotPresent"


# kubectl apply -f conformance.yaml

```
