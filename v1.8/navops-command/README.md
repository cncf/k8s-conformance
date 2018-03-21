## Reproduce test results

1. Install Command from [here](https://www.navops.io/command.html)

2. Download the file 'sonobuoy-conformance.yaml'.

```
wget https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml
```

4. Install the test suite. 

```
kubectl apply -f sonobuoy-conformance.yaml
```

5. Watch Sonobuoy's logs and wait for line: 
> "no-exit was specified, sonobuoy is now blocking"

```
kubectl logs -f -n sonobuoy sonobuoy
```

6. use kubectl cp to bring the results to local machine with below command.
```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

7. expand the tarball, and retain the 2 files plugins/e2e/results/{e2e.log,junit.xml}.

```
cd results
tar -zxvf *.tar.gz
```
