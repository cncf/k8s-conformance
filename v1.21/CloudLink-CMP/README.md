# login
Sign into CloudLink-CMP Console with you own account.

![login](images/login.png)

# Create kubernetes cluster
Setting cluster name, select machines, and setting configs to creat your cluster.

![create cluster](images/cluster.png)

![shell](images/shell.png)

# Run conformance tests
Start the conformance tests on your test host

```

$ sonobuoy run --mode=certified-conformance --dns-pod-labels k8s-app=core-dns

```
Check the status:
```
$ sonobuoy status
```

Once the status commands shows the run as completed, you can download the results tar.gz file:

```
$ sonobuoy retrieve
```