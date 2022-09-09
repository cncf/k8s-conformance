# Inspur AIStation
## Prepare


1. Prepare at least two node with an operation system (Centos7.8 minimal installation). The worker node should have GPU device.
2. Configure static IP for all nodes
3. Upload AIStation installation package to the master node on which you are running the deploy scripts.

## Installation


1. Perform MD5 verification to verify the integrity of the installation package, then unzip it and generate a deploy-script directory.
2. Planning your cluster, modify the node information into file `inventory.ini`. You can reference the sample files `inventory.ini.single` (non-HA deployment example) and `inventory.ini.muti` (HA deployment example).
3. Modify the file: `inspur.yml`. You can reference the sample files `inventory.yml.single` (non-HA deployment example) and `inventory.yml.muti` (HA deployment example).
4. Execute the following commands 
```
# user means linux username
# password means the linux password
# local_iP means the ip address of the node where you execute the command 
# step_NO means the installation steps. You can choose one from below:
# - If you just want to get k8s clusters, set step_NO to 1 and 9 respectively and execute in order. 
# - If you want to install the complete aistation software, you should choose which you need from your installation manual, then set step_NO respectively and execute in order. 
$ bash -x install.sh [user] [password] [local_ip] [step_NO]
```
5. After all process complete, all the nodes will reach "Ready" status and pods will reach "Running" status.

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
