# kind conformance

## Pre-reqs

You'll need `docker`/`kind`/`sonobuoy`, and `kubectl` for debugging.
```shell
# install/update kind
GO111MODULE=on go get "sigs.k8s.io/kind@v0.18.0"

# install sonobuoy locally
v_sonobuoy="0.18.0"
os_arch="linux_amd64"
curl -sSL "https://github.com/heptio/sonobuoy/releases/download/v${v_sonobuoy}/sonobuoy_${v_sonobuoy}_${os_arch}.tar.gz" | sudo tar -xz --exclude LICENSE -C /usr/bin
```

## Run

Create a directory to store the results:
```
mkdir -p conformance-results
cd conformance-results
```

Run the following

```
sonobuoy run --mode=certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v"
```

## Observe Sonobuoy

Running all the conformance tests often takes an hour or two.


### watch cluster state
`watch kubectl get all --all-namespaces`

### watch sonobuoy
`sonobuoy status`
`sonobuoy logs -f` (e2e test logs only show up if you run this after the pod becomes ready)

## Collect the Conformance Results

When `sonobuoy` has completed, retrieve the logs via

```
sonobuoy retrieve
```

The un-tarred to `conformance-results/<timestamp>/`.

The needed test files for submission are:
- `./plugins/e2e/results/global/e2e.log`
- `./plugins/e2e/results/global/junit_01.xml`

## Cleanup

```bash
sonobuoy delete
kind delete cluster --name "1.18.0-conformance"
```
