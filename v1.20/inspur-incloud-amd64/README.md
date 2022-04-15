#Inspur ICKS
## Prepare

1. Prepare at least three node with an operation system.
2. Upload ICKS installation package to the master node on which you are running the deploy scripts.

## Installation

1. Planning your cluster , insert or modify the node information into file `tmp/inventory.ini` and insert node name to corresponding group.For example if you want a node named k8s1 to be the k8s master, you need insert k8s1 below "[kube-master]".
2. Execute the following commands 
```
# user means linux username
# password means the linux password
# localNodeIP means the ip address of the node where you execute the command 
$ bash setup.sh -u <user> -p <password>-i <localNodeIP> -m icks cluster
```
3. After all process complete, all the nodes will reach "Ready" status and pods will reach "Running" status.

## Run Conformance Test


1. Download a binary release of the sonobuoy CLI from https://github.com/heptio/sonobuoy/releases：
```
$ sonobuoy run --mode=certified-conformance
```

2. Get the results:
```
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results
```

3. Then grab `plugins/e2e/results/global/{e2e.log,junit_01.xml}` from results folder, add them to this PR.
