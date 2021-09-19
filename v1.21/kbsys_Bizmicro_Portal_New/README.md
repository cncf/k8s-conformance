Run Conformance Test
The standard tool for running these tests is Sonobuoy. Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes.

Download a binary release of the CLI, or build it yourself by running:

$ go get -u -v github.com/heptio/sonobuoy
Deploy a Sonobuoy pod to your cluster with:

$ sonobuoy run
NOTE: You can run the command synchronously by adding the flag --wait but be aware that running the Conformance tests can take an hour or more.

View actively running pods:

$ sonobuoy status 
To inspect the logs:

$ sonobuoy logs
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

$ outfile=$(sonobuoy retrieve)
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

mkdir ./results; tar xzf $outfile -C ./results
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

sonobuoy delete

------------------------------------------------------------------------------------------------------------------------
Install

$ git clone https://github.com/kubernetes-sigs/kubespray.git
$ cd kubespray
$ sudo yum -y install python3
$ sudo pip3 install -r requirements.txt
$ declare -a IPS=(${NODE1 IP} ${NODE2 IP} ${NODE3 IP})
$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

$ vi inventory/mycluster/hosts.yaml # edit hosts.yaml
$ ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
