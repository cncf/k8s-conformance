Diamanti D10 cluster:

[diamanti@appserv91 ~]$ dctl cluster status
Name           	: demo-cluster
UUID           	: b728d8c0-f635-11e7-8049-a4bf01147eba
State          	: Created
Version        	: 1.2.1 (277)
Master         	: appserv92
Quorum State   	: Healthy
Virtual IP     	: 172.16.19.53
Storage VLAN   	: 456
Pod DNS Domain	: cluster.local

NAME                 NODE-STATUS   K8S-STATUS   MILLICORES   MEMORY       STORAGE    IOPS      VNICS     BANDWIDTH   STORAGE-CONTROLLERS   LABELS
                                                                                                                     TOTAL, REMOTE         
appserv91/(Quorum)   Good          Good         0/64000      0/540.82GB   0/3.06TB   0/500K    1/63      0/40G       0/64, 0/64            beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=appserv91
appserv92/(Master)   Good          Good         0/64000      0/540.82GB   0/3.06TB   0/500K    1/63      0/40G       0/64, 0/64            beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=appserv92
appserv93/(Quorum)   Good          Good         0/64000      0/540.82GB   0/3.06TB   0/500K    2/63      0/40G       0/64, 0/64            beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=appserv93

When the Cluster is ready you can run the conformance tests:

  `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`

  You can follow the steps descrbed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to get the test logs

