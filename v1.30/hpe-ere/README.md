All hosts are assumed to be CentOS or RHEL or SLES OS.
Assume that user has HPE Ezmeral Runtime Enterprise software installed on 'controller' host.
Please follow the documentation [here](https://docs.ezmeral.hpe.com/runtime-enterprise/56/) to understand more about deploying ERE and creating the kubernetes cluster.

### Add Gateway 
- Login as `admin` to the Web UI controller running the product.
- In the left pane, under "Epic", select "Hosts".
- In the right pane, in the 'Gateway' section, enter the IP of the machine you want to be the gateway.
- You can also enter the same IP in the 'Hostname' field.
- Enter credentials s.a. username/password. Click 'Add Hosts' button. Go into the 'Site Lockdown' mode if prompted.
- Wait until the bundle is installed on the gateway host. Its status should show as 'Installed'. 

### Add Kubernetes hosts
- In the left pane, under "K8S", select "Hosts".
- Enter the IPs (separated by comas) of the VMs or physical hosts. Provide user credentials that will be used to login into them, such as username/password. Click "Submit" button. Wait for the bundle to be installed on the hosts and for their state to be "ready".

### Create 1.30 Kubernetes cluster
- In the left pane, under "K8S" select "Clusters". 
- In the right pane, click "Create K8s Cluster" button.
- Fill out the form for cluster creation. Specify one of the K8s hosts as Master and two or more as workers.
- Choose the k8s version as '1.30'.
- Click 'Submit' button.
- Wait for the cluster to be in 'ready state'. This might take a while.

### Run Sonobuoy tests on the newly-created cluster
- From terminal on your machine, ssh into the k8s cluster master node with the user/password you've setup in prior step.
- mkdir /root/bin
- curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz" --output $HOME/bin/sonobuoy.tar.gz && tar -xzf $HOME/bin/sonobuoy.tar.gz -C $HOME/bin && chmod +x $HOME/bin/sonobuoy && rm $HOME/bin/sonobuoy.tar.gz
- sonobuoy delete --all --wait
- sonobuoy run --mode=certified-conformance --wait
- sonobuoy status (until status shown as completed)
- sonobuoy retrieve (will give you <OUTPUT.tgz> file)
- sonobuoy results <OUTPUT.tgz>
- sonobuoy delete --all --wait

### Delete the cluster
- Login as `admin` to the Web UI controller running the product.
- In the left pane, under "K8S" select "Clusters"
- In the right pane, select the cluster and click "Destroy Cluster" button.