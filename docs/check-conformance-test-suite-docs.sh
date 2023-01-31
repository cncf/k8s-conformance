#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

cd "$(realpath "$(dirname "$0")")" && cd "$(git rev-parse --show-toplevel)"
GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
echo "GITHUB_WORKSPACE=$GITHUB_WORKSPACE"

function init_settings() {
  TEST_SUITE_DOCUMENT="unchecked"

  STABLE_VERSION="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
  echo "STABLE_VERSION: $STABLE_VERSION"
  
  RELEASE_VERSION="$(echo "$STABLE_VERSION" | awk -F '.' '{print $1 "." $2}').0"
  echo "RELEASE_VERSION: $RELEASE_VERSION"
  
  KUBE_CONFORMANCE_FILENAME="KubeConformance-$(echo "$STABLE_VERSION" | awk -F '.' '{print $1 "." $2}' | sed 's/v//').md"
  echo "KUBE_CONFORMANCE_FILENAME: $KUBE_CONFORMANCE_FILENAME"
  
  CONFORMANCE_BASE_URL="${CONFORMANCE_BASE_URL:-https://raw.githubusercontent.com/cncf/k8s-conformance/master/docs}"
  echo "CONFORMANCE_BASE_URL: $CONFORMANCE_BASE_URL"
  
  MD_FILE_URL=${CONFORMANCE_BASE_URL}/${KUBE_CONFORMANCE_FILENAME}
  echo "MD_FILE_URL: $MD_FILE_URL"
  
  RESPONSE_CODE=$(curl -s -o /dev/null "$MD_FILE_URL" --write-out "%{http_code}")
  if [[ $RESPONSE_CODE ==  "404" ]]; then
    TEST_SUITE_DOCUMENT="missing"
  fi
}

function setup_k8s_repo() {
  mkdir -p /tmp/go/src/k8s.io
  cd "$_"
  if [ ! -d /tmp/go/src/k8s.io/kubernetes ]; then
    git clone --depth 1 --branch "${RELEASE_VERSION}" https://github.com/kubernetes/kubernetes.git
  fi
  export KUBE_ROOT=/tmp/go/src/k8s.io/kubernetes
  cd "${KUBE_ROOT}"
  git log -1
}

function install_go() {
  cd ${KUBE_ROOT}
  GO_VERSION=$(grep -A1 "golang: upstream version" build/dependencies.yaml | tail -1 | awk -F ':' '{print $2}' | sed 's/^ *//')
  echo "GO_VERSION: $GO_VERSION"
  if [ "$(/usr/local/go/bin/go version | cut -d' ' -f 3 | sed 's/go1/1/')" != "${GO_VERSION}" ]; then
    curl -L https://dl.google.com/go/go"${GO_VERSION}".linux-amd64.tar.gz \
      | sudo tar --directory /usr/local --extract --ungzip
  fi
  export PATH="/usr/local/go/bin:$PATH"
  go version
}

function build_deps() {
  sudo apt-get update
  sudo apt-get install -y gcc
  cd "${KUBE_ROOT}"
  ./hack/make-rules/build.sh vendor/github.com/onsi/ginkgo/ginkgo test/e2e/e2e.test
}

function build_release_documentation() {
  cd "${KUBE_ROOT}"
  ./_output/bin/ginkgo --dry-run=true --focus='[Conformance]' ./_output/bin/e2e.test -- --spec-dump "${KUBE_ROOT}/_output/specsummaries.json" > /dev/null

  DOC_VERSION="$(echo "$STABLE_VERSION" | awk -F '.' '{print $1 "." $2}' | sed 's/v//')"
  go run ./test/conformance/walk.go --version="$DOC_VERSION" \
                                  --url https://github.com/kubernetes/kubernetes/tree/release-"${DOC_VERSION}"/ \
                                  --docs ./_output/specsummaries.json > ./_output/KubeConformance-"${DOC_VERSION}".md
  sed "s|tree/release-${DOC_VERSION}.*/test/e2e|tree/release-${DOC_VERSION}/test/e2e|g" ./_output/KubeConformance-"${DOC_VERSION}".md > "${GITHUB_WORKSPACE}"/docs/KubeConformance-"${DOC_VERSION}".md
  echo "${RELEASE_VERSION}" > /tmp/release-version
  echo "Conformance test suite documention for $(< /tmp/release-version) has been created"
}

function main() {
  echo "Executing script: $(basename "$0")"
  echo "Checking status of Kubernetes Conformance test suite documention"
  init_settings
  if [[ $TEST_SUITE_DOCUMENT == "missing" ]]; then
    echo "Conformance test suite documentation for ${RELEASE_VERSION} was not found."
    echo "Generating documentation..."
    setup_k8s_repo
    install_go
    build_deps
    build_release_documentation
  else
    echo "Conformance test suite documentation for ${RELEASE_VERSION} was found. No further action required"
  fi
}

main
