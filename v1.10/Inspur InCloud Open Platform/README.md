Ready
Environment：
    equipment：6 machines，8 core 16G memory，Download the installation package from the library.
    
    Execute the following command：
    $ mv /root/edc77c77-72c7-49c0-84db-f2222c2a33cf.cfg /root/products/kubernetes-deploy/my_inventory/my_inventory.cfg
    $ mv /root/edc77c77-72c7-49c0-84db-f2222c2a33cf.yml /root/products/kubernetes-deploy/my_inventory/group_vars/all.yml
    $ /usr/bin/python2 /usr/bin/ansible-playbook -i /root/products/kubernetes-deploy/my_inventory/my_inventory.cfg /root/products/kubernetes-deploy/cluster.yml -b -v --private-key=~/.ssh/id_rsa >ds.log
    
    Deploy the Go language Development environment.

Running

Download a binary release of the CLI, or build it yourself by running:

$ go get -u -v github.com/heptio/sonobuoy
Deploy a Sonobuoy pod to your cluster with:

$ sonobuoy run
View actively running pods:

$ sonobuoy status 
To inspect the logs:

$ sonobuoy logs
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

$ sonobuoy retrieve .
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

mkdir ./results; tar xzf *.tar.gz -C ./results
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

sonobuoy delete

