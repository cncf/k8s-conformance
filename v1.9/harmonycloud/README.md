## To Reproduce   

1. Install the Harmonycloud product from [here](http://harmonycloud.cn/products/rongqiyun/), the kubernetes version is v1.9.0.

2. Download the file 'sonobuoy-conformance.yaml' with below command.

```
wget https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml
```
3. If you can't access [http://www.gcr.io](http://www.gcr.io), you should download some pre-requisite images from other website. Then change 'imagePullPolicy' from "Always" to "IfNotPresent".

4. Run the below command

```
kubectl apply -f sonobuoy-conformance.yaml
```

5. Watch Sonobuoy's logs with below command

```
kubectl logs -f -n sonobuoy sonobuoy
```
6. Watch sonobuoy's logs with above command and wait for the line "no-exit was specified, sonobuoy is now blocking". 

7. use kubectl cp to bring the results to your local machine with below command.
```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

8. expand the tarball, and retain the 2 files plugins/e2e/results/{e2e.log,junit.xml}.

```
cd results
tar -zxvf *.tar.gz
```