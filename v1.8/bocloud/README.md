#### How to Reproduce

1. Install an 'Bocloud BeyondContainer' kubernetes cluster based on steps from [here](http://bocloud.com.cn/product_container.html)

![](http://www.bocloud.com.cn/upload/2018/20180104110838.jpg)

![](http://www.bocloud.com.cn/upload/2018/20180104110856.jpg)

2. Launch the e2e conformance test with following command, and this will launch a pod named as sonobuoy under namespace sonobuoy.

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

3. Check logs of sonobuoy to see when this can be finished.

```
kubectl logs -f -n sonobuoy sonobuoy
```

4. Watch sonobuoy's logs with above command and wait for the line `no-exit was specified, sonobuoy is now blocking`. If this line appeared, it means the conformance test has been finished.

5. Use `kubectl cp` to bring the results to your local machine by the following command:

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

6. Expand the tarball, and retain `plugins/e2e/results/{e2e.log,junit.xml}` by below command:

```
cd results
tar xfz *_sonobuoy_*.tar.gz
```

