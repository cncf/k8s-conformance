#!/bin/bash

# Copyright 2023 CNCF.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$(realpath "$0")")"
cd "$(git rev-parse --show-toplevel)"

UNWANTED_FILE_TYPES=(zip)

echo "notice: gathering facts..."
OLDEST_UNSUPPORTED='v1.7'
LAST_KEPT_SUBMISSIONS="5"
KUBERNETES_STABLE_VERSION="$(curl -sSL https://storage.googleapis.com/kubernetes-release/release/stable.txt)"
KV_MA="$(echo "${KUBERNETES_STABLE_VERSION}" | grep -Eo '^v[1]')"
KV_MI="$(echo "${KUBERNETES_STABLE_VERSION}" | sed 's/v[1].\(.*\)\..*/\1/g')"
OLDEST_UNSUPPORTED_MI="$(echo "$OLDEST_UNSUPPORTED" | grep -Eo '[0-9]{1,2}$')"
LAST_SUPPORTED_MI="$(echo $((KV_MI-=LAST_KEPT_SUBMISSIONS)))"
cat <<EOF
- oldest tracked release            : $OLDEST_UNSUPPORTED
- latest stable release             : $KV_MA.$KV_MI
- keeping the last so-many releases : $LAST_KEPT_SUBMISSIONS
- pruning versions up until         : $KV_MA.$LAST_SUPPORTED_MI
- pruning file-types                : (${UNWANTED_FILE_TYPES[@]})
EOF

echo -e "\nnotice: removing unwanted files\n"
echo "${UNWANTED_FILE_TYPES[@]/#/$'\n'}" | xargs -I{} git filter-repo --force --path-glob '*.{}' --invert-paths

echo -e "\nnotice: removing unsupported releases\n"
seq "$OLDEST_UNSUPPORTED_MI" "$LAST_SUPPORTED_MI" | sed "s/^/$KV_MA./g" | xargs -I{} git filter-repo --force --path {} --invert-paths

echo -e "\nnotice: complete\n"
echo -e "TODO: git push -f origin $(git rev-parse --abbrev-ref HEAD)"
