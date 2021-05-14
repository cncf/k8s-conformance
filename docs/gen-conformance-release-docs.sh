#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "KUBE_ROOT=${KUBE_ROOT}"
echo "VERSION=${VERSION}"
CONF_DOCS_DIR=$(pwd)

cd ${KUBE_ROOT}
git checkout v${VERSION}.0 && git branch

./hack/make-rules/build.sh vendor/github.com/onsi/ginkgo/ginkgo test/e2e/e2e.test

./_output/bin/ginkgo --dryRun=true --focus='[Conformance]' ./_output/bin/e2e.test -- --spec-dump "${KUBE_ROOT}/_output/specsummaries.json" > /dev/null

go run ./test/conformance/walk.go --version=$VERSION \
                                  --url https://github.com/kubernetes/kubernetes/tree/release-${VERSION}/ \
                                  --docs ./_output/specsummaries.json > ./_output/KubeConformance-${VERSION}.md

sed "s|tree/release-${VERSION}.*/test/e2e|tree/release-${VERSION}/test/e2e|g" ./_output/KubeConformance-${VERSION}.md > ${CONF_DOCS_DIR}/KubeConformance-${VERSION}.md
