## QFusion
QFusion is an enterprise-level DBaaS platform based on cloud native technologies which support for MySQL,SQL Server,Redis,Oracle,PostgreSQL and MongoDB database.It implements key components of database operator orchestration and provides self-healing and auto-scale database feature

## Reproduce Conformance Tests
###  pre-preparing
install [docker](https://www.docker.com/get-started)

install [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) 

install [helm](https://github.com/helm/helm/releases)

install [kubectl](https://kubernetes.io/docs/tasks/tools/)

### installation 

kind yaml prepare

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 31080
    hostPort: 31088 
    protocol: TCP
  extraMounts:
  - hostPath: /usr/share/zoneinfo/Asia/Shanghai 
    containerPath: /usr/share/zoneinfo/Asia/Shanghai
- role: worker
  extraMounts:
  - hostPath: /usr/share/zoneinfo/Asia/Shanghai
    containerPath: /usr/share/zoneinfo/Asia/Shanghai
```


using kind install enviroment

```
kind create cluster --name qf --image=registry.cn-hangzhou.aliyuncs.com/tomc/qfusion/kindnode:v1.18.15 --config=kind.yaml
```
make sure nodes Ready

```
kubectl get node
NAME               STATUS   ROLES    AGE   VERSION
qf-control-plane   Ready    master   17m   v1.18.15
qf-worker          Ready    <none>   17m   v1.18.15
```

add helm repo on localhost

```
helm repo add qfusion https://helm.woqutech.com:8043/qfusion

```

install QFusion

```
helm install qfusion qfusion/qfusion-installer

```
make sure the QFusion's pod running 

```
kubectl get pod
```



### Start Test
`sonobuoy run --mode=certified-conformance`

### Check Status
`sonobuoy status`

### Test Result
`outfile=$(sonobuoy retrieve) 
mkdir ./results; tar xzf $outfile -C ./results`
