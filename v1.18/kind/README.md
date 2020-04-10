# kind conformance

## Pre-reqs

You'll need `docker`/`kind`/`sonobuoy`, and `kubectl` for debugging.
```shell
# install/update kind
GO111MODULE=on go get "sigs.k8s.io/kind@v0.7.0"

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

Save the following script as `./run.sh`.
You can then run it by invoking: `./run.sh 1.18.0`
```shell
#!/usr/bin/env sh

v_k8s="${1:-"1.18.0"}"

e2e_focus="${e2e_focus}"
rerun_failed="${rerun_failed}"

set -eu

folder="v${v_k8s}_$(date +"%F_%H:%M.%S")"

# https://github.com/kubernetes-sigs/kind/releases/tag/v0.7.0
image_tags="
v1.18.0@sha256:0e20578828edd939d25eb98496a685c76c98d54084932f76069f886ec315d694
v1.17.0@sha256:9512edae126da271b66b990b6fff768fbb7cd786c7d39e86bdf55906352fdf62
v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
v1.15.7@sha256:e2df133f80ef633c53c0200114fce2ed5e1f6947477dbc83261a6a921169488d
v1.14.10@sha256:81ae5a3237c779efc4dda43cc81c696f88a194abcc4f8fa34f86cf674aa14977
v1.13.12@sha256:5e8ae1a4e39f3d151d420ef912e18368745a2ede6d20ea87506920cd947a7e3a
v1.12.10@sha256:68a6581f64b54994b824708286fafc37f1227b7b54cbb8865182ce1e036ed1cc
v1.11.10@sha256:e6f3dade95b7cb74081c5b9f3291aaaa6026a90a977e0b990778b6adc9ea6248
"

v_tag="$( echo "${image_tags}" | grep "${v_k8s}" )"

cat << EOF \
  | kind create cluster \
    --name "${v_k8s}-conformance" \
    --image="kindest/node:${v_tag}" \
    --config=/dev/stdin \
    || true
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

ctx="--context=kind-${v_k8s}-conformance"

sonobuoy delete "${ctx}" --wait

if [ "${e2e_focus}" ]; then
  echo e2e_focus
  folder="${folder}-e2e_focus"
  sonobuoy run "${ctx}" --wait "--e2e-focus=${e2e_focus}"
elif [ "${rerun_failed}" ]; then
  echo rerun
  folder="${folder}-rerun"
  sonobuoy e2e "${ctx}" --wait "${rerun_failed}" --rerun-failed
else
  echo certified_conformance_run
  sonobuoy run "${ctx}" --wait --mode=certified-conformance
fi

outfile="$(sonobuoy retrieve "${ctx}")"
mkdir -p "./${folder}"
tar xzf "${outfile}" -C "./${folder}"

sonobuoy results --plugin=e2e "${outfile}"
```

## Observe Sonobuoy

Running all the conformance tests often takes an hour or two.

```bash
## watch cluster state
watch kubectl get all --all-namespaces
## watch sonobuoy
sonobuoy status
sonobuoy logs -f
  # e2e test logs only show up if you run this after the pod becomes ready
```

## Rerun tests

If any tests flake, you can re-run the tests.
It's faster to re-use the kind cluster since it's already pulled a large number of images.

`run.sh` provides env options to support this: `e2e_focus` and `rerun_failed`.
```bash
e2e_focus="1.10 Sample API Server" ./run.sh 1.18.0
rerun_failed=202004100324_sonobuoy_b6960065-9069-4a7d-b624-cf6ea610de25.tar.gz ./run.sh 1.18.0
```

## Collect the Conformance Results

After `run.sh 1.18.0` completes, look for the message: `failed tests: 0`

The test results have been un-tarred to `conformance-results/v1.18.0_<timestamp>/`.

The needed test files for submission are:
- `./plugins/e2e/results/e2e.log`
- `./plugins/e2e/results/junit_01.xml`

## Cleanup

```bash
sonobuoy delete
kind delete cluster --name "1.18.0-conformance"
```
