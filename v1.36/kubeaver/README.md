### Install Docker and Docker Compose

Install Docker on the host where you want to install Kubeaver using the official Docker guide: [Install Docker Engine](https://docs.docker.com/engine/install/). After installation, run the `docker compose version` command to ensure Docker Compose is correctly installed. If not, manually install Docker Compose.

### Deploy Kubeaver

**System requirements:**

On a Linux host:
  - Software:
    - docker 20.10.10-ce+
  - Hardware:
    - CPU: 2 vCPU
    - Memory: 4 GB
    - Disk: 60 GB

**Download and Unpack the Installer:**

1. Go to the [Kubeaver releases page](https://github.com/eb-k8s/kubeaver/releases).
2. Download the Kubeaver 1.0.2 offline installer and transfer it to the installation host.
3. Use tar to extract the installer package:

```ShellSession
tar xzvf kubeaver-offline-installer-v1.0.2.tgz
```

4. Change to the installation directory:

```ShellSession
cd kubeaver-offline-installer-v1.0.2
```

5. Install and start Kubeaver by using the start.sh script:

```ShellSession
./start.sh
```

The installer uses frontend `ghcr.io/eb-k8s/kubeaver/kubeaver_frontend:v1.0.2` and backend `ghcr.io/eb-k8s/kubeaver/kubeaver_backend:v1.0.2-134`. After this, Kubeaver will be successfully installed on your host. You can now access it via port 80.

### Offline Package Import

Obtain the Kubernetes v1.36.4 base package `base_k8s_v1.36.4.tgz` and the operating-system extension package matching your target nodes. This run used Ubuntu 22.04.5 LTS / amd64, with OS resources under `Ubuntu_22.04.5_LTS`. Import the corresponding base and OS packages into Kubeaver.

The nodes must be able to reach Kubeaver's file and image services. Configure `store.e-byte.cn` to resolve to the control host's node-accessible IP address, allow access to TCP port 80, and configure the node container runtime to use this HTTP registry.

### Deploy a K8s Cluster

1. Add the hosts where you want to deploy the K8s cluster in the **Host Management** section.
2. Click the **Offline Package Import** button on the offline package management interface to import the offline packages.
3. In the **Cluster Management** interface, create your cluster by selecting Kubernetes `v1.36.4`, Flannel `0.28.9`, one control-plane node, and two worker nodes.
4. Click **Save**, then select the newly created cluster in the **Cluster Management** interface and click **Deploy** to start the deployment.
5. View the status and progress of tasks in the **Task Queue** or check running/completed tasks in the **Task History**.

Use the deployed cluster's kubeconfig on the host where you will run Sonobuoy, replacing `<cluster-id>` with your cluster's ID:

```ShellSession
docker cp "kubeaver_backend_v1-134:/root/backend/data/config/config-<cluster-id>/config" ./cluster-kubeconfig
chmod 600 ./cluster-kubeconfig
export KUBECONFIG="$PWD/cluster-kubeconfig"
kubectl get nodes
kubectl get pods -n kube-system
```

Wait until all nodes are Ready and the system Pods are ready before starting the tests.

### Conformance Test

The standard tool for running these tests is [Sonobuoy](https://github.com/vmware-tanzu/sonobuoy). Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of Kubernetes.

Download the Linux amd64 [Sonobuoy v0.57.5 binary release](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.5). For an offline environment, download and transfer the CLI and test images beforehand.

Mirror `registry.k8s.io/conformance:v1.36.4`, `sonobuoy/sonobuoy:v0.57.5`, and the required Kubernetes v1.36.4 E2E images into Kubeaver's registry as `store.e-byte.cn/cncf/<upstream-repository>:<tag>`, preserving their linux/amd64 contents. Verify that the nodes can pull them. Configure the frontend `/v2/` proxy with `client_max_body_size 0` and `proxy_request_buffering off` to allow large image uploads.

Create the test image registry mapping:

```ShellSession
cat > repos.yaml <<'EOF'
promoterE2eRegistry: store.e-byte.cn/cncf/registry.k8s.io/e2e-test-images
buildImageRegistry: store.e-byte.cn/cncf/registry.k8s.io/build-image
gcEtcdRegistry: store.e-byte.cn/cncf/registry.k8s.io
gcRegistry: store.e-byte.cn/cncf/registry.k8s.io
sigStorageRegistry: store.e-byte.cn/cncf/registry.k8s.io/sig-storage
dockerLibraryRegistry: store.e-byte.cn/cncf/docker.io/library
cloudProviderGcpRegistry: store.e-byte.cn/cncf/registry.k8s.io/cloud-provider-gcp
EOF
```

Deploy Sonobuoy to your cluster with:

```ShellSession
sonobuoy run --mode=certified-conformance \
  --plugin=e2e \
  --kubernetes-version=v1.36.4 \
  --kube-conformance-image=store.e-byte.cn/cncf/registry.k8s.io/conformance:v1.36.4 \
  --sonobuoy-image=store.e-byte.cn/cncf/sonobuoy/sonobuoy:v0.57.5 \
  --e2e-repo-config=./repos.yaml
```

**NOTE:** Certified-conformance mode selects `E2E_FOCUS=\[Conformance\]`, leaves `E2E_SKIP` empty, and runs serially. Do not skip any Conformance tests. You can run synchronously by adding `--wait`, but the tests can take an hour or more.

View actively running pods:

```ShellSession
sonobuoy status
```

To inspect the logs:

```ShellSession
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to your current directory:

```ShellSession
outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod. Extract the contents into `./results` with:

```ShellSession
mkdir -p ./results
tar xzf "$outfile" -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```ShellSession
sonobuoy delete
```
