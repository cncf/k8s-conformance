# DigitalChina DataCloud PaaS

An Enterprise Platform-as-a-Service based on Kubernetes

## Install DigitalChina DataCloud PaaS

### Download the package

Contact DigitalChina DataCloud PaaS Team to download the installation package.

### Run the following command to install the K8M PaaS:
1. Install Docker by following https://docs.docker.com/engine/install;
2. Install DigitalChina DataCloud PaaS
```sh
$ docker load < k8m-paas-20241218.tar
$ docker run -tid --name k8mpaas -p 1199:8088 --storage-opt size=80G \
         --restart always \
          -v /var/run/docker.sock:/var/run/docker.sock \
        k8mpaas:20241218
```
3. Please use UI to create Kubernetes cluster.

- 3.1. Log in as the admin user, click "Resource"-"Compute"-"Clusters"-"Cluster Management" to enter the cluster management page.

- 3.2. Click "Cluster Management" → "Import Cluster" to enter the new cluster page

- 3.3. Click the "Setup a new cluster" button and fill in the content cluster deployment configuration file in the required format:

```
Filling Instructions:
Name is required description

etcd
# [member]
ETCD_NAME=etcd2
ETCD_DATA_DIR="/var/lib/etcd_data"
ETCD_LISTEN_PEER_URLS="http://10.255.242.170:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.255.242.170:2380"
ETCD_LISTEN_CLIENT_URLS="http://10.255.242.170:2379,http://127.0.0.1:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://10.255.242.170:2379,http://127.0.0.1:2379"
# [cluster]
ETCD_INITIAL_CLUSTER="etcd1=http://10.255.242.171:2380,etcd2=http://10.255.242.170:2380,etcd3=http://10.255.242.172:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"

Master
ip (is the IP address of the new master host)
Ansible_ssh_user (is the root account of the master host)
Ansible_ssh_pass (is the root password of the master host)
Docker0_ip (is the Docker0 ip setting)
lv_data_path (lv data volume path used by docker)
lv_metadata_path (lv metadata volume path used by docker)

Node
ip (is the IP address of the new node host)
Docker0_ip (is the Docker0 ip setting)
Kubele_hostname_override (Yes)
Apiserver_host_ip (is the kube-apiserver ip of the cluster)
Kube_insecure_port (is the Api port)
Cluster_domain_name (is Cluster.local)
Cluster_dns_ip (is 169.169.0.100)
Docker_registry_url (Yes Fill in registry related information)
Pause_image (No Pause mirror upload and other operations)
Kube_log_dir (is the Kubelet log directory)
Kube_dir (is the Kubelet running directory)
Ansible_ssh_user (is the root account of the master host)
Ansible_ssh_pass (is the root password of the master host)


PARAMETER
etcd_client_port (etcd client port)
etcd_peer_port (etcd internal communication port)
apiserver_host_ip (apiserver IP address)
kube_insecure_port (apiserver non-secure port)
yaml_root (yaml storage path)
dns_setup (Whether to install dnS)
cluster_domain_name (Cluster default domain name)
cluster_dns_ip (cluster dns address)
docker_registry_server_name (Mirror library name)
docker_registry_server_ip Mirror (library IP address)
docker_registry_host_port Mirror (library port)
push_pause_image (Whether the pause image has been uploaded)
pause_image_name (pause image name)
kube_log_dir (k8s log path)
kube_dir k8s (configuration path)
```

- 3.4. Click the "Save" button, the cluster installation configuration file is saved successfully, and the deployment status is not yet deployed 

- 3.5. Click the "Deploy" button, and the deployment log window will pop up again after selecting "Submit" in the pop-up window, and finally the deployment is completed.

When the Kubernetes cluster is up and running, proceed to run the conformance tests.

## Run Conformance Test

1. Start the conformance tests:

```sh
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.2/sonobuoy_0.57.2_linux_amd64.tar.gz
tar -xvf sonobuoy_0.57.2_linux_amd64.tar.gz
mv sonobuoy /usr/bin
sonobuoy run --mode=certified-conformance
```

2. Monitor the conformance tests by tracking the sonobuoy logs, and wait for the line: "no-exit was specified, sonobuoy is now blocking":

```sh
sonobuoy logs -f
```

3. Retrieve result:

```sh
outfile=$(sonobuoy retrieve)
mkdir ./results;
tar -xzf $outfile -C ./results
```
