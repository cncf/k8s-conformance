## Run Conformance Test
Follow the conformance suite instructions to test it.

**Download sonobuoy binary release.**

```
URL: "https://github.com/vmware-tanzu/sonobuoy/releases"
```

**Let's decompress**

```
tar -xvf <sonobouy.version>.tar.gz
```

**Sonobouy test**

```
./sonobuoy run --mode=certified-conformance
```

**Check the progress of sonobouy (must end with fail 0)**

```
./sonobouy status
```

**Copy the output to the local directory when you're done**

```
outfile=$(./sonobuoy retrieve)
```

**Extract the contents**

```
mkdir ./results; tar xzf $outfile -C ./results
```

**Check the 2 files you need in the path below**

```
path=plugins/e2e/results/global/{e2e.log,junit_01.xml}
```


Install

```
$ git clone https://github.com/kubernetes-sigs/kubespray.git

$ cd kubespray

$ sudo yum -y install python3

$ sudo pip3 install -r requirements.txt

$ declare -a IPS=(${NODE1 IP} ${NODE2 IP} ${NODE3 IP})

$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

$ vi inventory/mycluster/hosts.yaml # edit hosts.yaml

$ ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
```
