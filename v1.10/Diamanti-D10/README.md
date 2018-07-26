Diamanti D10 cluster:

[root@appserv9 diamanti]# dctl cluster status
Name           	: devtb6
UUID           	: d5cd715e-8ebc-11e8-8933-2c600c82ec72
State          	: Created
Version        	: 2.1.0 (0)
Master         	: appserv9
Etcd State     	: Healthy
Virtual IP     	: 172.16.19.23
Storage VLAN   	: 430
Pod DNS Domain	: cluster.local

NAME                      NODE-STATUS   K8S-STATUS   MILLICORES   MEMORY         STORAGE    IOPS      VNICS     BANDWIDTH   SCTRLS          LABELS
                                                                                                                            LOCAL, REMOTE
appserv10/(etcd)          Good          Good         0/32000      1GiB/64GiB     0/3.05TB   0/500K    2/63      0/40G       0/64, 0/64      beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,daemonset-color=green,kubernetes.io/hostname=appserv10,node=appserv10
appserv11/(etcd)          Good          Good         0/32000      1GiB/64GiB     0/3.05TB   0/500K    2/63      0/40G       0/64, 0/64      beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=appserv11,node=appserv11
appserv9/(master, etcd)   Good          Good         900/32000    1.7GiB/64GiB   0/3.05TB   0/500K    2/63      0/40G       0/64, 0/64      beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/e2e-f75917a5-8ec5-11e8-a1ca-0a58ac140003=42,kubernetes.io/hostname=appserv9,node=appserv9


When the Cluster is ready you can run the conformance tests:

  `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`

  You can follow the steps descrbed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to get the test logs

