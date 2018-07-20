To reproduce.

```console
$ pharmer create credential do1
$ pharmer create cluster con111 \
    --provider=digitalocean \
    --zone=nyc3 \
    --nodes=2gb=1 
    --credential-uid=do1 \
    --kubernetes-version=v1.11.0
	

$ pharmer apply con111 --v=3

# wait for completion the process.
$ pharmer use cluster con110

$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

# wait for completion, signified by
# no-exit was specified, sonobuoy is now blocking

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results --namespace=sonobuoy
$ tar xfz results/*.tar.gz
```

Then grab `plugins/e2e/results/{e2e.log,junit_01.xml,version.txt}` and add them to this PR.