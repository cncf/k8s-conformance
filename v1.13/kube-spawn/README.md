## To Reproduce:

* Install Fedora 29 from https://cloud.fedoraproject.org/ (GP2 image) on AWS:
  - m4.large
  - Disk: at least 50GiB
  - ssh: `ssh -i ~/.ssh/$KEY fedora@$IP`
* Start a kube-spawn v0.3.0 Kubernetes cluster on the AWS EC2 instance:
```
export KUBERNETES_VERSION=v1.13.0 # or other version
sudo setenforce 0
sudo dnf install -y btrfs-progs git go iptables libselinux-utils polkit qemu-img systemd-container
mkdir go
export GOPATH=$HOME/go
go get -u github.com/containernetworking/plugins/plugins/...
export CNI_PATH=$GOPATH/bin
mkdir -p $GOPATH/src/github.com/kinvolk/kube-spawn
curl -sSLO https://github.com/kinvolk/kube-spawn/releases/download/v0.3.0/kube-spawn-v0.3.0.tar.gz
tar xf kube-spawn-v0.3.0.tar.gz
sudo cp kube-spawn-v0.3.0/kube-spawn /bin/
sudo -E kube-spawn create --kubernetes-version=$KUBERNETES_VERSION --cni-plugin-dir=$GOPATH/bin
sudo -E kube-spawn start --nodes=3 --cni-plugin-dir=$GOPATH/bin
export KUBECONFIG=/var/lib/kube-spawn/clusters/default/admin.kubeconfig
sudo curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl get nodes # repeat until the nodes are "Ready"
kubectl version > version.txt
```

* Run Sonobuoy with the command:

Install the git & golang software, then build the Sonobuoy tool:

```
go get -u -v github.com/heptio/sonobuoy
```

* Deploy a Sonobuoy pod to the kube-spawn cluster with:

```
sonobuoy run
```

* Check the filename of the Sonobuoy report with `kubectl logs -f -n heptio-sonobuoy sonobuoy`
  - It might take a while...
  - Visible with `Results available at /tmp/sonobuoy/2019....tar.gz`

* View actively running pods:

```
sonobuoy status
```

* Retrieve results:

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
sonobuoy retrieve .
```

Extract the `.tar.gz` contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

* Upload results:

Prepare the necessary documents and submit the PR according to [official guide - uploading](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#uploading).
