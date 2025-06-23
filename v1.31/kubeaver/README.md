### Install Docker and Docker Compose

Install Docker on the host where you want to install Kubeaver using the official Docker guide: [Install Docker Engine](https://docs.docker.com/engine/install/). After installation, run the `docker compose version` command to ensure Docker Compose is correctly installed. If not, manually install Docker Compose.

### Deploy Kubeaver

Download Kubeaver code:
```
git clone https://github.com/eb-k8s/kubeaver.git
```

Start Kubeaver using Docker Compose:
```
# Switch to the directory containing the Docker Compose file
cd ./deploy
# Start Kubeaver
docker compose up -d
```

After this, Kubeaver will be successfully installed on your host. You can now access it via port 80.

### Offline Package Import

Download the corresponding version of the offline package based on the K8s cluster version you plan to install. 
Download the offline package:
```
docker pull ghcr.io/eb-k8s/kubeaver/kubeaver_offline:v1.31.9
docker pull ghcr.io/eb-k8s/kubeaver/kubeaver_oslib:v1.0
docker run -d ghcr.io/eb-k8s/kubeaver/kubeaver_offline:v1.31.9 --name kubeaver_offline 
docker run -d ghcr.io/eb-k8s/kubeaver/kubeaver_oslib:v1.0 --name kubeaver_oslib
docker cp kubeaver_offline:/root/base_k8s_v1.31.9.tgz .
docker cp kubeaver_oslib:/root/extend_CentOS_7_Core.tgz .
```
You can then obtain the offline package `base_k8s_v1.31.9.tgz、extend_CentOS_7_Core.tgz` and import it into Kubeaver.

### Deploy a K8s Cluster

1. Add the hosts where you want to deploy the K8s cluster in the **Host Management** section.
2. Click the **Offline Package Import** button on the offline package management interface to import the offline package you just downloaded.
3. In the **Cluster Management** interface, create your cluster by selecting the cluster version, network plugin, and the hosts included in the cluster.
4. Click **Save**, then select the newly created cluster in the **Cluster Management** interface and click **Deploy** to start the deployment.
5. View the status and progress of tasks in the **Task Queue** or check running/completed tasks in the **Task History**.

### Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
```

**NOTE:** You can run the command synchronously by adding the flag `--wait` but be aware that running the Conformance tests can take an hour or more.

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
