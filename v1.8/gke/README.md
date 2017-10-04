To reproduce:

```console
% gcloud container clusters create c --cluster-version=1.8.0
% curl -L https://gist.githubusercontent.com/mml/ff67b85bcc6c996185166afe5e435712/raw/0df66a24537c0464e0099f48e9c885aa8777887a/sonobuoy-mml.yaml | kubectl create -f -
% kubectl logs f -n sonobuoy sonobuoy

# wait for "no-exit was specified, sonobuoy is now blocking"

% kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
