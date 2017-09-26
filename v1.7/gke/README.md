To reproduce.

```console
% gcloud container clusters create c --cluster-version=1.7.8
% kubectl create -f conformance.yaml
% kubectl logs -f -n sonobuoy sonobuoy

# wait for completion, signified by
# I0921 00:04:32.447389       1 master.go:67] no-exit was specified, sonobuoy is now blocking

% kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
% tar xfz results/*.tar.gz
```

I have included `conformance.yaml` in this PR.

Then grab `plugins/e2e/results/{e2e.log,junit_01.xml,version.txt}` and add them to this PR.
