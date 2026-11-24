# Conformance Test Procedure for AXLEON
All of the tasks below will be done on the Bastion Server unless otherwise noted.


## Installing the Deploy Artifact
-   **Extract and Install the Artifact**
```
deploy_version=<deploy-version>   # e.g. v1.36.4-10
tar xf axleon-platformops-deploy-"$deploy_version".tar
cd axleon-platformops-deploy-"$deploy_version"
./scripts/target/install.sh
```


## Preparing Nodes
-   **Generate an SSH Key**
```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/axleon -N ''
cat ~/.ssh/axleon.pub
```

-   **Register the Public Key and sudo on Each Node (run as root on each node)**
```
ssh_user=<node-user>
ssh_pubkey='<bastion-public-key>'
home_dir=$(getent passwd "$ssh_user" | cut -d: -f6)
install -d -m 700 -o "$ssh_user" -g "$(id -gn "$ssh_user")" "$home_dir/.ssh"
echo "$ssh_pubkey" >> "$home_dir/.ssh/authorized_keys"
chmod 600 "$home_dir/.ssh/authorized_keys" && chown "$ssh_user:" "$home_dir/.ssh/authorized_keys"
echo "$ssh_user ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$ssh_user"
chmod 440 "/etc/sudoers.d/$ssh_user" && visudo -cf "/etc/sudoers.d/$ssh_user"
```


## Configuring and Creating the Cluster
-   **Enter the Deploy Container**
```
sudo nerdctl exec -it platformops-deploy bash
cp -r sample inventory/<cluster>
```

-   **Node Configuration**
```
vi inventory/<cluster>/hosts.yaml

control_plane:
  hosts:
    control01:
      ansible_host: "<control01-ip>"
worker:
  hosts:
    worker01:
      ansible_host: "<worker01-ip>"
    worker02:
      ansible_host: "<worker02-ip>"
```

-   **Cluster Configuration**
```
vi inventory/<cluster>/group_vars/all/cluster.yaml

install_type: online
ansible_ssh_private_key_file: /root/.ssh/axleon
ansible_user: <node-user>
ansible_become: true
kubernetes_version: "<k8s-version>"
apiserver_load_balancer_host: <vip>
apiserver_load_balancer_port: 8443
apiserver_load_balancer_interface: <nic-name>
pod_subnet: 10.244.0.0/16
service_subnet: 10.96.0.0/12
cni_plugin: calico
```

-   **Create the Cluster**
```
ansible -i inventory/<cluster>/hosts.yaml all -m ping -b
ansible-playbook -i inventory/<cluster>/hosts.yaml cluster.yml
```

-   **Verify the Cluster**
```
export KUBECONFIG=/ansible/inventory/<cluster>/artifacts/admin.conf
kubectl get nodes
```


## Running the Conformance Tests
All of the commands below are run inside the deploy container (`platformops-deploy`).

-   **Prepare a Working Directory**
```
cluster=<cluster>
export KUBECONFIG=/ansible/inventory/"$cluster"/artifacts/admin.conf
mkdir -p /ansible/inventory/"$cluster"/workspace/sonobuoy
cd /ansible/inventory/"$cluster"/workspace/sonobuoy
```

-   **Download Sonobuoy** (https://github.com/vmware-tanzu/sonobuoy/releases)
```
sonobuoy_version=$(curl -sL -o /dev/null -w '%{url_effective}' https://github.com/vmware-tanzu/sonobuoy/releases/latest)
sonobuoy_version=${sonobuoy_version##*/v}
curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v"$sonobuoy_version"/sonobuoy_"$sonobuoy_version"_linux_amd64.tar.gz
tar -xvzf sonobuoy_"$sonobuoy_version"_linux_amd64.tar.gz
./sonobuoy version
```

-   **Start the Sonobuoy Test**
```
./sonobuoy run --mode=certified-conformance
```

-   **Check the Progress (It Should End with 'Sonobuoy has completed')**
```
./sonobuoy status
```

-   **Save the Test Results**
```
outfile=$(./sonobuoy retrieve)
mkdir -p ./results; tar xzf "$outfile" -C ./results
```

-   **Verify the Two Required Files in the Path Below**
```
cat ./results/plugins/e2e/results/global/e2e.log
cat ./results/plugins/e2e/results/global/junit_01.xml
```

-   **Clean Up**
```
./sonobuoy delete --all --wait
```
