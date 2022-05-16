#Inspur AIStation
## Prepare

1. Prepare at least three node with an operation system.
2. Upload AIStation installation package to the master node on which you are running the deploy scripts.

## Installation

1. Planning your cluster , modify the cluster information into file `aistation/config/ais.cfg` and insert modify the cluster node name in `aistation/config/hosts`.For example if you want a cluster of one master and two works, your `hosts` file will look like:
```shell
#ais-master
xxx.xxx.xxx.xxx ais-master1

#ais-cpu-node
xxx.xxx.xxx.xxx ais-cpu-node1

#ais-gpu-node
xxx.xxx.xxx.xxx ais-gpu-node1
```
2. Execute the following commands 
```
# username means linux username, this user should have sudo permission
# password means the linux password
# ais-master1-IP means the ip address of the first master node of your cluster
# stepNo means which step do you want to run. For more detail please see the usage of the command
$ bash ais.sh $username $password $ais-master1-IP $stepNo
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