# China Mobile CMIT PaaS

An Enterprise Platform-as-a-Service based on Kubernetes

## Install CMIT PaaS

### Download the package

Contact CMIT PaaS Dev Team to download the installation package.

### Run the following command to install the CMIT PaaS:
1. Install Docker by following https://docs.docker.com/engine/install;
2. Install CMIT PaaS
```sh
$ docker load < cmit-paas-20200715.tar
$ docker run -tid --name cmitpaas -p 1199:8088 --storage-opt size=70G \
         --restart always \
          -v /var/run/docker.sock:/var/run/docker.sock \
        cmitpaas:20200715
```
3. Please use UI to create Kubernetes cluster.

- 3.1. Log in as the admin user, click "Resource"-"Compute"-"Clusters"-"Cluster Management" to enter the cluster management page.

- 3.2. Click "Cluster Management" → "Import Cluster" to enter the new cluster page

- 3.3. Click the "Setup a new cluster" button and fill in the content cluster deployment configuration file in the required format:

```
Filling Instructions:
Name is required description

etcd
Ip (is the IP address of the new etcd host)
Ansible_ssh_user (is the root account of etcd host)
Ansible_ssh_pass (is the root password of etcd host)

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

1. On one of the worker node, install sonobuoy:

```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

2. Run sonobuoy:

```sh
$ sonobuoy run --mode=certified-conformance
```

3. Watch logs:

```sh
$ sonobuoy logs
```

4. Check status:

```sh
$ sonobuoy status
```

5. Retrieve results:

Wait for around 60 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```sh
$ sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```
