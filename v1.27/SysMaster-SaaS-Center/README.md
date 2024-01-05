# SysMasterK8s 설치가이드
---
## 본 문서는 Sysmaster k8s 제품의 설치를 위해 작성된 가이드입니다.
## 본 문서의 저작권은 인프라닉스(주)에 있으며 인프라닉스(주)의 서면승인 없이는 어떠한 형식으로도 이 설명서의 일부 또는 전부를 무단으로 사용, 복사, 복제, 재편집, 재배포할 수 없습니다.
---

​
### 1. Nexus Repository 설치 

설치에 사용되는 Nexus의 버전은 3.37.3 입니다.

Nexus 의 특성상 기존의 저장소에 저장되어 있는 데이터를 같이 이동해야하기 때문에 다음의 조건을 확인해주시길 바랍니다.

- OS – ubuntu 18.04
- 사용 계정 – ubuntu(sudo 권한 필요)
- 사용 Home directory - /home/ubuntu/
- 기존에 Openjdk, tar, gzip 설치
- 설치 파일
 . nexus-3.37.3-02.tar.gz # 프로그램 디렉토리
 . nexus-3.37.3-02_sonatype.tar.gz # data 디렉토리

- SSL 사용시 인증서를 JKS 형태로 변환 (비밀번호 6 자리로 생성)

<br>

Nexus Repository 설치 작업을 진행 합니다. 

```
## 설치 파일 2 개를 /home/ubuntu/ 디렉토리에 이동합니다.
## 다음 명령어를 사용하여 압축을 해제합니다.

$ tar –zxvf nexus-3.37.3-02.tar.gz
$ tar –zxvf nexus-3.37.3-02_sonatype.tar.gz
```
다음과 같이 home 디렉토리에 2 개의 디렉토리가 생성됩니다.

<br>

앞에서 생성한 cert.jks를 keystore.jks 파일로 변경한 후 다음 경로에 복사합니다.

```
$ cd /home/ubuntu/cert
$ cp cert.jks keystore.jks

$ cp keystore.jks /home/ubuntu/nexus-3.37.3-02/etc/ssl
$ cp keystore.jks /home/ubuntu/sonatype-work/nexus3/etc/ssl
```

<br>

다음의 파일을 아래와 같이 수정합니다.

```
$ vi /home/ubuntu/sonatype-work/nexus3/etc/nexus.properties
```
> application-port= 8080 # 8080으로 설정되었는지 확인
> application-port-ssl= 8443 # 8443으로 설정되었는지 확인
> nexus-args= ${jetty.etc}/jetty-https.xml # 추가되어 있는지 확인
> ssl.etc=${karaf.data}/etc/ssl # 위치가 설정되었는지 확인

<br>

다음의 파일을 아래와 같이 수정합니다.

```
$ vi /home/ubuntu/nexus-3.37.3-02/etc/jetty/jetty-https.xml
```
> \<Set name="certAlias"\>JKS파일 생성시 사용한 alias \</Set> # 신규 추가 라인
> \<Set name="KeyStorePath"\>\<Property name="ssl.etc"/> 저장한 JKS파일명 \</Set>
> \<Set name="KeyStorePassword"\> Keystore 비밀번호 6 자리 이상 \</Set>
> \<Set name="KeyManagerPassword＂\>Keymanager 비밀번호 6 자리 이상 \</Set>
> \<Set name=“TrustStorePath”\><Property name=“ssl.etc”/>저장한 JKS파일명 \</Set>
> \<Set name=“TrustStorePassword”\>TrustStore 비밀번호 6 자리 이상 \</Set>

<br>

다음의 명령어로 Nexus repository 를 실행합니다.

```
$ cd ~/nexus-3.37.3-02/bin/
$ sudo ./nexus run & > /dev/null
```
다른 작업과 동시에 사용할 경우 문제가 없도록 백그라운드 (&)로 실행합니다.
정상적으로 실행된다면 다음의 log가 보입니다.

<br>

nexus가 정상가동 중인지 확인합니다.
아래와 같이 nexus 관련 java 프로세스가 돌고 있는지 확인
```
$ ps – ef | grep nexus
```

<br>


### 2. Harbor 설치
bm-inception node의 ubuntu 계정에서 실행
앞의 inception node 사전 준비를 실행하여 docker가 설치된 이후에 진행하고
다시 다른 노드 준비로 돌아간다.

<br>

Harbor Offline 패키지를 다운로드
```
$ cd download
$ wget http://nexus.sysmasterk8s.com/repository/downloads/harbor/harbor-offline-installer-v2.4.2.tgz
$ tar zxvf harbor-offline-installer-v2.4.2.tgz
$ mv harbor/ ~/
```

<br>

Docker-compose 설치
```
$ cd download
$ wget http://nexus.sysmasterk8s.com/repository/downloads/docker-compose/2.2.3/docker-compose-linux-x86_64
$ mv docker-compose-linux-x86_64 docker-compose
$ sudo mv docker-compose /usr/local/bin/
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
$ docker-compose -v
```

<br>

Harbor.yml.tmlp 를 Harbor.yml로 변경하고 내용을 수정합니다.
```
hostname: registry.sysmasterk8s.com
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 9080

  # https related config
  HTTPS:
    # https port for harbor, default is 443
    port: 9443
    # The path of cert and key files for nginx
    certificate: /home/ubuntu/cert/tls.crt
    private_key: /home/ubuntu/cert/tls.key

  harbor_admin_password: challenge77!!
```

<br>

Docker compose를 사용하여 Harbor를 설치합니다.
```
$ sudo ./install.sh --with-chartmuseum --with-trivy
```

<br>

모든 작업이 완료된 후 sudo docker ps 를 실행해서 컨테이너가 정상적으로 올라오는지 확인합니다.
```
$ sudo docker ps
```

<br>

모든 작업이 완료된 후 inception 서버에서 docker login을 해본다.
```
$ sudo docker login –u admin –p ‘challenge77!!’ registry.sysmasterk8s.com
```

<br>

### 3. Rancher 설치

<br>

image 업로드(**Harbor에 프로젝트 생성**)
Harbor UI에 접속하여 7 개의 프로젝트를 private로 생성합니다. (public 체크 안함)
```
base_image
platform_base_image
platform_component
platform_infra
rancher
weaveworks
platform_portal
```

<br>

image 업로드(**Harbor에 docker 로그인**)
```
$ sudo dockerlogin registry.sysmasterk8s.com -u admin -p 'challenge77!!'
$ cd ~/download/Docker_Base_Image
$ sudochmod+x rancher-load-images.sh
$ sudo./rancher-load-images.sh --image-list ./rancher-images.txt --registry registry.sysmasterk8s.com
```

<br>

Rancher Deploy


```
$ ./docker_rancher_start.sh
```

<br>

Rancher 비밀번호 확인

```
# admin 비밀번호조회 및 복사
$ sudodockerlogs <container 번호>2>&1 | grep ”Bootstrap Password:”
```
또는
```
$ ./docker_rancher_password.sh
```
브라우저 접속 후 비밀번호 변경

<br>

Rancher **비밀번호 변경**

#### 비밀번호 변경


Rancher **비밀번호 변경**

#### 도메인 확인 (7443 포트)


rancher **업데이트**


rancher update

### 만약 rancher 설치 이후에 rancher 이미지가 업데이트 되었을 경우 다음의 명령어를

### 통해 컨테이너의 업데이트가 가능하다.

### 1. 현재 실행되고 있는 containe의 ID를 확인

### $ sudo docker ps


rancher update

### 2. 실행되고 있는 컨테이너를 volume으로 생성한다.

### # docker create --volumes-from {container id} --name rancher-data {original image

### name}

### # image name은 현재 실행중인 컨테이너의 이미지를 넣는다.

### $ sudo docker create --volumes-from be 9 e828802ab --name rancher-data

### registry.sysmasterk8s.com/rancher/sysmaster:v0.10

### 3. 현재 실행되고 있는 컨테이너를 stop

### $ sudo docker stop be 9 e828802ab


rancher update

### 4. 신규 이미지를 harbor에 업로드


rancher update

### 4. 신규 이미지와 volume을 사용하여 새로운 컨테이너를 실행

### $ sudo docker run -d --volumes-from rancher-data --restart=unless-stopped -p

### 7080 : 80 - p 7443: 443 - v /home/ubuntu/cert/cert.pem:/etc/rancher/ssl/cert.pem -v

### /home/ubuntu/cert/key.pem:/etc/rancher/ssl/key.pem -v

### /home/ubuntu/cert/cacerts.pem:/etc/rancher/ssl/cacerts.pem --dns 183.111.127.218

### --privileged registry.sysmasterk8s.com/rancher/sysmaster:v0.11

### 5. 정상적으로 rancher가 실행되는지 확인한다.


Cluster **생성**


rancher cluster **생성**

```
Rancher의 클러스터 메뉴에서 add cluster 버튼을 클릭합니다.
```

rancher cluster **생성**

```
Add cluster에서 existing nodes를 클릭합니다.
```

rancher cluster **생성**

#### 클러스터 명을 입력합니다.


rancher cluster **생성**

#### 클러스터 옵션을 선택합니다.

```
Kubernetes version –v1.20.15.rancher1- 3
```

rancher cluster **생성**

#### 클러스터 옵션을 선택합니다.

```
Private registry –앞에서 생성한 harbo의 주소와 포트& Harbor 계정 입력
```
```
Next 클릭
```

rancher cluster **생성**

```
Cluster customize node run command 에서 노드의 역할에 맞게
선택한 후 아래의 command를 복사하여 cluster node에서 명령어를 입력합니다.
```

rancher cluster **생성**

**# Bm-control node 에서 실행**

```
etcd& control plane & Worker 선택
```
```
$ sshubuntu@bm-control
```
```
$sudodockerlogin registry.sysmasterk8s.com –u admin –p ‘challenge77!!’
```

rancher cluster **생성**

**# Bm-control node 에서 실행**

```
$ sudodockerrun ~~~~~~~~~~~~~~~~~~ --etcd--controlplane--worker
```
### # 복사한 run command 를 입력한다.

### ### rancher의 도메인에 7443 포트를 붙여야 정상적으로 사용이 가능하다.


rancher cluster **생성**

**# Bm-cluster-1 ~ 5 node 에서 실행**

```
Worker 만 선택
```
```
$ sshubuntu@bm-cluster-1 # bm-cluster- 1 번부터 5 번까지 한번씩 들어가서 실행
```
```
$ sudodockerlogin registry.sysmasterk8s.com –u admin –p ‘challenge77!!’
```

rancher cluster **생성**

**# Bm-cluster-1 ~ 5 node 에서 실행**

```
$ sudodockerrun ~~~~~~~~~~~~~~~~~~ --worker
```
### # 복사한 run command 를 입력한다.

### ### rancher의 도메인에 7443 포트를 붙여야 정상적으로 사용이 가능하다.

### ### 네트워크 환경과 rancher containe의 사양에 따라 rancher 웹페이지가 불안정하

### 게 될수 있다. 여러 개의 node를 추가할 때는 간격을 두고 실행하자.


rancher cluster **생성**

```
## Command 입력 결과
```

rancher cluster **생성**

```
Cluster customize node run command
```
```
## Cluster 생성 결과
```

coredns

config-map **수정**


coredns config-map **수정**

```
## config-map 수정
```
```
서비스 사이의 연결을 위해 앞서 설치한 클러스터의 config-map을 수정한다.
```
```
cluster 의 system 프로젝트를 선택한다.
```

coredns config-map **수정**

```
## config-map 수정
```
```
프로젝트 – 리소스 – 컨피그 맵을 선택한다.
```

coredns config-map **수정**

```
## config-map 수정
```
```
coredns의 오른쪽 EDIT 메뉴를 선택한다.
```

coredns config-map **수정**

```
## config-map 수정
```
```
Value 내부의 forward 의 내용을 다음과 같이 수정한다.
```
```
“/etc/resolve.conf“ - > bm-inception (bind9이 설치된 서버) 의 ip
```
```
forward. “/etc/resolve.conf“ - > forward. 183.111.127.218
```

coredns config-map **수정**

```
## coredns재배포
```
```
system 프로젝트 – 리소스 – 워크로드 선택
```

coredns config-map **수정**

```
## coredns재배포
```
```
kube-system 네임스페이스의 coredns를 선택하고 내부의 pod를 모두 삭제하면 자동으로 재배포 된다.
```

Ceph **연동** - rbd


Kube config

### bm-Inception node ansible 계정에서 kube config 입력

### $ su – ansible

### $ cd ~

### $ mkdir .kube

### $ vi .kube/config (Rancher UI에서 cluster - kubeconfig 복사 후 붙여넣기)


Ceph-csi **복사**

### bm-Inception node 에 Ceph-csi 복사

```
$ cd ~
```
```
$ wgethttps://nexus.sysmasterk8s.com/repository/downloads/ceph-csi/ceph-csi_infranics.tar
```
```
$ tar xvfceph-csi_infranics..tar
```
```
$ cd ceph-csi
```
```
$ gitcheckout v3.3.1
```
```
$ cd charts/ceph-csi-rbd
```
#### # 아래 명령어를 실행

```
$ sed-i's/storage.k8s.io\/betav1/storage.k8s.io\/v1beta1/g' templates/csidriver-crd.yaml;
```

Ceph-csi-rbd-

values.yaml

### bm-ceph-cluster-1 node에서 cephid 확인

```
$ sudocephstatus
```

Ceph-csi-rbd-

values.yaml

### bm-Inception node에서 ceph-csi-rbd-values.yaml수정

### # ceph-csi/charts/ceph-csi-rbd 에서 실행

```
$ vi ceph-csi-rbd-values.yaml
```
```
csiConfig:
```
- clusterID: " 7b7787fe-39a7-4e5d-b802-77b3d6086ae3"
    monitors:
       - "10.20.1.216:6789“
       - "10.20.1.184:6789“
       - “10.20.1.151:6789"

```
provisioner:
name: provisioner
replicaCount: 1
EOF
```
### ※ clusterID와 monitors의 ip를 수정


Helm install

### bm-Inception node에서 helm install

```
$ helm install --namespace ceph-csi-rbdceph-csi-rbd--values ceph-csi-rbd-values.yaml./ --create-
namespace;
```
```
$ kubectlrollout status deployment ceph-csi-rbd-provisioner-n ceph-csi-rbd
```

Helm install **확인**

```
$ helm status ceph-csi-rbd-n ceph-csi-rbd
```

Ceph **에서 정보 확인**

### Bm-ceph-cluster-1 node 에 Ceph 정보 확인

```
$ sudoecho "admin" | tr -d '\n' | base64;
결과값 : YWRtaW4=
```
```
$ sudocephauthget-key client.admin| base64
```
```
결과값 : QVFEaGNhMWhBZFlZS3hBQTVVMzg3cTlvTll4NlYycXk2TS9xbGc9PQ==
```

ceph-admin-secret.yaml

### Inception node ansible 계정에서 ceph-admin-secret.yaml 수정

```
$ cat > ceph-admin-secret.yaml<< EOF
apiVersion: v1
```
```
kind: Secret
metadata:
name: ceph-admin
namespace: default
type: kubernetes.io/rbd
```
```
data:
userID: YWRtaW4=
userKey: QVFEaGNhMWhBZFlZS3hBQTVVMzg3cTlvTll4NlYycXk2TS9xbGc9PQ==
EOF
```
```
$ kubectlapply -f ceph-admin-secret.yaml
```

Storage class **생성**

### bm-inception node 에 storage class yml 수정

```
$ cat > ceph-rbd-sc.yaml<<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
name: ceph-rbd-sc
annotations:
storageclass.kubernetes.io/is-default-class: "true"
provisioner: rbd.csi.ceph.com
parameters:
clusterID: 7b7787fe-39a7-4e5d-b802-77b3d6086ae3
pool: rbd
imageFeatures: layering
csi.storage.k8s.io/provisioner-secret-name: ceph-admin
csi.storage.k8s.io/provisioner-secret-namespace: default
csi.storage.k8s.io/controller-expand-secret-name: ceph-admin
csi.storage.k8s.io/controller-expand-secret-namespace: default
csi.storage.k8s.io/node-stage-secret-name: ceph-admin
csi.storage.k8s.io/node-stage-secret-namespace: default
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
```
- discard
EOF
$ kubectlapply -f ceph-rbd-sc.yaml;

```
※clusterID와 pool은 CephVM에서 확인
※pool은 Block Storage의 pool 입력
```

PVC **생성 및 테스트**

### Inception node 에서 PVC 생성 및 POD 생성 테스트

```
$ cat <<EOF > pv-pod.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
name: ceph-rbd-sc-pvc
spec:
accessModes:
```
- ReadWriteOnce
resources:
requests:
storage: 2Gi
storageClassName: ceph-rbd-sc
---
apiVersion: v1
kind: Pod
metadata:
name: ceph-rbd-pod-pvc-sc
spec:
containers:
- name: ceph-rbd-pod-pvc-sc
image: busybox
command: ["sleep", "infinity"]
volumeMounts:
- mountPath: /mnt/ceph_rbd
name: volume
volumes:
- name: volume
persistentVolumeClaim:
claimName: ceph-rbd-sc-pvc
EOF

```
$ kubectlapply -f pv-pod.yaml;
```

**생성 확인**

### Inception node 에서 pvc 생성 확인

### $ kubectl get pvc

## 정상 (^) 확인

### bm-ceph-cluster-1 node 에서 rbd 확인

### $ sudorbd ls -p rbd

### ## volume 확인


Ceph **연동** -

filesystem


Ceph-csi-fs-values.yaml

### bm-ceph-cluster-1 node에서 cephid 확인

```
$ sudocephstatus
```

Ceph-csi-fs-values.yaml

### bm-Inception node에서 ceph-csi-fs-values.yaml수정

### # ceph-csi/charts/ceph-csi-cephfs에서 실행

```
$ vi ceph-csi-fs-values.yaml
------
csiConfig:
```
- clusterID: " 7b7787fe-39a7-4e5d-b802-77b3d6086ae3"
    monitors:
       - "10.20.1.216:6789“
       - "10.20.1.184:6789“
       - “10.20.1.151:6789"

```
provisioner:
name: provisioner
replicaCount: 1
```
### ------

### ※ clusterID와 monitors의 ip를 수정


Helm install

### bm-Inception node에서 helm install

```
$helm install ceph-csi-fs --namespace ceph-csi-fs --values ceph-csi-fs-values.yaml. --create-namespace
```
```
$ kubectlrollout status deployment ceph-csi-fs-ceph-csi-cephfs-provisioner-n ceph-csi-fs
```

Helm install **확인**

```
$ helm status ceph-csi-fs -n ceph-csi-fs
```

Rancher **에서** secret **생성**

### Rancher에서 사용하려는 프로젝트에 접속

### # secret 생성 버튼을 클릭하여 다음 정보를 입력

### # adminID 는 admin

### # adminKey는 bm-ceph-cluster-1 node에서 다음 명령어로 나온 값

### $ sudo ceph auth get-key client.admin


Rancher **에서** secret **생성**

### Rancher에서 사용하려는 프로젝트에 접속

### # secret 생성 버튼을 클릭하여 다음 정보를 입력


ceph-csi-fs-sc.yaml

### Inception node ansible 계정에서 ceph-csi-fs-sc.yaml 수정

```
$ vi ceph-csi-fs-sc.yaml
------
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
name: ceph-fs-sc
allowVolumeExpansion: true
provisioner: cephfs.csi.ceph.com
parameters:
clusterID: 63de8f35-ae0f-49a7-a01c-b8d5d68a4573 # ceph노드에서 확인한 cluster id
fsName: kubernetes # fsname은 ceph 에서 생성한 filesystem 이름
csi.storage.k8s.io/controller-expand-secret-name: ceph-csi-fs-secret # 앞에 rancher에서 생성한 secret 이름
csi.storage.k8s.io/controller-expand-secret-namespace: default
csi.storage.k8s.io/provisioner-secret-name: ceph-csi-fs-secret
csi.storage.k8s.io/provisioner-secret-namespace: default
csi.storage.k8s.io/node-stage-secret-name: ceph-csi-fs-secret
csi.storage.k8s.io/node-stage-secret-namespace: default
reclaimPolicy: Delete
mountOptions:
```
- debug

```
$ kubectlapply -f ceph-csi-fs-sc.yaml
```

PVC **생성 및 테스트**

### Inception node 에서 PVC 테스트

```
$ vi pv-pod.yaml
------
```
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
name: ceph-fs-sc-pvc
spec:
accessModes:
```
- ReadWriteMany
resources:
requests:
storage: 2Gi
storageClassName: ceph-fs-sc

#### ------

```
$ kubectlapply -f pv-pod.yaml;
```

**생성 확인**

### Inception node 에서 pvc 생성 확인

### $ kubectl get pvc


minio **설치**


Minio **배포**

### bm-inception node 에서 minio 배포

```
Ansible계정으로 Neuxs에서 platform_minio.tar 를 다운로드 받는다.
```
```
$ tar –xvfplaform_minio.tar
$ cd platform_minio
```
```
# ingress 오류 때문에 아래의 명령어를 실행해준다.
$ kubectldelete validatingwebhookconfigurationingress-nginx-admission
```
```
$ vi deploy_minio.sh
```

Minio **배포**

### bm-inception node 에서 minio 배포

#### ###

```
helm install sysk8s-minio --namespace default. -f values.yaml\
--set persistence.storageClass=ceph-rbd-sc\
--set persistence.size=100Gi \
--set ingress.enabled=true \
```
```
--set ingress.hosts[0]=minio.sysmasterk8s.com \
--set resources.requests.memory=1Gi \
--set accessKey=admin \
--set image.repository=registry.sysmasterk8s.com/base_image/minio\
--set resources.requests.memory=1Gi \
```
```
--set resources.requests.cpu=0.05 \
--set resources.limits.memory=1Gi \
--set resources.limits.cpu=0.1 \
--set secretKey='challenge77!!' | kubectlapply --namespace default -f -
###
```
```
$ ./deploy_minio.sh
```

Minio **배포**

### Inception node 에서 minio 배포

```
# 배포시 다음의 error가 발생하지만 정상 배포되었습니다.
```
```
error: error parsing STDIN: error converting YAML to JSON: yaml: line 11: could not find expected ':'
```

Minio **배포**

### Rancher 에서 minio 배포 확인


Minio **설정**

### minio UI에 접속하여 Bucket 생성

```
id : admin
pw : challenge77!!
```

Minio **설정**

### minio UI에 접속하여 Bucket 생성

```
bucket 명 : portal 입력후 enter
```

GITlab **설치**


certificate **설정**

### Resources > Secret > Certificates 메뉴에서 Add Certificate를 선택하여 인증서를 등록

### 합니다.

### . Name : sysk8s-certificate

### Private Key -> /home/ubuntu/cert/tls.key파일 내용 을 입력

### Certificate -> /home/ubuntu/cert/tls.crt 파일 내용 을 입력


Haproxy **설정**

### Gitlb의 haproxy를 다음과 같이 설정합니다..

### Resources > Secret > Certificates 메뉴에서 Add Certificate를 선택하여 인증서를 등록

### 합니다.

### . Name : sysk8s-certificate


Haproxy **설정**

### - cluster -> 프로젝트 / 네임스페이스 - > default에 아래의 namespace를 추가

### . vault

### . gitlab

### . concourse

### . jenkins

### . configserver

### . keycloak

### . mkdocs

### . portal-dev


Gitlab **배포**

### 다음장의 명령어를 실행하기 전에 다음 파일을 실행해야한다.

### $ cd /home/ansible/platform_devops

$. set_env.sh

$ ./setValue.sh

네임스페이스를 gitlab으로 선언한다.

$ export NAMESPACE=gitlab


Gitlab **배포**

### Helm을 사용하여 gitlab을 배포합니다.

$ cd ~/platform_devops/deploy/helm/gitlab

```
$ helm install sysk8s --namespace ${NAMESPACE}. -f values.yaml\
--set externalUrl=https://${GITLAB_HOST} \
--set gitlabRootPassword=${ADMIN_PASSWORD} \
--set ingress.enabled=true \
--set ingress.url=${GITLAB_HOST} \
--set serviceType=ClusterIP\
--set ingress.https.enabled=true \
--set updateStrategy.type=Recreate \
--set sshNodePort=30022 \
--set persistence.gitlabCephfs.storageClass=ceph-fs-sc\
--set persistence.gitlabEtc.storageClass=ceph-rbd-sc\
--set persistence.gitlabData.storageClass=ceph-rbd-sc\
--set image=${DOCKER_REGISTRY}/platform_component/gitlab/gitlab-ce:12.8.6-ce.0 \
--set cephfs.mountPath=/cephfs-gitlab\
--set imagePullSecret=regcred| kubectlapply --namespace ${NAMESPACE} -f -
```
```
또는 다음 명령어를 실행
$./deploy_gitlab.sh
```

Gitlab **인증서 설정**

### ## Gitlab인증서 설정

### ## 컨테이너가 unavailable 상태일때 다음의 명령어를 실행해준다.

### $ kubectl get secret sysk8s-certificate -n ${NAMESPACE} -o jsonpath='{.data.tls\.crt}'

### | base64 -d > ~/${GITLAB_HOST}.crt

### $ kubectl get secrets sysk8s-certificate -n ${NAMESPACE} -o jsonpath='{.data.tls\.key}'

### | base64 -d > ~/${GITLAB_HOST}.key; POD=$(kubectl-n ${NAMESPACE} get pod -l

### app=sysk8s-gitlab-ce -o jsonpath="{.items[0].metadata.name}")

### $ kubectl -n ${NAMESPACE} exec -ti ${POD} -- mkdir-p /etc/gitlab/ssl

### $ kubectl -n ${NAMESPACE} cp~/${GITLAB_HOST}.crt ${POD}:/etc/gitlab/ssl

### $ kubectl -n ${NAMESPACE} cp~/${GITLAB_HOST}.key ${POD}:/etc/gitlab/ssl


Gitlab **인증서 설정**

### 만약 앞의 명령어를 실행하지 않을 경우 gitlab 컨테이너에서

### 다음의 error가 발생한다.


Gitlab **배포 확인**


Gitlab **배포**

### ## gitlab mount

### ## 만약 mount를 안하고 실행했을경우 마운트해준다.

### ceph-fs pvc를 다음과 같이 마운트 시킨 뒤 pod를 redeploy 해준다.


Haproxy **설정**

### Haproxy vm에서 다음과 같이 설정합니다..

### 1. /etc/haproxy/haproxy.cfg파일을 수정합니다.

### . ① Gitlab에 접속할 도메인을 설정합니다.

### . ② Gitlab이 설치되어 있는 worker-node IP를 입력합니다.

### 2. Haproxy서비스를 재시작 합니다..

### $ systemctlrestart haproxy


Gitlab **확인**

### 브라우저에서에서 정상 설치를 확인합니다.

### 계정 : root / challenge77!!


Gitlab **사용자 추가**

### 사용자 추가 (create user -> devops, devops, devops@test.com)


Gitlab **사용자 추가**

### 사용자 추가

### 1.① 좌측 메뉴의 Users를 클릭한다.

### 2.② 추가한 devops계정의 우측 edit 버튼을 클릭한다.

### 3.③Devops계정의 비밀번호 설정 후 ‘save change’ 버튼을 클릭하여 저장한다.


Gitlab **사용자 추가**

### 새 계정으로 로그인

### 1.관리자 계정에서 로그아웃 후 devops계정으로 로그인한다.

### 2.비밀번호 변경화면이 출력된다.

### 3.동일한 비밀번호로 입력


ranchertoken **생성**


rancher token **생성**

### rancher token 생성

### ranche에서 admin 계정의 API & KEY 메뉴를 선택한다.


rancher token **생성**

### rancher token 생성

### ADD key를 선택하고 descriptio에 platform이라고 입력한뒤

### 기간은 never,

### Scope는 no scope를 선택하고 create를 한다.


rancher token **생성**

### rancher token 생성

### 아래 화면과 같이 나오면 token이 생성된 것을 확인할 수 있다.

### 아래의 내용은 복사하여 text 파일에 저장해놓는다.


platform_config

**설정**


platform-config **수정**

### ## Inception 서버에서 /home/ansible/platform_devops/vars/commonlib.groovy

### 의 도메인 수정

### ## 도메인이 설정 안되면 portal 배포시 오류가 발생

### $ vi /home/ansible/platform_devops/vars/commonlib.groovy


platform-config **수정**

### ## Inception 서버에서 Prometheus Collector yml 수정

### $ sudo su – ansible

### $ sudo cp /home/ubuntu/download/platform_configs.tar.gz ~/

### $ tar zxvf platform_configs.tar.gz

### $ cd /home/ansible/platform_configs/configs/portal

### $ vi PrometheusCollector.yml


platform-config **수정**

### ## Inception 서버에서 Prometheus Collector yml 수정

### 1. 첫번째 네모에는 portal DB의 정보를 입력 (추후 DB 생성이후 변경)

### 2. 두번째 네모에는 rancher.sysmasterk8s.com: 7443 과

### 앞에서 text 파일에 저장한 Bearer Token을 입력한다.

### 3. 세번째 네모에는 rancher.sysmasterk8s.com: 7443 을 입력한다.


platform-config **수정**


platform-config **수정**

### ## Inception 서버에서 기타 정보 수정

### $ cd/home/ansible/platform_devops/deploy/config/common/portal/

### $ vi common.yml.erb (Portal DB 접속정보 수정)


platform-config **수정**

### ## Inception 서버에서 기타 정보 수정

### $ cd /home/ansible/platform_devops/deploy/config/common

### $ vi profiles.xml.erb

### (Nexus 정보 수정)


platform-config **수정**

### ## Inception 서버에서 기타 정보 수정

### $ cd /home/ansible/platform_devops/deploy/jenkins/config/

### $ vi build-config.json

### (jenkins에서 이미지 build할 때 필요한 서비스의 URL 주소 수정)


platform-config **수정**

### ## Inception 서버에서 기타 정보 수정

### $ cd /home/ansible/platform_devops/deploy/jenkins/config/

### $ vi deploy-config.json

### (jenkins에서 배포할 때 필요한 서비스의 URL 주소 수정)


ssh pub key **입력**

### ssh pub key를 gitlab에 입력

### ansible계정의 /home/ansible/.ssh/id_rsa.pub 파일의 내용을 복사하여 gitlab에 입력

### Profile > SSH Keys > Key에 넣어준다.


ssh pub key **입력**

### ssh pub key를 gitlab에 입력

### ansible계정의 /home/ansible/.ssh/id_rsa.pub 파일의 내용을 복사하여 gitlab에 입력

### Profile > SSH Keys > Key에 넣어준다.


ssh pub key **입력**

### ssh pub key를 gitlab에 입력

### ansible계정의 /home/ansible/.ssh/id_rsa.pub 파일의 내용을 복사하여 gitlab에 입력

### Profile > SSH Keys > Key에 넣어준다.


gitlab **소스코드**

**업로드**


gitlab **프로젝트 생성**

### # gitlab에서 업로드할 프로젝트를 생성한다.

### platform_devops, platform_portal, platform_configs, platform_docs


gitlab **소스코드 업로드**

### # inception에서 gitlab에 생성된 프로젝트에 소스코드를 업로드한다.

### # git을 사용하여 업로드

### # inception의 ansible 계정에서 업로드

### $ su – ansible

### # platform_ configs, docs, portal, devops 디렉토리가 존재하는지 확인

### # 만약 없다면 /home/ubuntu/download 디렉토리에서 복사해온다.

### $ ls –al

### $ cd platform_configs

### # 기존에 존재하던 .git디렉토리를 삭제

### $ rm –rf .git


gitlab **소스코드 업로드**

### # git 로그인

### $ git config --global user.name "devops"

### $ git config --global user.email "devops@test.com"

### # git을 사용하여 파일을 업로드

### $ git init

### $ git remote add origin https://gitlab.sysmasterk8s.com/devops/platform_portal.git

### $ git add.

### $ git commit -m "Initial commit"

### $ git push -u origin master


gitlab **소스코드 업로드**

### # 다른 디렉토리 3 개도 동일하게 gitlab에 파일을 업로드한다.


gitlab **소스코드 태깅**

### # gitlab에 업로드 된 소스코드에 태그를 붙인다.


gitlab **소스코드 태깅**

### # gitlab에 업로드 된 소스코드에 태그를 붙인다.

### platform_portal 소스의 ‘New Tag’ 버튼을 클릭하여 태그를 추가한다.

### # v 뒤에 * 자리에 버전 숫자를 넣는다.

### # 예제) adminapi-v0.01

### . sysMasterK8sAdminApi : adminapi-v*

### . sysMasterK8sAdminApp : adminapp-v*

### . sysMasterK8sUserApi : userapi-v*

### . sysMasterK8sUserApp : userapp-v*

### . sysMasterK8sMonitoringApi : monitoringapi-v*

### . sysMasterK8sMonitoringApp : monitoringapp-v*


**포탈** DB **설치**


**포탈** DB

```
## bm-inception vm에 MariaDB설치
```
1. DB를 설치할 inception에 접속 한다.
2. MariaDBServer를 설치한다.
sudoapt-get install software-properties-common

```
wget-q -O-‘http://localhost:8080/repository/downloads/mariadb/mariadb_release_signing_key.asc’ | sudo
apt-key add -
```
```
sudoadd-apt-repository ‘deb http://localhost:8080/repository/mariadb-apt bionic main’
```
```
sudoapt update
```
```
sudoapt install mariadb-server
```

**포탈** DB

```
## MariaDB외부접근 허용 설정
```
```
1./etc/mysql/mariadb.conf.d/50-server.cnf 파일의 내용중에 bind-address 항목을 주석처리 한다.
```
```
2.MariaDB서비스를 재시작 한다.
service mysqlrestart
```

**포탈** DB

```
## MariaDBRoot 계정 초기 비밀번호 설정
```
```
1.‘sudomysql_secure_installation‘ 명령어를 통하여 Root 계정의 초기 비밀번호를 설정한다.
```

**포탈** DB

```
## MariaDB데이터 Import & 권한설정
```
1. MysqlImport한다

```
$ mysql–u root –p < all-databases.sql
```
2. Mysql접속 후 데이터베이스 확인

```
$ mysql–u root –p
Enter password: (앞에서 생성한 비밀번호)
```
```
# 다음 명령어를 치면 database가 생성되어 있는 것을 확인할 수 있다.
$ show databases;
```
3. 다음의 명령어로 root 계정을 원격접속할 수 있도록 권한을 부여한다.

```
$GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Challenge77!!';
```
#### # 반드시 다음 명령어를 사용해야 저장이 된다.

```
$flush privileges;
```

**포탈** DB

```
## MariaDB데이터 data Import
## 초기 데이터를 입력해줘야 portal 등에서 데이터가 정상적으로 출력됩니다.
```
```
$ mysql–u root –p < K8S_ADMIN_INSERT.sql
```
2. Mysql접속 후 데이터베이스 확인


**포탈** DB


Vault **설치**


Vault

### ## Inception 서버 ansible계정으로 Consul 서비스 설치

### $ export NAMESPACE=vault

### $ cd /home/ansible/platform_devops/deploy/helm/consul

### $ helm install consul --namespace ${NAMESPACE}. -f values.yaml\

### --set global.name=consul \

### --set dns.enabled=false \

### --set server.storageClass=ceph-rbd-sc\

### --set server.storage=1Gi \

### --set tests.enabled=false \

### --set global.image=${DOCKER_REGISTRY}/platform_component/consul/consul:1.11.1

### | kubectl apply --namespace ${NAMESPACE} -f -

### 또는 deploy_consul.sh 파일을 실행


Vault

### # 설치 결과 - 2 가지의 pod가 생성됨


Vault

```
## Inception 서버 ansible계정으로Tra n s i t _ Va u l t 서비스 설치
$ export NAMESPACE=vault
```
$ cd /home/ansible/platform_devops/deploy/helm/vault

```
$ helm install transit-vault --namespace ${NAMESPACE}. -f values.yaml\
--set server.standalone.enabled=true \
--set server.service.type=ClusterIP\
--set server.dataStorage.storageClass=ceph-rbd-sc\
--set server.dataStorage.size=1Gi \
--set server.postStart="{/bin/sh,-c,while[! -f /vault/data/transit-vault-setup.sh ] || [! -f
/vault/data/transit-vault-unseal.sh ]; do sleep 60; echo waiting a setup and unseal shell script;
done; if [! -f /vault/data/vault-key.txt ];then sh/vault/data/transit-vault-setup.sh; else sh
/vault/data/transit-vault-unseal.sh; fi}" \
--set injector.image.repository=${DOCKER_REGISTRY}/platform_component/vault/vault-k8s \
--set server.image.repository=${DOCKER_REGISTRY}/platform_component/vault/vault | kubectl
apply --namespace ${NAMESPACE} -f –
```
또는 deploy_vault.sh 파일을 실행


Vault


Vault

### # 설치 결과 - 2 가지의 pod가 생성되는 것을 확인하고 다음 페이지로 진행


Vault

### ①

### ①

```
>> ①helm 실행 후 Pod 생성 직후에 아래 스크립트(16개)를 실행할것!!
(늦게 실행하면 정상적으로 스크립트가 동작하지 않음)
>> ①에러가 난다면 계속 반복하여 에러가 출력 안될때까지 실행한다..
```

Vault

1.

$ kubectlcpscript/transit-vault-setup.sh transit-vault-0:/vault/data -n ${NAMESPACE}

2.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --sed-i-e "s/\r//g" /vault/data/transit-
vault-setup.sh
```
3.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --chmod+x /vault/data/transit-vault-
setup.sh
```
4.

$ kubectlcpscript/transit-vault-unseal.sh transit-vault-0:/vault/data -n ${NAMESPACE}

5.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --sed-i-e "s/\r//g" /vault/data/transit-
vault-unseal.sh
```

Vault

6.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --chmod+x /vault/data/transit-vault-
unseal.sh
```
7.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --cat /vault/data/vault-key.txt > ~/transit-
vault-info.txt
```
8.

```
$ kubectlcreate secret generic transit-vault-info --from-file=transit-vault-
info=/home/ansible/transit-vault-info.txt --dry-run -o yaml| kubectlapply -n ${NAMESPACE} -f
```
-


Vault

9.

$ kubectlcpscript/transit-vault-enable.sh transit-vault-0:/vault/data -n ${NAMESPACE}

10.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --sed-i-e "s/\r//g" /vault/data/transit-
vault-enable.sh
```
11.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --chmod+x /vault/data/transit-vault-
enable.sh
```

Vault

12.

$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --sh/vault/data/transit-vault-enable.sh

13.

```
$ kubectlexec -ti-n ${NAMESPACE} transit-vault- 0 --vault kvget -field=value
secret/dops/vault/transit-token > ~/transit-token.txt
```
14.

```
$ kubectlcreate secret generic transit-token --from-file=transit-token=/home/ansible/transit-
token.txt --dry-run -o yaml| kubectlapply -n ${NAMESPACE} -f -
```
15.

```
$ kubectlcreate configmapconfig-autounseal--from-file ./script/config-autounseal.hcl--dry-
run -o yaml| kubectlapply -n ${NAMESPACE} -f -
```
16.

```
$ ENV_VAULT_TOKEN=`kubectlget secret transit-token -n ${NAMESPACE} -o jsonpath--template
'{.data.transit-token}' | base64 -d`
```

Vault


Vault

**## Vault ConfigMap 정보 수정**

1.echo $ENV_VAULT_TOKEN 명령어를 실행하고 해당 값을 복사한다.


Vault

```
## Vault ConfigMap 정보 수정
1.K8s Rancher에 접속한다.
2.vault네임스페이스를 선택한다.
3.Resources > Configmap메뉴를 선택한다.
4.config-authunseal항목 선택 후 token 값을 업데이트 한다.
방금 전 복사한 값을 입력한다.
```

Vault

```
## Service Vault 설치
```
```
$ helm install vault --namespace ${NAMESPACE}. -f values.yaml\
--set server.ha.enabled=true \
--set server.service.type=ClusterIP\
--set ui.enabled=true \
--set server.ingress.enabled=true \
--set server.ingress.hosts[0].host=vault.${BASE_DOMAIN} \
--set server.extraEnvironmentVars.VAULT_TOKEN=s.fWrIBP5POaZ5Gu8r6gaylN9g \
--set server.extraArgs='-config=/vault/config-autounseal/config-autounseal.hcl' \
--set server.volumes[0].name=autounseal,server.volumes[0].configMap.name=config-autounseal\
--set server.volumeMounts[0].mountPath=/vault/config-autounseal,server.volumeMounts[0].name=autounseal\
--set server.cephStorage.enabled=true \
--set server.cephStorage.storageClass=ceph-fs-sc\
--set cephfs.mountPath=/cephfs-vault \
--set injector.image.repository=${DOCKER_REGISTRY}/platform_component/vault/vault-k8s \
--set server.image.repository=${DOCKER_REGISTRY}/platform_component/vault/vault | kubectlapply --namespace
${NAMESPACE} -f -
```
```
또는 deploy_service.vault.sh 파일을 실행
```

Vault


Vault

```
## Service Vault 설치
```
```
service vault를 설치후 아래의 명령어를 실행하면
/home/ansible/service-vault-info.txt 파일이 생성된다.
```
```
해당 파일을 확인하면 내부에 token 값을 확인한다.
```
```
$ kubectlexec -i-n ${NAMESPACE} vault- 0 --vault operator init-recovery-shares=1 -recovery-threshold=1 > ~/service-vault-
info.txt
```

Vault

```
## ~/service-vault-info.txt 파일에 있는 Initial Root Token 정보를
~/home/ubuntu/platform_devops/set_env.sh 파일안에 VAULT_TOKEN 항목에 변경한다.
```

Vault haproxy **업데이트**

```
## Haproxy설정
```
1. Haproxy서버에 접속한다.
2. /etc/haproxy/haproxy.cfg파일을 수정한다.
. ①Vault에 접속할 도메인을 설정한다.
. ②Vault가 설치되어 있는 worker-node IP를
    입력한다.
3. Haproxy서비스를 재시작 한다.
systemctlrestart haproxy

### ②

### ①


Vault **로그인**

```
## Vault 로그인
```
1. Vault에 접속한다.
2. Inception 서버의 /home/ansible/service-vault-info.txt 파일의 Root Token 값을 이용하여 Vault에 로그인 한다.


Vault secret **엔진 생성**

```
## Secret Engine 생성 (1/2)
```
1. Vault에 접속한다.
2. ①Enable new engine 버튼을 클릭한다.
3. ②KV 항목을 선택하고 ‘Next’를 클릭한다.

### ①

### ②


Vault secret **엔진 생성**

```
## Secret Engine 생성 (2/2)
```
1. Path 항목을 입력 후 ‘Enable Engine’ 버튼을 클릭하여 Secret Engine을 생성한다.


Vault secret **등록**

```
## Secret 등록
```
1. 생성한 Secret Engine 선택 후 'Create secret’ 버튼을 클릭한다.


Vault secret **등록**

```
## Secret 등록
```
```
필요한 항목을 입력 후 ‘save’ 버튼을 클릭하여 secret을 저장한다.
```
```
# 이와 동일한 방식으로 다음 페이지의 19 개의 초기 데이터 값의 내용을 모두 입력한다.
```

Vault **초기데이터 등록**

```
## Vault 초기 데이터 설정
```
```
dev/dops/gitlab/user
{
"value": "devops"
}
```
```
dev/dops/gitlab/password
{
"password": "challenge77!!"
}
```
```
dev/dops/harbor/web/user
{
"value": "admin"
}
```
```
dev/dops/harbor/web/password
{
"password": "challenge77!!"
}
```
```
dev/dops/concourse/web/user
{
"value": "concourse"
}
```

Vault **초기데이터 등록**

```
## Vault 초기 데이터 설정
```
```
dev/dops/concourse/web/password
{
"value": “concourse"
}
```
```
dev/dops/jenkins/web/user
{
"value": "admin"
}
```
```
dev/dops/jenkins/web/password
{
"value": "challenge77!!"
}
```
```
dev/dops/k8s/kubeconfig
{
"value": “<KubeConfig파일 내용>＂
}
```

Vault **초기데이터 등록**

```
## Vault 초기 데이터 설정
dev/dops/keycloak/password
{
"value": "keycloak"
}
```
```
dev/dops/certs/root/certificate
{
"value": “Root 인증서의 .crt파일"
}
```
```
dev/dops/certs/root/csr
{
"value": “Root 인증서의 .csr파일"
}
```
```
dev/dops/certs/root/key
{
"value": “Root 인증서의 .key파일"
}
```
```
dev/portal/common
{
"app_crypto_key": "SysMasterK8s2022SysMasterK8s2022"
}
```

Vault **초기데이터 등록**

```
## Vault 초기 데이터 설정
```
```
dev/portal/database # mariadb설치 이후에 생성
{
"host": "jdbc:mariadb://{MYSQL IP}",
"password": "{MYSQL password} ",
"user": "{MYSQL USERNAME}"
}
```
```
dev/dops/rabbitmq/user
{
"value": "admin"
}
```
```
dev/dops/rabbitmq/password
{
"password": "uocYoYvV2OSIGLiw8MJQ"
}
```
```
dev/dops/gitlab/key/id_rsa.pub
"value": “inception 서버 /home/ansible/.ssh/id_rsa.pub 파일의 내용을 입력"
```
```
dev/dops/gitlab/key/id_rsa
"value": "inception 서버 /home/ansible/.ssh/id_rsa파일의 내용을 입력 "
```

Vault **초기데이터 등록**

```
## Vault 초기 데이터 설정
```
```
dev/portal/email
{
“address” : “admin@infranics.com”
“admin” : “admin@infranics.com”
}
```

Vault **초기데이터 등록**

```
#######Keycloak부분은 keycloak설치 후 기입하는게 좋다. 아직 keycloak설치 전이라 uuid, secret 등 정해지지 않았다.
```
```
dev/portal/admin
{
"adp.crypto.key": "SysMasterK8s2022SysMasterK8s2022",
"adp.db.password": "{MYSQL 비밀번호}",
"adp.db.url": "jdbc:mariadb://{MYSQL IP}:{MYSQL Port}/{MYSQL admin database}",
"adp.db.username": "{MYSQL ID}",
"adp.keycloak.admin_cli_id": "{Keycloak관리자 ID}",
"adp.keycloak.admin_cli_pw": "{Keycloak관리자 비번}",
"adp.keycloak.admin_role_id": “{ADMIN ROLE ID}",
"adp.keycloak.admin_role_name": "ADMIN",
"adp.keycloak.client_id": "{Keycloak관리자 포털 Client id}",
"adp.keycloak.client_secret": "{Keycloak관리자 포털 Client secret}",
"adp.keycloak.client_uuid": "{Keycloak관리자 포털 Client uuid}",
"adp.keycloak.realm": “{KeycloakRealm}",
"adp.keycloak.url": "{KeycloakURL 주소}",
"adp.minio.accessKey": "{MinioUserID}",
"adp.minio.bucket": "portal",
"adp.minio.secretKey": "{MinioUserPW}",
"adp.minio.url": "{MinioURL}",
"adp.mq.password": "uocYoYvV2OSIGLiw8MJQ",
"adp.mq.username": "admin",
"adp.portal.url": "{Admin Portal 주소}",
"adp.rabbitmq.port": "5672",
"adp.rabbitmq.url": "{Haproxy주소}",
"adp.redis.port": "6379",
"adp.redis.url": "{Haproxy주소}",
"adp.sms.host": "{Mail Server 주소}",
"adp.sms.password": "{Mail Server 비밀번호}",
"adp.sms.port": "{Mail Server 포트}",
"adp.sms.username": "{Mail Server 계정}"
}
```
```
샘플
데이터
```

Vault **초기데이터 등록**

```
#######database 부분 입력방법
```
```
"adp.db.password": "{MYSQL 비밀번호}",
```
```
# db설치시 지정한 비밀번호 Challenge77!!
```
```
＂adp.db.url＂: ＂jdbc:mariadb://{MYSQL IP}:{MYSQL Port}/{MYSQL admin database}＂,
```
```
"adp.db.username": "{MYSQL ID}",
```
```
# dbip = inception ip= 183.111.127.218
```
```
# dbport = mariadb port = 3306
```
```
# admin database = K8S_ADMIN
```
```
# dbusername = root
```

Vault **초기데이터 등록**

```
#######Keycloak부분 입력방법
```
```
"adp.keycloak.admin_cli_id": "{Keycloak관리자 ID}",
```
```
# keycloak페이지 접속 계정
```
```
"adp.keycloak.admin_cli_pw": "{Keycloak관리자 비번}",
```
```
# keycloak페이지 접속 계정의 비밀번호
```
```
＂adp.keycloak.admin_role_id＂: “{ADMIN ROLE ID}＂,
```
```
# admin-portal의 admin role 인 ADMIN을 클릭하여
# URL에서 ID를 복사하여 입력한다.
```

Vault **초기데이터 등록**

```
#######Keycloak부분 입력방법
```
```
"adp.keycloak.admin_role_name": "ADMIN",
```
```
# ADMIN을 입력할때 반드시 대문자로 입력한다.
```
```
＂adp.keycloak.client_id＂: ＂{Keycloak관리자 포털 Client id}＂,
"adp.keycloak.client_secret": "{Keycloak관리자 포털 Client secret}",
"adp.keycloak.client_uuid": "{Keycloak관리자 포털 Client uuid}",
```
```
# sysK8s realm의 client 메뉴에서 portal-admin-client를 클릭한다.
# id는 portal-admin-client 복사하여 입력한다.
# credentials를 선택하여 화면에 출력된 secret 내용을 복사하여 입력한다.
# uuid는 url에 출력된 부분을 복사하여 입력한다.
```

Vault **초기데이터 등록**

```
#######Keycloak부분 입력방법
```
```
"adp.keycloak.realm": “{KeycloakRealm}",
```
```
# realm은 sysK8s를 입력한다.
```
```
"adp.keycloak.url": "{KeycloakURL 주소}",
```
```
# https://keycloak.sysmasterk8s.com 를 입력한다.
```
```
# 반드시 https:// 를 붙인다.
```

Vault **초기데이터 등록**

```
#######Keycloak부분은 keycloak설치 후 기입하는게 좋다. 아직 keycloak설치 전이라 uuid, secret 등 정해지지 않았다.
```
```
dev/portal/user
{
"usp.crypto.key": " SysMasterK8s2022SysMasterK8s2022",
"usp.db.password": "{MYSQL PW}",
"usp.db.url": "jdbc:mariadb://{MYSQL IP}:{MYSQL Port}/{MYSQL User database}",
"usp.db.username": "{MYSQL USERNAME}",
"usp.keycloak.admin_cli_id": "keycloak",
"usp.keycloak.admin_cli_pw": "keycloak",
"usp.keycloak.client_id": "portal-user-client",
"usp.keycloak.client_secret": "{Keycloak관리자 포털 Client secret}",
"usp.keycloak.client_uuid": "{Keycloak관리자 포털 Client uuid}",
"usp.keycloak.realm": "{KeycloakRealm}",
"usp.keycloak.url": "{KeycloakURL 주소}",
"usp.keycloak.userRoleId": "{USER ROLE ID}",
"usp.keycloak.userRoleName": "USER",
"usp.minio.accessKey": "{MinioUserID}",
"usp.minio.bucket": "portal",
"usp.minio.secretKey": "{MinioUserPW}",
"usp.minio.url": "{MinioURL}",
"usp.mq.password": "uocYoYvV2OSIGLiw8MJQ",
"usp.mq.username": "admin",
"usp.portal.url": "{사용자 포탈 주소}",
"usp.rabbitmq.port": "5672",
"usp.rabbitmq.host": "{Haproxy주소}",
"usp.redis.port": "6379",
"usp.redis.url": "{Haproxy주소}",
"usp.sms.host": "{Mail Server 주소}",
"usp.sms.password": "{Mail Server 비밀번호}",
"usp.sms.port": "{Mail Server 포트}",
"usp.sms.username": "{Mail Server 사용자}"
}
```
```
샘플
데이터
```

Vault **초기데이터 등록**

```
####### database 부분 입력방법
```
```
"usp.db.password": "{MYSQL PW}",
```
```
# db설치시 지정한 비밀번호 Challenge77!!
```
```
"usp.db.url": "jdbc:mariadb://{MYSQL IP}:{MYSQL Port}/{MYSQL User database}",
```
```
"usp.db.username": "{MYSQL USERNAME}",
```
```
# dbip = inception ip= 183.111.127.218
```
```
# dbport = mariadb port = 3306
```
```
# user database = K8S_USER
```
```
# dbusername = root
```

Vault **초기데이터 등록**

```
# USER의 keycloak부분 입력방법
```
```
"usp.keycloak.client_id": "portal-user-client",
"usp.keycloak.client_secret": "{Keycloak관리자 포털 Client secret}",
"usp.keycloak.client_uuid": "{Keycloak관리자 포털 Client uuid}",
```
```
# sysK8s realm의 client 메뉴에서 portal-user-client를 클릭한다.
# id는 portal-user-client 복사하여 입력한다.
# credentials를 선택하여 화면에 출력된 secret 내용을 복사하여 입력한다.
# uuid는 url에 출력된 부분을 복사하여 입력한다.
```

Vault **초기데이터 등록**

```
# USER의 keycloak부분 입력방법
```
```
"usp.keycloak.realm": "{KeycloakRealm}",
```
```
# realm은 sysK8s를 입력한다.
```
```
"usp.keycloak.url": "{KeycloakURL 주소}",
```
```
# https://keycloak.sysmasterk8s.com 를 입력한다.
```
```
# 반드시 https:// 를 붙인다.
```
```
"usp.keycloak.userRoleId": "{USER ROLE ID}",
"usp.keycloak.userRoleName": "USER",
```
```
# user-portal의 role 인 USER을 클릭하여
# URL에서 ID를 복사하여 입력한다.
```

Vault **초기데이터 등록**

```
###### IAAS 를 넣어주는데 나중에 빼야할 것으로 보임.
###### 우선은
dev/portal/iaas
{
"iaas.db.password": "Challenge77!!",
"iaas.db.url": "jdbc:mariadb://183.111.127.218:3306/K8S_IAAS",
"iaas.db.username": "root",
"iaas.keycloak.admin_cli_id": "keycloak",
"iaas.keycloak.admin_cli_pw": "keycloak",
"iaas.keycloak.adminRealm": "eGovCP-Admin",
"iaas.keycloak.adminRealm_client_secret": "cb6f03e1-4e9b- 4382 - a33e-e6be4cdba083",
"iaas.keycloak.client_id": "openstack-user-client",
"iaas.keycloak.client_secret": "175a8be7-6d81-4a35-bff3-d92ccc80895e",
"iaas.keycloak.realm": "sysK8s",
"iaas.openstack.domain": "admin_domain",
"iaas.openstack.endpoint": "https://172.40.1.207:5000/v3",
"iaas.openstack.password": "master77!!",
"iaas.openstack.project": "platform-dev\n",
"iaas.openstack.swift.link": "https://172.40.1.207:8080/v1/AUTH_1f6c1eaf9da945e0a39bdc9abdf074d3/portal",
"iaas.openstack.username": "k8s“
}
```
### portal user api

### 배포시 IAAS 의 내용이 필요하여 넣었으나

### 나중에는 빼는 것으로 가야함.


Vault **초기데이터 등록**

```
dev/portal/user
{
"usp.crypto.key": " SysMasterK8s2022SysMasterK8s2022",
"usp.db.password": "Challenge77!!",
"usp.db.url": "jdbc:mariadb://183.111.127.218:3306/K8S_USER",
"usp.db.username": "root",
"usp.keycloak.admin_cli_id": "keycloak",
"usp.keycloak.admin_cli_pw": "keycloak",
"usp.keycloak.client_id": "portal-user-client",
"usp.keycloak.client_secret": "5fa024d2- 5217 - 4d80-81c9-e708e5c1d29f",
"usp.keycloak.client_uuid": "93d03105-df1f-4b1e-a273-99c6d3e9e5f5",
"usp.keycloak.realm": "sysK8s",
"usp.keycloak.url": "https://keycloak.sysmasterk8s.com",
"usp.keycloak.userRoleId": "a11365e7- 7139 - 4ded-950d-e7b7e1199f19",
"usp.keycloak.userRoleName": "USER",
"usp.minio.accessKey": "admin",
"usp.minio.bucket": "portal",
"usp.minio.secretKey": "challenge77!!",
"usp.minio.url": "https://minio.sysmasterk8s.com",
"usp.mq.password": "uocYoYvV2OSIGLiw8MJQ",
"usp.mq.username": "admin",
"usp.portal.url": "https://user-portal.sysmasterk8s.com",
"usp.rabbitmq.port": "5672",
"usp.rabbitmq.host": "183.111.127.218",
"usp.redis.port": "6379",
"usp.redis.url": "183.111.127.218",
"usp.sms.host": "mail.infranics.com",
"usp.sms.password": "k8s77!!",
"usp.sms.port": "25",
"usp.sms.username": "kkjslee"
}
```

Vault **초기데이터 등록**

```
dev/portal/admin
{
"adp.crypto.key": "SysMasterK8s2022SysMasterK8s2022",
"adp.db.password": "Challenge77!!",
"adp.db.url": "jdbc:mariadb://183.111.127.218:3306/K8S_ADMIN",
"adp.db.username": "root",
"adp.keycloak.admin_cli_id": "keycloak",
"adp.keycloak.admin_cli_pw": "keycloak",
"adp.keycloak.admin_role_id": “0936a192- 2789 - 497f-9b0c-4ddecba917a6",
"adp.keycloak.admin_role_name": "ADMIN",
"adp.keycloak.client_id": "Portal-admin-client",
"adp.keycloak.client_secret": "8ba3e7fa-a1ab-4f3f-b3fd-567dcc7c599a",
"adp.keycloak.client_uuid": "8f39f5df-d9b9-426a-b894-8509064d76bf",
"adp.keycloak.realm": “sysK8s",
"adp.keycloak.url": "https://keycloak.sysmasterk8s.com",
"adp.minio.accessKey": "admin",
"adp.minio.bucket": "portal",
"adp.minio.secretKey": "challenge77!!",
"adp.minio.url": "https://minio.sysmasterk8s.com",
"adp.mq.password": "uocYoYvV2OSIGLiw8MJQ",
"adp.mq.username": "admin",
"adp.portal.url": "admin-portal.sysmasterk8s.com",
"adp.rabbitmq.port": "5672",
"adp.rabbitmq.url": "183.111.127.218",
"adp.redis.port": "6379",
"adp.redis.url": "183.111.127.218",
"adp.sms.host": "mail.infranics.com",
"adp.sms.password": "k8s77!!",
"adp.sms.port": "25",
"adp.sms.username": "kkjslee"
}
```

Concourse **설치**


Concourse

**## Inception 서버 ansible계정에서 Concourse 서비스 설치**

$ export NAMESPACE=concourse

$ cd ~/platform_devops/deploy/helm/postgresql

```
$ helm install concourse --namespace ${NAMESPACE}. -f values.yaml\
--set postgresqlPassword=postgres\
--set postgresqlDatabase=concourse \
--set persistence.storageClass=ceph-rbd-sc \
--set updateStrategy.type=OnDelete\
--set image.registry=${DOCKER_REGISTRY}/platform_component\
--set asset.platform=platform_container\
--set asset.taskse=common_mgmt\
--set asset.taskcl=concourse \
--set global.imagePullSecrets={regcred} | kubectlapply --namespace ${NAMESPACE} -f -
```

Concourse


Concourse

```
$ cd /home/ansible/platform_devops/deploy/helm/concourse
```
```
$ helm install sysk8s-concourse --namespace ${NAMESPACE}. -f values.yaml\
--set imageTag=6.7.3 \
--set persistence.enabled=false \
--set web.ingress.enabled=true \
--set web.ingress.hosts={concourse.${BASE_DOMAIN}} \
--set concourse.web.bindPort=80 \
--set postgresql.enabled=false \
--set concourse.web.postgres.host=concourse-postgresql\
--set concourse.web.postgres.database=concourse \
--set secrets.postgresUser=postgres\
--set secrets.postgresPassword=postgres\
--set concourse.web.externalUrl=https://concourse.${BASE_DOMAIN} \
--set secrets.localUsers=${CONCOURSE_USER}:${CONCOURSE_PASSWD} \
--set concourse.web.auth.mainTeam.localUser=${CONCOURSE_USER} \
--set concourse.web.kubernetes.createTeamNamespaces=false \
--set worker.replicas=1 \
--set worker.emptyDirSize=30Gi \
--set worker.hardAntiAffinity=true \
--set worker.resources.requests.cpu=2 \
--set worker.resources.requests.memory=4Gi \
--set image=${DOCKER_REGISTRY}/platform_component/concourse/concourse \
--set imagePullSecrets={regcred} | kubectlapply --namespace ${NAMESPACE} -f -
```

Concourse

```
## 마지막 줄의 error parsing STDIN의 문제는 HELM의 버전 차이로 인해 발생하는 문제로 확인
## ERROR가 발생했지만 정상적으로 배포 확인 됨.
```

Concourse

```
## Haproxy설정
```
```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①Concourse에 접속할 도메인을 설정한다.
. ②Concourse가 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```
### ①

### ②


Concourse

```
## Fly 설치
$ sudowget--no-check-certificate -O /usr/local/bin/fly
"https://concourse.${BASE_DOMAIN}/api/v1/cli?arch=amd64&platform=linux" && sudochmod+x
/usr/local/bin/fly
```
#### ## SAFE 설치

```
$ sudowget-O /usr/local/bin/safe http://nexus.sysmasterk8s.com/repository/downloads/safe/safe-linux-
amd64 && sudochmod755 /usr/local/bin/safe
```
```
$ echo "ANSIBLE_HOST_KEY_CHECKING=False" >> .bashrc
```

Concourse

```
## fly 파이프라인 등록
$ fly -t ${ENV} login -c http://concourse.${BASE_DOMAIN} -u "${CONCOURSE_USER}" -p
"${CONCOURSE_PASSWD}"
```
```
$ safe target http://vault.${BASE_DOMAIN} myvault
```
```
$ safe authtoken
```
**. Vault 토큰 입력**


Concourse

```
## ~/platform_devops/concourse-pipeline/dev-concourse-param.yml의 내용을
환경에 맞게 수정
```
**$ vi ~/platform_devops/concourse-pipeline/dev-concourse-param.yml**


Concourse

```
# fly를 이용하여 pipeline을 생성한다.
```
```
$ fly -t ${ENV} set-pipeline -p sysk8s-fly -c ~/platform_devops/concourse-pipeline/fly-pipeline.yml\
--load-vars-from ~/platform_devops/concourse-pipeline/${ENV}-concourse-param.yml\
```
- v=VAULT_TOKEN=${VAULT_TOKEN} \
- v=concourse-passwd=${CONCOURSE_PASSWD} \
- v=oss-git-user="$(safe --insecure get secret/$ENV/dops/gitlab/user:value)" \
- v=oss-git-passwd="$(safe --insecure get secret/$ENV/dops/gitlab/password:password)" \
- v=harbor-regi-user="$(safe --insecure get secret/$ENV/dops/harbor/web/user:value)" \
- v=harbor-regi-password="$(safe --insecure get secret/$ENV/dops/harbor/web/password:password)" \
- n

```
또는 ~/platform_devops/concourse-pipeline 의 deploy_fly.sh 을 실행한다.
```

Concourse


Concourse

```
## Concourse 파이프라인 구성
```
```
1.Concourse 접속
```
. 설치시 설정한 계정 (concourse / concourse )을 이용하여 로그인한다.

```
2.sysk8s-fly 파이프라인의 시작버튼을 클릭한다.
```

Concourse

```
## 앞의 파이프 라인 배포가 완료되면 다음과 같이 pipeline이 생성된다.
```

Concourse

```
### concourse 사용시 주의사항
```
```
현재 concourse worker container는 1 개로 배포된다.
```
```
하지만 뒤에서 concours를 사용하여 배포를 하는 도중에 플레이 버튼을 클릭하면
```
```
해당 pipeline 내부의 모든 배포가 진행되는 경우가 있다.
```
```
이럴경우 worker container가 버티질 못하고 재생성되는 경우가 있으니
```
```
반드시 1 개 pipeline씩 배포를 진행하도록 한다.
```
```
## 여러 개 배포시 모두 취소하고 1 개만 플레이 한다.
```

keycloak **설치**


keycloak

```
## KeyCloak배포 (1/4)
```
```
1.Concourse 접속
```
```
2.component-on-k8s 파이프라인 시작 버튼 클릭
```
```
3.component-on-k8s 내부의 Keycloak카테고리 선택
```

keycloak

```
## KeyCloak배포(2/4)
```
```
1.keycloak-postgresql-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


keycloak

```
## KeyCloak배포(3/4)
```
```
1.keycloak-set-configuration JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


keycloak

```
## KeyCloak배포(4/4)
```
```
1.keycloak-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


keycloak

```
## KeyCloak배포 확인
```
```
1.rancher에서 keycloak, keycloak-postgresql앱이 정상적으로 배포 되었는지 확인한다.
```

keycloak

```
## Haproxy설정
```
```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①KeyCloak에 접속할 도메인을 설정한다.
. ②KeyCloak이 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

keycloak

```
## KeyCloak설치가 완료되었으면 앞에 설치한 Vault에 keycloak정보를 입력해줘야한다.
```
```
다음 페이지의 설정을 따라하면 입력이 가능하다.
```

keycloak

```
## KeyCloak접속
```
```
1.KeyCloak에 접속한다.
```
```
2.사전에 설정된 KeyCloak관리자 계정 ( keycloak/ keycloak)을 이용하여 로그인 한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.‘Add realm’ 버튼을 클릭하여 Realm을 추가해준다.
name : sysK8s
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.①Themes 탭을 클릭한다.
```
```
2.②Login Theme 항목에서 sysmaster를 선택한다.
```
```
3.③Save 버튼을 클릭하여 저장한다.
```
```
1
2
```
```
3
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.SysK8s Realm을 선택한다.
2.Client 메뉴를 클릭한다.
3.Create 버튼을 클릭한다.
4.portal-admin-client 생성
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Access Type을 confidential 으로 변경
```
```
2.Service Accounts Enabled를 off로 변경
```
```
3.Authorization Enabled를 off로 변경
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Root URL 입력(관리자 포탈 주소)
2.Valid Redirect URIs 입력(관리자 포탈 주소, 사용자 포탈 주소, 키클락 주소)
3.Base URL 주소 입력(관리자 포탈 주소)
4.Admin URL 입력(관리자 포탈 주소)
5.Web Origins 입력(관리자 포탈, *)
6.저장 클릭
```
```
※관리자 포탈, 사용자 포탈은 아직 배포전이니
배포 예정인 주소를 적으면 됩니다.
```
```
※오른쪽 그림은 <예시> 입니다.
해당하는 url을 입력하시길 바랍니다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Credentials 탭을 클릭한다.
```
```
2.Secret값을 확인하여, Vault에 해당 Secret 정보를 업데이트 해준다.
```
. 경로 : dev/portal/admin
    ①: adp.keycloak.client_uuid
    ②: adp.keycloak.client_secret


keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Users 메뉴를 클릭한다.
```
```
2.'Add user’ 버튼을 클릭하여 사용자를 등록한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
① 사용자 ID와 email을입력한다.
ID : admin
email : admin@admin.com
```
```
②Save 버튼을 클릭하여 저장한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.①Credentials 탭을 클릭한다.
```
```
2.②비밀번호를 입력한다.
```
. 비밀번호 : 사용자 지정

```
3.③Te m p o r a r y 항목을 비활성화 한다.
```
```
4.④set Password 버튼을 클릭하여 비밀번호를 저장한다.
```

keycloak

```
## Realm 설정 (SysK8s)
1.sysK8s Realm을 선택한다.
```
```
2.Client 메뉴를 클릭한다.
```
```
3.Create 버튼을 클릭한다.
```
```
4.portal-user-client 생성
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Access Type을 confidential 으로 변경
2.Service Accounts Enabled를 off로 변경
3.Authorization Enabled를 off로 변경
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Root URL 입력(사용자 포탈 주소)
2.Valid Redirect URIs 입력(관리자 포탈 주소, 사용자 포탈 주소, 키클락 주소)
3.Base URL 주소 입력(사용자 포탈 주소)
4.Admin URL 입력(사용자 포탈 주소)
5.Web Origins 입력(사용자 포탈, *)
6.저장 클릭
```
```
※관리자 포탈, 사용자 포탈은 아직 배포전이니
배포 예정인 주소를 적으면 됩니다.
```
```
※오른쪽 그림은 <예시> 입니다.
해당하는 url을 입력하시길 바랍니다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Credentials 탭을 클릭한다.
```
```
2.Secret값을 확인하여, Vault에 해당 Secret 정보를 업데이트 해준다.
```
. 경로 : dev/portal/user
    ①: usp.keycloak.client_uuid
    ②: usp.keycloak.client_secret


keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Users 메뉴를 클릭한다.
```
```
2.'Add user’ 버튼을 클릭하여 사용자를 등록한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.① 사용자 ID 입력한다.
ID : project02pm
```
```
2.②Save 버튼을 클릭하여 저장한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.①Credentials 탭을 클릭한다.
```
```
2.②비밀번호를 입력한다.
```
. 비밀번호 : 사용자 지정

```
3.③Te m p o r a r y 항목을 비활성화 한다.
```
```
4.④Reset Password 버튼을 클릭하여 비밀번호를 저장한다.
```

keycloak

```
## Realm 설정 (SysK8s)
```
```
1.Add Role 클릭
2.각각 ADMIN, SUPER, USER를 생성(대문자 필수)
```

Config server **설치**


Config server

```
## ConfigServer배포 (1/4)
```
```
1.Concourse 접속
```
```
2.component-on-k8s 파이프라인 선택
```
```
3.ConfigServer카테고리 선택
```

Config server

```
## ConfigServer배포
```
```
1.Configserver-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


Config server

```
## Haproxy설정
```
```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①ConfigServer에 접속할 도메인을 설정한다.
. ②ConfigServer가 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

Config server

```
## ConfigServer배포 (2/4)
```
```
1.Configserver-configs-apply JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


Config server

```
## ConfigServer설치 확인
```
```
웹 브라우저에서 아래의 url을 접속한다.
```
```
http://configserver.sysmasterk8s.com/SysMasterK8sAdminApi/dev
```

Config server

```
## ConfigServer의 경우에는 gitlab이 업데이트 되면 자동으로 배포되도록 설정되어 있으므로
```
```
## component-ink8s pipeline을 puase상태로 바꾸지 않고 계속 play 상태로 놔둔다.
```

Jenkins **설치**


Jenkins

```
## Jenkins 배포 (1/3)
```
```
1.Concourse 접속
```
```
2.component-on-k8s 파이프라인 선택
```
```
3.Jenkins 카테고리 선택
```

Jenkins

```
## Jenkins 배포 (2/3)
```
```
1.Jenkins-set-configmapJOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


Jenkins

```
## Jenkins 배포 (3/3)
```
```
1.Jenkins-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


Jenkins

```
## Jenkins 배포 확인
```
```
1.jenkins앱이 정상적으로 배포 되었는지 확인한다.
```

Jenkins

```
## Haproxy설정
```
```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①Jenkins에 접속할 도메인을 설정한다.
. ②Jenkins가 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

Jenkins

```
## Jenkins 설정 백업파일 복사
```
```
1.Inception 서버에 접속
```
```
2.Jenkins backup 파일을 확인한다.
```
3. K8s에 설치되어 있는 Jenkins의 파드 정보를 확인한다.
kubectlget pod -n jenkins
4. 백업 파일을 kubectl명령어로 Jenkins 파드에 복사한다.

```
kubectlcpJenkins_home.tar.gz <POD명>:/var/Jenkins_home–n jenkins
```
```
kubectlcpjenkins_home.tar.gz sysk8s-jenkins-59bd4cd7fd-mjgtw:/var/jenkins_home-n jenkins
```

Jenkins


Jenkins

```
## Jenkins 설정 백업파일 압축해제
```
```
1.kubectl명령어로 Jenkins 파드에 접속한다.
```
```
kubectlexec -it <POD명> – n jenkins/bin/bash
```
```
2.cd /var/jenkins_home
```
```
3.tar zxvfjenkins_home.tar.gz
```

Jenkins

```
## Jenkins 접속
```
1. 브라우저에서 Jenkins.sysmasterk8s.com에 접속한다.


Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins url에 /restart를 입력한 후 Ye s 버튼을 클릭한다.
2.Jenkins가 재시작 할 떄 까지 기다린 후 재로그인 한다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins 관리 > 플러그인 관리 메뉴를 클릭한다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins 관리 > ThinBackup> Settings 메뉴를 클릭한다.
```
```
2.Backup directory 항목을 '/cephfs-jenkins‘ 로 수정 후 save 버튼을 클릭한다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins 관리 > Manage Credentials 메뉴를 클릭한다.
```
```
2.credential 오른쪽의 updat를 눌러 다음의 내용을 변경한다.
```
. git_access_key: gitlabsshkey 정보(id_rsa)
. docker-registry-credentials : Harbor 인증 정보
. nexus-credentials : Nexus 인증 정보
. Vault-credentials : Vault 토큰 정보
# username의 vault 주소도 확인하여 같이 변경
. kube_config: K8s 클러스터 kube_config정보


Jenkins

. docker-registry-credentials : Harbor 인증 정보

```
# change password 를 클릭하여 harbor의 비밀번호를 입력한다.
```

Jenkins

. git_access_key: gitlabsshkey 정보(id_rsa)
. docker-registry-credentials : Harbor 인증 정보
. nexus-credentials : Nexus 인증 정보
. Vault-credentials : Vault 토큰 정보
. kube_config: K8s 클러스터 kube_config정보


Jenkins

. nexus-credentials : Nexus 인증 정보

```
# change-password 버튼을 클릭하여 nexus 의 admin 계정 비밀번호를 입력한다.
```

Jenkins

. Vault-credentials : Vault 토큰 정보

```
# change-password 버튼을 클릭하여 inception 서버의 /home/ansible/service-vault-info.txt 파일 내부의
Initial Root Token 값을 입력한다.
```
```
# username의 vault 주소도 확인하여 같이 변경
```

Jenkins

. kube_config: K8s 클러스터 kube_config정보

```
# change-password 버튼을 클릭하고 rancher 의 클러스터 kubeconfigfile 내용을 복사하여 입력한다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins 관리 > 시스템 설정 메뉴를 클릭한다.
2.Jenkins Location, SonarQubeServer, Source Code Management 에 주소가 올바르게 되어있는지 확인한다.
```
3. 3 번의 Default Version 부분에 commit SHA가 보이면 정상입니다. 안 나올 시에는 git_access_key가 잘못된
    것이므로 전 페이지의 git_aceess_key를 수정해야 합니다.

```
# 포트를 안 붙이면 아래 에러가 발생함.
```

Jenkins


Jenkins

```
# project repogitory에 30022 포트를 안 붙이면 아래 에러가 발생함.
```
```
# 반드시 gitlab주소뒤에 30022 입력하자.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.Jenkins 관리 > 시스템 설정 > 가장 아래에 있는 a separate configuration page 클릭
2.Kubernetes Cloud details 클릭
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.만약 빨간색으로 표시한 부분이 공백으로 되어있다면 빈칸을 채워줍니다.
2.① 부분에 Te s t C o n n e c t i o n 버튼 클릭시 ② 부분에 KuberntesVersion 이 나오면 성공
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.빨간색 네모 표시처럼 되어있으면 하단에 Pod Templates 클릭
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.만약 빨간색으로 표시한 부분이 공백으로 되어있다면 빈칸을 채워준 후Pod Template details... 클릭합니다
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.만약 빨간색으로 표시한 부분이 공백으로 되어있다면 사진과 같이 빈칸을 채웁니다.
# test.hskim.com -> sysmasterk8s.com 처럼 지정한 도메인으로 수정
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.만약 빨간색으로 표시한 부분이 공백으로 되어있다면 사진과 같이 빈칸을 채웁니다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.만약 빨간색으로 표시한 부분이 공백으로 되어있다면 사진과 같이 빈칸을 채웁니다.
2.네모 박스를 채우고 Save 클릭
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.platform_portal_buildJOB을 선택한다.
```
```
2.① 구성 버튼을 클릭한다.
```
```
3.②Gitlab연결정보를 환경에 맞게 수정한다.
```

Jenkins

```
1.②Gitlab연결정보를 환경에 맞게 수정한다.
```
```
# 여기서도 마찬가지로 30022 포트를 반드시 입력한다.
```

Jenkins

```
## Jenkins 초기 설정
```
```
1.platform_portal_deployJOB을 선택한다.
```
```
2.① 구성 버튼을 클릭한다.
```
```
3.②Gitlab연결정보를 환경에 맞게 수정한다.
```

Jenkins

```
1.②Gitlab연결정보를 환경에 맞게 수정한다.
```
```
# 여기서도 마찬가지로 30022 포트를 반드시 입력한다.
```

MkDocs **설치**


MkDocs

```
## MkDocs배포 (1/6)
```
```
1.Concourse 접속
```
```
2.documents 파이프라인 선택
```
```
3.재생 버튼 클릭
```

MkDocs

```
## MkDocs배포 (2/6)
```
1. user-docs-deploy 클릭 후 + 클릭


MkDocs

```
## MkDocs배포 (3/6)
```
1. admin-docs-deploy 클릭 후 + 클릭


MkDocs

```
## MkDocs배포 (4/6)
```
1. create-pdf-export-configmap클릭 후 + 클릭


MkDocs

```
## MkDocs배포 (5/6)
```
```
1.user-docs-apply 클릭 후 + 클릭
```

MkDocs

```
## MkDocs배포 (6/6)
```
1. admin-docs-apply 클릭 후 + 클릭


MkDocs

```
## Haproxy설정
```
```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①MkDocs에 접속할 도메인을 설정한다.
. ②MkDocs가 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

MkDocs

```
## MkDocs의 경우에는 gitlab이 업데이트 되면 자동으로 반영되도록 설정되어 있다.
```
```
## 그러므로 pause 상태로 바꾸지 않고 게속 play 상태를 유지하도록 한다.
```

Redis **설치**


Redis

```
## Redis배포 (1/2)
```
```
1.Concourse 접속
```
```
2.portal 파이프라인 선택
```

Redis

```
## Redis배포 (1/2)
```
```
1.Redis-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


RabbitMQ **설치**


Rabbit MQ

```
## RabbitMQ배포 (1/2)
```
```
1.Concourse 접속
```
```
2.portal 파이프라인 선택
```

Rabbit MQ

```
## RabbitMQ배포 (1/2)
```
```
1.RabbitMQ-deploy JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.


**사용자 포탈 배포**


portal **배포 순서**

```
## portal의 배포 진행
```
```
portal의 배포는conrcourse로 명령을 실행하면 jenkins에서 모든 배포 단계를 진행한다.
따라서 배포 중간에 문제가 발생할 경우 jenkins내부의 credential이 잘못되어 있는지 다시 확인한다.
```
concourse jenkins

gitlab

harbor

namespace portal-dev

#### 실행 명령

```
필요한 image
download
```
```
필요한 source
download
```
```
container 배포
```

**사용자 포탈**

#### ## 사용자 포털 배포

```
1.Concourse 접속
```
```
2.portal 파이프라인 선택
```

**사용자 포탈**

#### ## 사용자 포털 배포 (2/4)

```
1.SysMasterK8sUserApi-build JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.
3. Build가 완료되면 자동으로 Deploy까지 진행된다.


**사용자 포탈**

```
## error가 발생시 jenkins에 접속하여 해당 에러 내용을 확인한다.
```

**사용자 포탈**

#### ## 사용자 포털 배포 (3/4)

```
1.SysMasterK8sUserApp-build JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.
3. Build가 완료되면 자동으로 Deploy까지 진행된다.


**사용자 포탈**

#### ## 사용자 포털 배포 확인

```
1.Portal-user-api, portal-user-app 앱이 정상적으로 배포 되었는지 확인한다.
```

**사용자 포탈**

#### ## 사용자 포털 배포 (4/4)

```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①사용자 포털에 접속할 도메인을 설정한다.
. ②사용자 포털이 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

**포탈 배포** error **발생**


**포탈 배포 중** ERROR

```
# 포탈 배포 중 다음과 같이 nfserror가 발생시 다음 페이지와 같이 수정한다.
```

**포탈 배포 중** ERROR

```
# 포탈 배포 중 다음과 같이 nfserror가 발생시 다음 페이지와 같이 수정한다.
```
```
$ cd /home/ansible/platform_devops/deploy/config/portal
```
```
$ grep –R nfs
```
```
$ vi SysMasterK8sAdminApi.yml.erb
$ vi SysMasterK8sUserApi.yml.erb
###
```
```
nfs_use: true -> false
```
```
###
```
```
# 수정한 파일을 git에 업로드
$ cd /home/ansible/platform_devops
$ gitadd.
$ gitcommit -m "4"
$ gitpush origin master
```

**포탈 배포 중** ERROR

```
# concourse 에서 portal pipeline 삭제
```
```
$ fly -t dev destroy-pipeline -p portal
```
```
# sysk8s-fly 에 접속
```

**포탈 배포 중** ERROR

```
# sysk8s-fly -devops-ci-git에서 새로고침
```

**포탈 배포 중** ERROR

```
# sysk8s-fly –deploy-pipeline 재배포
```

**포탈 배포 중** ERROR

```
# 새로 생성된 portal pipeline에서 다시 build 후 다시 deploy 한다.
```

**관리자 포탈 배포**


**관리자 포탈**

#### ## 관리자 포털 배포

```
1.Concourse 접속
```
```
2.portal 파이프라인 선택
```

**관리자 포탈**

#### ## 관리자 포털 배포 (2/4)

```
1.SysMasterK8sAdminApi-build JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.
3. Build가 완료되면 자동으로 Deploy까지 진행된다.


**관리자 포탈**

#### ## 관리자 포털 배포 (3/4)

```
1.SysMasterK8sAdminApp-build JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.
3. Build가 완료되면 자동으로 Deploy까지 진행된다.


**관리자 포탈**

#### ## 관리자 포털 배포 확인

```
1.Portal-admin-api, portal-admin-app 앱이 정상적으로 배포 되었는지 확인한다.
```

**관리자 포탈**

#### ## 관리자 포털 배포 (4/4)

```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①관리자 포털에 접속할 도메인을 설정한다.
. ②관리자 포털이 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

**모니터링 포탈 앱**

**배포**


**모니터링 포탈 앱**

#### ## 모니터링 포털 앱 배포 (1/3)

```
1.Concourse 접속
```
```
2.portal 파이프라인 선택
```

**모니터링 포탈 앱**

#### ## 모니터링 포털 앱 배포 (2/3)

```
1.SysMasterK8sMonitoringApp-build JOB을 선택한다.
```
2. 버튼을 클릭하여 배포를 진행한다.
3. Build가 완료되면 자동으로 Deploy까지 진행된다.
4. MonitoringApi는 Concourse에서 배포 하지 않는다.
(추후 kubectl로 배포 예정)


**모니터링 포탈 앱**

#### ## 모니터링 포털 앱 배포 (3/3)

```
1.Haproxy서버에 접속한다.
```
```
2./etc/haproxy/haproxy.cfg파일을 수정한다.
```
. ①관리자 포털에 접속할 도메인을 설정한다.
. ②관리자 포털이 설치되어 있는 worker-node IP를
    입력한다.

```
3.Haproxy서비스를 재시작 한다.
systemctlrestart haproxy
```

SCM **설치**


SCM **준비사항**

#### ## 파일 이동

```
설치에 필요한 파일을 /home/ubuntu/download/cicd/ 디렉토리에 업로드 한다.
```
```
해당 파일을 ansible계정의 홈 디렉토리로 이동한다.
```
```
$ cd /home/ubuntu/download/cicd/
```
```
$ mv CICD_v20220504_01.zip /home/ansible/
```
#### 해당 파일을 압축해제한다.

```
$ unzip CICD_v20220504_01.zip
```
```
$ cd cicd
```
```
$ ls -al
```

SCM **준비사항**

```
## registry 에 프로젝트 생성
```
```
scm프로젝트를 private로 생성한다.
```

SCM **준비사항**

#### ## 이미지 업로드

```
scm설치에 필요한 이미지 파일을 registry.sysmasterk8s.com 에 업로드한다.
(총 4 개의 파일을 업로드)
```
```
$ cd /home/ansible/cicd/scm/DockerImages/scm
```
```
# 이미지 로드
```
```
$ sudodockerload –I {파일 명}
```
```
# 이미지 tag 변경
## 해당 명령어는 tag에서 도메인을 다음과 같이 변경한다.
## 기존 이미지 명과 태그를 그대로 사용해야 한다.
```
```
$ sudodockertag registry1.dev.sm-k8s.com/scm/{이미지명:태그} registry.sysmasterk8s.com/scm/ {이미지명:
태그}
```
```
# 이미지 업로드
# 다음 명령어로 harbor에 이미지를 저장한다.
```
```
$ sudodockerpush registry.sysmasterk8s.com/scm/ {이미지명:태그}
```

SCM **준비사항**

#### ## 이미지 업로드 결과


SCM **준비사항**

#### ## 넥서스 저장소 확인

```
gitlab구축 이후 ci 및 파비콘 아이콘을 적요하기 위한 이미지가 nexus에 저장되어 있습니다.
해당 이미지가 변경될 경우 동일한 경로에 동일한 이름으로 변경하여 업로드합니다.
```

SCM **준비사항**

```
## helm repository 등록
```
```
inception 서버에서 다음의 명령어로 scmhelm chart를 등록합니다.
```
```
$ helm repo add scmhttps://registry.sysmasterk8s.com:9443/chartrepo/scm --insecure-skip-tls-verify --
username=admin --password=challenge77!!
```
#### 또는

```
/home/ansible/cicd/scm/HelmCharts/repo_add.sh 을 실행합니다.
```
```
# 실행하기 전에 내부의 도메인을 확인합니다.
```

SCM **준비사항**

```
## keycloak에 client 생성
```
```
client ID : scm
Root URL : https://scm.sysmasterk8s.com
```

SCM **준비사항**

```
## client 확인
```
```
방금 생성한 clien를 확인하기 위해서 edit 버튼을 클릭합니다.
```

SCM **준비사항**

```
## client 수정
```
```
client protocol을 saml로 변경한다.
```
```
# 아래 그림과 같이 설정을 동일하게 변경
```

SCM **준비사항**

```
## client 수정
```
```
sam방식 sso설정 변경
```
```
# 아래 그림과 같이 설정을 동일하게 변경
```
```
enabled : on
```
```
include authnstatement: on
```
```
sign documents : on
```
```
sign assertions : on
```

SCM **준비사항**

```
## client 수정
```
```
sam방식 sso설정 변경
```
```
# 아래 그림과 같이 설정을 동일하게 변경
```

SCM **준비사항**

```
## client 수정
```
```
sam방식 sso설정 변경
```
```
# 다음과 같이 설정을 변경 이후 save
```
```
Force POST Binding
: on
Front Channel Logout
: on
Name ID Format
: persistent
Root URL
: https://scm.sysmasterk8s.com
Valid Redirect URIs
: https://scm.sysmasterk8s.com/users/auth/saml/callback
Base URL
: /
Default URL to use when the
: https://scm.sysmasterk8s.com/users/auth/saml/callback
IDP Initiated SSO URL Name
: scm
```

SCM **준비사항**

```
## client 수정
```
```
sam방식 sso설정 변경
```
```
# 아래 그림과 같이 설정을 동일하게 변경 이후 save
```

SCM **준비사항**

```
## client 에 role을 추가
```
```
role name : scm:external
```

SCM **준비사항**

```
## client 에 추가된 role을 확인
```
```
role name : scm:external
```

SCM **준비사항**

```
## client 에 mapper 생성
```
```
# 다음 설정에 맞게 입력하여 mapper를 생성한다.
```
```
name : USER
```
```
Mapper Type : User Property
```
```
property : Username
```
```
FrienflyName : Username
```
```
SAML Attribute Name : name
```
```
SAML Attribute Nameformat: basic
```

SCM **준비사항**

```
## client 에 mapper 생성
```

SCM **준비사항**

```
## 앞에서 생성한 name과 동일하게 다음의 mapper 5 개+를 생성해준다.
```
```
Name: name
Mapper Type: User Property
Property: Username
Friendly Name: Username
SAML Attribute Name: name
SAML Attribute NameFormat: Basic
*************************
Name: email
Mapper Type: User Property
Property: Email
Friendly Name: Email
SAML Attribute Name: email
SAML Attribute NameFormat: Basic
***************************
Name: first_name
Mapper Type: User Property
Property: FirstName
Friendly Name: First Name
SAML Attribute Name: first_name
SAML Attribute NameFormat: Basic
****************************
```
```
Name: last_name
Mapper Type: User Property
Property: LastName
Friendly Name: Last Name
SAML Attribute Name: last_name
SAML Attribute NameFormat: Basic
****************************
Name: roles
Mapper Type: Role list
Role attribute name: roles
Friendly Name: Roles
SAML Attribute NameFormat: Basic
Single Role Attribute: On
```

SCM **준비사항**

```
## mapper 확인
## 앞에서 생성한 mapper를 확인한다.
```

SCM **준비사항**

```
## kube-config복사
```
```
rancher에서 kube-config를 복사하여 /home/ansible/cicd/scm/script 디렉토리의 k8s_config 파일에 넣는다.
```
```
$ vi /home/ansible/cicd/scm/script/k8s_config
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/script 디렉토리의 install_gitlab.sh에서 gitlab백업을 위한 설정을 변경
```
```
# bm-ceph-cluster- 1 에 접속하여 radosgw-admin의 정보를 확인한다.
```
```
$ sshubuntu@bm-ceph-cluster- 1
```
```
$ cd cepn-deploy
```
```
$ cat api-access-key
```
```
$ cat api-secret-key
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/script 디렉토리의 install_gitlab.sh에서 gitlab백업을 위한 설정을 변경
```
```
# 아래 그림과 같이 backup.s3 항목 들을 변경한다.
```
```
backup.s3.storage.upload.enabled = true
```
```
backup.s3.storage.upload.provider = AWD
```
```
backup.s3.storage.upload.access.key.id = 앞에서 복사한api-access-key 내용
```
```
backup.s3.storage.upload.access.secret.key = 앞에서 복사한 api-secret-key
```
```
backup.s3.storage.upload.endpoint = http://bm-ceph-cluister- 1 의 ip: 7480
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/script 디렉토리의 install_gitlab.sh에서 gitlab백업을 위한 설정을 변경
```
```
# 파일 내용을 현재 도메인 정보와 동일하게 변경한다.
```

SCM **준비사항**

```
## key 복사
```
```
realm serrings-> keys -> RS256 -> certificate 를 클릭하여 나오는 인증서를 복사
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/script 디렉토리의 install_gitlab.sh에서 gitlab백업을 위한 설정을 변경
```
```
#keycloak.algorithm.rs256.certificate 의 내용을 앞에서 복사한keys의 rs256 의 certificate을 입력한다.
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/script 디렉토리의 install_gitlab.sh에서 gitlab백업을 위한 설정을 변경
```
```
# keycloak과 vault 정보등을 기존의 도메인과 동일하게 변경한다.
```

SCM **준비사항**

```
## default 프로젝트에 scmnamespace 생성
```

SCM **준비사항**

```
## install.sh의 gitlab설정 변경
```
```
/home/ansible/cicd/scm/db/mariadb디렉토리의 init.sql파일을 mysql에 import 한다.
```
```
# 다음 명령어를 실행
```
```
$ cd /home/ansible/cicd/scm/db/mariadb
```
```
$ mysql–u root –p < init.sql
Enter password: 패스워드 입력
```
```
MariaDB[(none)]> use K8S_BROKER
```
```
MariaDB[K8S_BROKER]> show tables;
```
```
# init.sql내부의 table이 생성된 것을 확인
```

SCM **준비사항**

```
## 다음 표에 맞춰서 install_gitlab.sh 을 수정한다.
```
```
Key Type Description
```
```
externalUrl String GitLab외부접근URL
```
```
gitlabRootPassword String GitLab관리자패스워드
```
```
ingress.enabled String GitLabingress 사용여부
```
```
ingress.url String GitLabingress URL
```
```
serviceType String GitLab서비스종류
```
```
ingress.https.enabled String GitLab Ingresshttps 프로토콜사용여부
```
```
updateStrategy.type String GitLab업데이트전략
```
```
persistence.gitlabEtc.size String GitLab의etc 볼륨사이즈
```
```
persistence.gitlabEtc.storageClass String GitLab의ete 볼륨스토리지클래스
```
```
persistence.gitlabData.size String GitLab의gitlab-data 볼륨사이즈
```
```
persistence.gitlabData.storageClass String GitLab의gitlab-data볼륨스토리지클래스
```

SCM **준비사항**

```
## 다음 표에 맞춰서 install_gitlab.sh 을 수정한다.
```
```
Key Type Description
```
```
sshNodePort String GitLabssh 포트
```
```
image String GitLabDocker 이미지URL
```
```
imagePullSecret String GitLab이미지시크릿
```
```
cronjob.image String GitLab의클론JOBDocker 이미지URL
```
```
shellimage.registry String GitLab 구성설정할때사용하는이미지저장소URL
```
```
shellimage.repository String GitLab 구성설정할때사용하는이미지레파지토리
```
```
shellimage.tag String GitLab 구성설정할때사용하는이미지태크
```
```
keycloak.sso.enabled String Keycloak사용여부
```
```
keycloak.assertion.consumer.service.url String Keycloaksaml callback url
```
```
keycloak.algorithm.rs256.certificate String Keycloak realmsRSA256의Certificate
```
```
keycloak.idp.sso.target.url String Keycloak saml ssotarget url
```
```
keycloak.issuer String Keycloakclient 이름
```

SCM **준비사항**

```
## 다음 표에 맞춰서 install_gitlab.sh 을 수정한다.
```
```
Key Type Description
```
```
backup.s3.storage.upload.enabled String 백업파일을S3스토리지업로드사용여부
```
```
backup.s3.storage.provider String S3 스토리지제공자
```
```
backup.s3.storage.access.key.id String S3 스토리지접근KEY 아이디
```
```
backup.s3.storage.access.secret.key String S3 스토리지접근시크릿key
```
```
backup.s3.storage.endpoint String S3 스토리지엔드포인트
```
```
backup.s3.storage.bucket String S3 스토리지bucket(저장소)
```
```
nexus.repository String Nexus레파지토리URL
```
```
k8s.config Object KubkernetesConfigfile
```
```
broker.ingress.enabled String 브로커서비스Ingress사용여부
```
```
broker.ingress.url String 브로커서비스IngressURL
```
```
broker.serviceType String 브로커서비스서비스타입
```
```
broker.image.repository String 브로커서비스Dockerimage 레파지토리주소
```

SCM **준비사항**

```
## 다음 표에 맞춰서 install_gitlab.sh 을 수정한다.
```
```
Key Type Description
broker.image.tag String 브로커서비스dockerimage tag
broker.portal.user.db.url String 사용자포털DBJDBCURL
broker.portal.user.db.username String 사용자포털DB id
broker.portal.user.db.password String 사용자포털DB 패스워드
broker.portal.user.db.driver String 사용자포털DB드라이버
broker.db.url String 브로커서비스DB JDBC URL
broker.db.username String 브로커서비스DB id
broker.db.password String 브로커서비스DB패스워드
broker.db.driver String 브로커서비스DB 드라이버
```
```
broker.vault.host String Vault 서버Host
```
```
broker.vault.token String Vault서버접근토큰
```
```
broker.vault.port String Vault서버포트
```
```
broker.vault.scheme String Vault 서버스키마(http, https)
```
```
broker.server.logging.file.name String 브로커서비스로그파일
```
```
broker.api.gitlab.base String GitLab서비스의API Base URL
```
```
broker.server.dashboard.url String 브로커서비스대시보드URL
```

SCM **설치**

```
## 수정한 install_gitlab.sh을 실행한다.
```
```
$ sudochmod+x install_gitlab.sh
```
```
$ ./install_gitlab.sh
```

SCM **설치확인**

#### ## 설치 확인

```
## 지정한 도메인 http://scm.sysmasterk8s.com으로 접속해서 아래의 web ui가 나오면 정상 설치
```

SCM **로그인**

#### ## 로그인

```
## 계정 root / challenge77!!
## 아래의 keycloak연동을 저장한다.
```

Postgresql **설치**


Postgresql **설치**

```
## postgresql설치
```
```
$ sudoapt update && sudoapt upgrade
```
```
$ sudoapt -y install gnupg2 wgetvim
```
```
$ sudosh-c 'echo "deb https://k8s-nexus.spaasta.com/repository/postgres-apt bionic-pgdgmain" >
/etc/apt/sources.list.d/pgdg.list'
```
```
$ sudosh-c 'echo "deb https://k8s-nexus.spaasta.com/repository/postgres-apt bionic-pgdgmain" >
/etc/apt/sources.list.d/pgdg.list‘
```
```
$ wget--quiet -O -https://k8s-nexus.spaasta.com/repository/downloads/postgresql/postgresql.asc | sudo
apt-key add -
```
```
$ sudoapt -y update
```
```
$ sudo apt -y install postgresql- 14
```

Postgresql **설치**

```
## postgresql설치 확인
```
```
$ sudopsql–V
```

Postgresql **설치**

```
# postgreql원격접속 허용
```
```
$ sudovi /etc/postgresql/14/main/postgresql.conf
```
```
# 다음 위치에 아래 내용을 추가
```
```
listen_addresses= '0.0.0.0'
```

Postgresql **설치**

```
# postgreql원격접속 허용
```
```
$ sudovi /etc/postgresql/14/main/pg_hba.conf
```
```
# 마지막 줄에 다음 내용을 추가
###
```
```
host all all 0.0.0.0/0 md5
```
```
###
```
```
## postgresql재시작
```
```
$ sudosystemctlrestart postgresql
```

Postgresql **설치**

```
# postgre계정 비밀번호 생성
```
```
$ sudopasswdpostgres
```
```
# postgres계정으로 변경
```
```
$ sudosu–postgres
```
```
# postgresql접속
```
```
$ psql
```

Postgresql **설치**

```
# postgreqldatabase 생성
```
```
$ CREATE DATABASE sonarqube;
```
```
$ \l ##역슬래시 l 으로 데이터 베이스 확인
```

Postgresql **설치**

```
# postgreqldatabase 생성
```
```
$ CREATE DATABASE sonarqube;
```
```
# postgres계정 비밀번호 설정
```
```
$ ALTER USER postgreswith password 'challenge77!!';
```
```
$ \q
```
```
# 비밀번호 사용해서 로그인
```
```
$ psql–U postgress–W
```

pipeline **설치**


pipeline **준비사항**

```
## registry 에 프로젝트 생성
```
```
delivery_pipeline프로젝트를 private로 생성한다.
```

pipeline **준비사항**

#### ## 이미지 업로드

```
scm설치에 필요한 이미지 파일을 registry.sysmasterk8s.com 에 업로드한다.
(총 4 개의 파일을 업로드)
```
```
$ cd /home/ansible/cicd/delivery-pipeline/cicd/DockerImages
$ cd /home/ansible/cicd/delivery-pipeline/cicd/DockerImages/delivery_pipeline^base
```
```
# 이미지 로드
```
```
$ sudodockerload –I {파일 명}
```
```
# 이미지 tag 변경
## 해당 명령어는 tag에서 도메인을 다음과 같이 변경한다.
## 기존 이미지 명과 태그를 그대로 사용해야 한다.
```
```
$ sudodockertag registry1.dev.sm-k8s.com/delivery_pipeline/{이미지명:태그}
registry.sysmasterk8s.com/delivery_pipeline/ {이미지명:태그}
```
```
# 이미지 업로드
# 다음 명령어로 harbor에 이미지를 저장한다.
```
```
$ sudodockerpush registry.sysmasterk8s.com/delivery_pipeline/ {이미지명:태그}
```

pipeline **준비사항**

#### ## 이미지 업로드 결과


pipeline **준비사항**

#### ## 넥서스 저장소 확인

```
pipeline 구축에 필요한 home.tar.gz파일이 nexus에 업로드 되어 있습니다.
해당 파일이 변경될 경우 동일한 경로에 동일한 이름으로 변경하여 업로드합니다.
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# keycloak접속 후 realm > clients > create 버튼
```
```
client ID : pipeclient
client protocol : openid-connect
root url: https://pipeline.sysmasterk8s.com/dashboard
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# access type 을 contidential로 변경
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

#### # 아래와 같이 SSO 관련 설정 변경

```
Enabled -ON
Standard Flow Enabled -ON
Implicit Flow Enabled -OFF
Direct Access Grants Enabled -ON
Service Accounts Enabled -ON
Authorization Enabled -ON
```
```
Admin URL 뒤에 / 붙임
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

#### # 아래와 같이 SSO 관련 설정 변경


pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# client scope > create 버튼 클릭하여 다음 scope 추가
```
```
name -read
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# client > pipelcient> client scopes
default client scopes 의 available client scopes 의 read를 선택후 addselected버튼을 클릭
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# client > pipelcient> client scopes
다음과 같이 read client scope가 assigned default client scopes로 이동된 것을 확인
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# database 추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/db/mariadb
```
```
$ ls –al
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# 다음 명령어로 database 추가
```
```
$ mysql -u root -p < init.sql
```
```
$ mysql -u root -p < broker_init.sql
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# rancher 의 default 프로젝트에 cicd네임스페이스 추가
```

pipeline **준비사항**

#### ## 설치 전 준비 사항

```
# helm chart 추가
```
```
harbor의 deplivery_pipeline프로젝트의 helm charts 메뉴에서 pipeline-0.1.6.tgz 파일을 upload한다.
```

pipeline **설치**

```
# helm repo 추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/cicd/HelmCharts
```
```
# 하퍼 url를 확인한다.
```
```
$ vi repo_add.sh
```
```
$ sudochmod+x repo_add.sh
```
```
# sh파일을 실행
```
```
$ ./repo_add.sh
```

pipeline **설치**

```
# Default values for pipeline.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
assets:
platform: platform_service
taskcl: delivery_pipeline
taskse: application_tool
```
```
vault:
host: vault.vault.svc.cluster.local
port: 8200
scheme: http
token: s.q8NZepILgCSSAImM8EgA1V6E
path:
redmine: secret/data/dev/redmine/{project_id}
pinpoint: secret/data/dev/pinpoint/{project_id}
k8s: secret/data/dev/k8s/{project_id}/kubeconfig
```
```
ci:
server:
url: http://cicd-jenkins.cicd.svc.cluster.local
admin:
username: user
password: challenge77!!
```
```
모니터링의 자원 설정
```
```
Valut 서버 접속 설정
```
```
CI 서버 (Jenkins) 접속 설
정
```
```
# values.yml을 수정
```
```
$ vi /home/ansible/cicd/delivery-pipeline/cicd/script/values.yaml
```

pipeline **설치**

```
repository:
nexus:
url: https://k8s-nexus.spaasta.com
ip: 112.175.114.187
harbor:
api:
url: https://registry1.dev.sm-k8s.com/api/v2.0
admin:
username: admin
password: challenge77!!
```
```
config:
server:
url: http://config.mgmt.dev.egovp.kr
repo:
url: https://git.dev.kr/scm/git/config-repo
```
```
Nexus 및 Harbor
접속 설정
```
```
Config 서버 구성설정
(현재는 사용안함 )
```

pipeline **설치**

```
keycloak:
admin:
url: https://keycloak1.dev.sm-k8s.com/auth
username: keycloak
password: keycloak
oauth:
info:
url: https://keycloak1.dev.sm-k8s.com/auth/realms/eGovCP/protocol/openid-connect/userinfo
token:
check:
url: https://keycloak1.dev.sm-k8s.com/auth/realms/eGovCP/protocol/openid-connect/token/introspect
access:
url: https://keycloak1.dev.sm-k8s.com/auth/realms/eGovCP/protocol/openid-connect/token
logout:
url: https://keycloak1.dev.sm-k8s.com/auth/realms/eGovCP/protocol/openid-connect/logout
auth:
url: https://keycloak1.dev.sm-k8s.com/auth/realms/eGovCP/protocol/openid-connect/auth
pipeline:
client:
id: pipeclient
secret: 20fc443f- 9200 - 4060 - 9f53-e0f2cc7af58f
redirect:
scheme: https
used:
realms: eGovCP
```
```
Keycloak 구성설정
```

pipeline **설치**

```
database:
cicd:
url: jdbc:mysql://112.175.114.159:3306/K8S_CICD?characterEncoding=UTF-8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
username: root
password: Challenge77!!
driver: com.mysql.jdbc.Driver
broker:
url: jdbc:mysql://112.175.114.159:3306/K8S_BROKER?characterEncoding=UTF-8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
username: root
password: Challenge77!!
driver: com.mysql.jdbc.Driver
userportal:
url: jdbc:mysql://112.175.114.159:3306/K8S_USER?characterEncoding=UTF-8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
username: root
password: Challenge77!!
driver: com.mysql.jdbc.Driver
```
```
inspection:
server:
url: http://sonarqube.cicd.svc.cluster.local
admin:
username: user
password: challenge77!!
```
```
데이터베이스
접속정보
```
```
Sonarqube
접속정보
```

pipeline **설치**

```
pipeline:
api:
nameOverride: "pipeline-api"
fullnameOverride: ""
replicaCount: 1
image:
repository: registry1.dev.sm-k8s.com/delivery_pipeline/api-service
pullPolicy: IfNotPresent
tag: 0.12-debian- 10
imagePullSecrets: []
podAnnotations: {}
podSecurityContext: {}
securityContext: {}
# capabilities:
# drop:
# -ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000
serviceAccount:
# Specifies whether a service account should be create
create: true
annotations: {}
# The name of the service account to use.
# If not set and create is true, a name is generated using the fullname template
name: ""
service:
type: NodePort
port: 8082
httpsPort: 443
ingress:
enabled: false
className: ""
annotations: {}
# kubernetes.io/ingress.class: nginx
# kubernetes.io/tls-acme: "true"
#ingress.kubernetes.io/ssl-redirect: "false"
#ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/ssl-redirect: "false"
#nginx.ingress.kubernetes.io/proxy-body-size: "0"
```
```
#nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
tls:
# -secretName: chart-example-tls
# hosts:
# -chart-example.local
url: pipeline-api.default.svc.cluster.local
https:
enabled: false
```
```
resources:
# We usually recommend not to specify default resources and to leave this as a conscious
# choice for the user. This also increases chances charts run on environments with little
# resources, such as Minikube. If you do want to specify resources, uncomment the
following
# lines, adjust them as necessary, and remove the curly braces after 'resources:'.
limits:
cpu: 2
memory: 4Gi
requests:
cpu: 1
memory: 2Gi
autoscaling:
enabled: false
minReplicas: 1
maxReplicas: 100
targetCPUUtilizationPercentage: 80
# targetMemoryUtilizationPercentage: 80
nodeSelector: {}
tolerations: []
affinity: {}
log:
level: info
filename: /var/log/app/application.log
```
```
Pipeline API 구성설정
```

pipeline **설치**

```
#commonapi service
commonapi:
nameOverride: "pipeline-common-api"
fullnameOverride: ""
replicaCount: 1
image:
repository: registry1.dev.sm-k8s.com/delivery_pipeline/commonapi-service
pullPolicy: IfNotPresent
tag: 0.4-debian- 10
imagePullSecrets: []
podAnnotations: {}
podSecurityContext: {}
securityContext: {}
# capabilities:
# drop:
# -ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000
serviceAccount:
# Specifies whether a service account should be create
create: true
annotations: {}
# The name of the service account to use.
# If not set and create is true, a name is generated using the fullname template
name: ""
service:
type: NodePort
port: 8081
httpsPort: 443
ingress:
enabled: false
className: ""
annotations: {}
# kubernetes.io/ingress.class: nginx
# kubernetes.io/tls-acme: "true"
#ingress.kubernetes.io/ssl-redirect: "false"
#ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/ssl-redirect: "false"
#nginx.ingress.kubernetes.io/proxy-body-size: "0"
```
```
#nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
tls:
# -secretName: chart-example-tls
# hosts:
# -chart-example.local
url: pipeline-commonapi.default.svc.cluster.local
https:
enabled: false
resources:
# We usually recommend not to specify default resources and to leave this as a conscious
# choice for the user. This also increases chances charts run on environments with little
# resources, such as Minikube. If you do want to specify resources, uncomment the following
# lines, adjust them as necessary, and remove the curly braces after 'resources:'.
limits:
cpu: 2
memory: 4Gi
requests:
cpu: 1
memory: 2Gi
autoscaling:
enabled: false
minReplicas: 1
maxReplicas: 100
targetCPUUtilizationPercentage: 80
# targetMemoryUtilizationPercentage: 80
nodeSelector: {}
tolerations: []
affinity: {}
log:
level: info
filename: /var/log/app/application.log
```
```
Pipeline Common API
구성설정
```

pipeline **설치**

```
inspectionapi:
nameOverride: "pipeline-inspection-api"
fullnameOverride: ""
replicaCount: 1
image:
repository: registry1.dev.sm-k8s.com/delivery_pipeline/inspectionapi-service
pullPolicy: IfNotPresent
tag: 0.6-debian- 10
imagePullSecrets: []
podAnnotations: {}
podSecurityContext: {}
securityContext: {}
# capabilities:
# drop:
# -ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000
serviceAccount:
# Specifies whether a service account should be create
create: true
annotations: {}
# The name of the service account to use.
# If not set and create is true, a name is generated using the fullname template
name: ""
service:
type: NodePort
port: 8083
httpsPort: 443
ingress:
enabled: false
className: ""
annotations: {}
# kubernetes.io/ingress.class: nginx
# kubernetes.io/tls-acme: "true"
#ingress.kubernetes.io/ssl-redirect: "false"
#ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/ssl-redirect: "false"
#nginx.ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
```
```
tls:
# -secretName: chart-example-tls
# hosts:
# -chart-example.local
url: pipeline-inspectionapi.default.svc.cluster.local
https:
enabled: false
```
```
resources:
# We usually recommend not to specify default resources and to leave this as a conscious
# choice for the user. This also increases chances charts run on environments with little
# resources, such as Minikube. If you do want to specify resources, uncomment the
following
# lines, adjust them as necessary, and remove the curly braces after 'resources:'.
limits:
cpu: 2
memory: 4Gi
requests:
cpu: 1
memory: 2Gi
autoscaling:
enabled: false
minReplicas: 1
maxReplicas: 100
targetCPUUtilizationPercentage: 80
# targetMemoryUtilizationPercentage: 80
nodeSelector: {}
tolerations: []
affinity: {}
log:
level: info
filename: /var/log/app/application.log
```
```
Pipleline
Inspection API
```

pipeline **설치**

```
ui:
nameOverride: "pipeline-ui"
fullnameOverride: ""
replicaCount: 1
image:
repository: registry1.dev.sm-k8s.com/delivery_pipeline/ui-service
pullPolicy: IfNotPresent
tag: 0.24-debian- 10
imagePullSecrets: []
podAnnotations: {}
podSecurityContext: {}
securityContext: {}
# capabilities:
# drop:
# -ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000
serviceAccount:
# Specifies whether a service account should be create
create: true
annotations: {}
# The name of the service account to use.
# If not set and create is true, a name is generated using the fullname template
name: ""
service:
type: ClusterIP
port: 8084
httpsPort: 443
ingress:
enabled: true
className: ""
annotations:
nginx.ingress.kubernetes.io/proxy-redirect-from: http://
nginx.ingress.kubernetes.io/proxy-redirect-to: https://
```
```
tls:
# -secretName: chart-example-tls
# hosts:
# -chart-example.local
url: pipeline.dev.sm-k8s.com
https:
enabled: false
resources:
# We usually recommend not to specify default resources and to leave this as a conscious
# choice for the user. This also increases chances charts run on environments with little
# resources, such as Minikube. If you do want to specify resources, uncomment the following
# lines, adjust them as necessary, and remove the curly braces after 'resources:'.
limits:
cpu: 2
memory: 4Gi
requests:
cpu: 1
memory: 2Gi
autoscaling:
enabled: false
minReplicas: 1
maxReplicas: 100
targetCPUUtilizationPercentage: 80
# targetMemoryUtilizationPercentage: 80
nodeSelector: {}
tolerations: []
affinity: {}
joblog:
url: https://pipeline.dev.sm-
k8s.com/dashboard/{SERVICE_INSTANCE_ID}/pipelines/{PIPELINE_ID}/jobs/{JOB_ID}/{JOB_TYPE}
log:
level: info
filename: /var/log/app/application.log
```
```
Pipeline UI
구성설정
```

pipeline **설치**

```
broker:
nameOverride: "pipeline-broker"
fullnameOverride: ""
replicaCount: 1
image:
repository: registry1.dev.sm-k8s.com/delivery_pipeline/broker-service
pullPolicy: IfNotPresent
tag: 0.2-debian- 10
imagePullSecrets: []
podAnnotations: {}
podSecurityContext: {}
securityContext: {}
# capabilities:
# drop:
# -ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000
serviceAccount:
# Specifies whether a service account should be create
create: true
annotations: {}
# The name of the service account to use.
# If not set and create is true, a name is generated using the fullname template
name: ""
service:
type: ClusterIP
port: 8080
httpsPort: 443
ingress:
enabled: true
className: ""
annotations: {}
# kubernetes.io/ingress.class: nginx
# kubernetes.io/tls-acme: "true"
#ingress.kubernetes.io/ssl-redirect: "false"
#ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/ssl-redirect: "false"
#nginx.ingress.kubernetes.io/proxy-body-size: "0"
#nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
```
```
tls:
url: pipeline-broker.dev.sm-k8s.com
https:
enabled: false
resources:
limits:
cpu: 2
memory: 4Gi
requests:
cpu: 1
memory: 2Gi
autoscaling:
enabled: false
minReplicas: 1
maxReplicas: 100
targetCPUUtilizationPercentage: 80
# targetMemoryUtilizationPercentage: 80
nodeSelector: {}
tolerations: []
affinity: {}
dashboard:
url: https://pipeline.dev.sm-k8s.com/dashboard/[SUID]/
security:
user:
name: k8s
password: broker
basic:
auth:
token: azhzOmJyb2tlcg==
log:
level: info
filename: /var/log/app/application.log
```
```
Pipeline 서비스 브로커
구성설정
```

pipeline **설치**

```
# helm repo 추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/cicd/script
```
```
# harbor url주소를 확인한다.
```
```
$ vi install_pipeline.sh
```
```
$ sudochmod+xinstall_pipeline.sh
```
```
# sh파일을 실행
```
```
$ ./install_pipeline.sh
```

pipeline **설치**


pipeline **설치**

```
# jenkins-8.1.13.tgz 파일을 delivery_pipeline프로젝트의 helm_chart에 업로드
```

pipeline **설치**

```
# helm repo 추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/jenkins/HelmChart
```
```
# repo_add.sh 파일 내부의 harbor url을 확인한다.
```
```
$ vi repo_add.sh
```
```
$ sudochmod+x repo_add.sh
```
```
$ ./repo_add.sh
```

pipeline **설치**

```
# dockerimage 업로드
```
```
$ cd /home/ansible/cicd/delivery-pipeline/jenkins/DockerImages/delivery_pipeline
```
```
# 디렉토리 내부의 파일들을 모두 registry.sysmasterk8s.com에 업로드한다.
```
```
$ sudodockerload –I 파일명
```
```
$ sudodockertag <기존 이미지 경로 > <신규 이미지 경로 registry.sysmasterk8s.com/~~~~>
```
```
$ sudodockerpush <신규 이미지 경로 registry.sysmasterk8s.com/~~~~>
```

pipeline **설치**

```
# sonarqubehelm repo 추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/sonarqube/HelmCharts
```
```
$ vi repo_add.sh
```
```
$ sudochmod+x repo_add.sh
```
```
$ ./repo_add.sh
```

pipeline **설치**

```
# sonarqube이미지추가
```
```
$ cd /home/ansible/cicd/delivery-pipeline/sonarqube/dockerImages/delivery_pipeline
```
```
$ sudodockerload –I sonarqube_8.9.6.tar
```
```
$ sudodockertag registry1.dev.sm-k8s.com/delivery_pipeline/sonarqube:8.9.6
registry.sysmasterk8s.com/delivery_pipeline/sonarqube:8.9.6
```
```
$ sudodockerpush registry.sysmasterk8s.com/delivery_pipeline/sonarqube:8.9.6
```

pipeline **설치**

```
# Jenkins script 수정
```
```
$ cd /home/ansible/cicd/delivery-pipeline/jenkins/script
```
```
# 복사한 k8s_config 파일을 다음 파일에 저장
```
```
$ vi k8s_config
```
```
# install_jenkins.sh 파일 내부의 내용을 수정
```
```
$ vi install_jenkins.sh
```
```
# jenkins_host는 기존의 concourse에서 설치한 jenkins와 아무 관계가 없으므로 새로운 domain을 설정
```
```
# install_jenkins.sh 파일을 실행
```
```
$ ./install_jenkins.sh
```

rancherrabbitMQ

**설치**


rancher rabbitMQ **설치**

#### # 설치 준비

```
# Service Catalog, K8s Api디렉토리를 inception 서버의 ubuntu게정 download 디렉토리에 업로드한다.
```
```
$ cd /home/ubuntu/download/
```
```
$ sudomv Service Catalog
```
```
$ sudomv service_catalog/home/ansible/
```
```
$ sudosu–ansible
```
```
$ cd service_catalog
```

rancher rabbitMQ **설치**

```
# rancher rabbitMQ 이미지 업로드
```
```
$ sudodockerload –I rancher-rabbitmq-api.tar
```
```
$ sudodockertag registry1.dev.sm-k8s.com:443/rancher/rabbitmq-rancher:v0.20
registry.sysmasterk8s.com/rancher/rabbitmq-rancher:v0.20
```
```
$ sudodockerpush registry.sysmasterk8s.com/rancher/rabbitmq-rancher:v0.20
```

rancher rabbitMQ **설치**

```
# rancher secret name 변경
```
```
$ cd /home/ansible/service_catalog/Rancher-RabbitMQ-API
```
```
$ vi deployment.yml
```
```
### 기존의 ENV_RANCHER_TOKEN 을 ENV_RANCHER_AUTH으로 변경
```
```
name: ENV_RANCHER_TOKEN -> name: ENV_RANCHER_AUTH
```
```
###
```

rancher rabbitMQ **설치**

```
# rancher rabbitMQsecret 생성
# 현재 환경에 맞도록 수정한다.
```
```
$ kubectlcreate secret generic service-catalog \
--from-literal=vault_url=vault.sysmasterk8s.com \
--from-literal=vault_key=s.mkPq3vYfJUBJ35imE7ncc5hL \
--from-literal=rabbitmq_password=uocYoYvV2OSIGLiw8MJQ \
--from-literal=db_id=root \
--from-literal=db_pw=＇Challenge77!!＇\
--from-literal=db1=＂
jdbc:mariadb://183.111.127.218:3306/K8S_MONITORING?autoReconnect=true&useUnicode=true&charac
terEncoding=utf8&serverTimezone=Asia/Seoul＂\
--from-literal=db2=＂
jdbc:mariadb://183.111.127.218:3306/K8S_USER?autoReconnect=true&useUnicode=true&characterEnco
ding=utf8&serverTimezone=Asia/Seoul＂\
--from-literal=rancher_url=＇https://rancher.sysmasterk8s.com:7443＇\
--from-literal=rancher_endpoint=＇https://rancher.sysmasterk8s.com:7443/v3＇\
--from-literal=rancher_token=＂token-7ljjn:wv9g2f5nxjsf74frtkbdxc2djdggllcfkhwvl9ddgxsqnq6cltvvtc
＂\
--from-literal=baremetal_id=＂c-k7gm4＂\
--from-literal=baremetal_name=＂cluster＂\
--from-literal=crypto_key=SysMasterK8s2022SysMasterK8s2022 \
```
**- n portal-dev**


rancher rabbitMQ **설치**

```
# rancher rabbitMQ 설치
```
```
$ kubectlapply –f deployment.yaml
```
```
# 아래와 같이 secret 이 생성
# 오른쪽과 같이 rancher-rabbitmq-apipod 생성
```

servicecatalog

**설치**


service catalog **설치**

```
# harbor에 service catalog 프로젝트 생성
```

service catalog **설치**

```
# service catalog 이미지 업로드
```
```
$ cd /home/ansible/service_catalog/service_catalog
```
```
$ sudodockerload –I service-catalog.tar
```
```
$ sudodockertag registry1.dev.sm-k8s.com/service_catalog/service_catalog:v0.03
registry.sysmasterk8s.com/service_catalog/service_catalog:v0.03
```
```
$ sudodockerpush registry.sysmasterk8s.com/service_catalog/service_catalog:v0.03
```

service catalog **설치**

```
# service catalog secret 생성
# 현재 환경에 맞도록 수정
```
```
$ kubectlcreate secret generic service-catalog1 \
--from-literal=vault_url=vault.sysmasterk8s.com \
--from-literal=vault_key=s.mkPq3vYfJUBJ35imE7ncc5hL \
--from-literal=rabbitmq_password=uocYoYvV2OSIGLiw8MJQ \
--from-literal=db_id=root \
--from-literal=db_pw='Challenge77!!' \
--from-
literal=db1="jdbc:mariadb://183.111.127.218:3306/K8S_CATALOG?autoReconnect=true&useUnicode=tru
e&characterEncoding=utf8&serverTimezone=Asia/Seoul" \
--from-
literal=db2="jdbc:mariadb://183.111.127.218:3306/K8S_IAAS?autoReconnect=true&useUnicode=true&ch
aracterEncoding=utf8&serverTimezone=Asia/Seoul" \
```
**- n portal-dev**


service catalog **설치**

```
# service catalog 배포
```
```
$ kubectlapply -f deployment.yaml
```

service catalog **설치**

```
# service catalog 설치
```
```
$ kubectlapply –f deployment.yaml
```
```
# 아래와 같이 secret이 생성
# 오른쪽과 같이 service-catalog pod 생성
```

monitoring **설치**


monitoring **설치**

```
# monitoring 설치 준비
# 모니터링 디렉토리를 inceptio서버의 ubuntu계정 download 디렉토리에 업로드 한다.
```
```
$ cd /home/ubuntu/download
```
```
$ sudocpmonitoring /home/ansible/
```

monitoring **설치**

```
# monitoring 설치 준비
# harbor에 monitoring 프로젝트를 생성
```

monitoring **설치**

```
# monitoring 설치 준비
# image 디렉토리 내부의 이미지파일들을 모두 harbor에 업로드
```
```
$ sudodockerload –I <파일명>
```
```
$ sudodockertag <이전 이미지 주소> <신규 이미지 주소>
```
```
$ sudodockerpush <신규 이미지 주소>
```
```
# monitoring 프로젝트에 6 개
# rancher 프로젝트에 2 개가 업로드 된다.
```

monitoring **설치**

```
# monitoring 설치 준비
# configmap디렉토리의 kube.conf파일에 ranche의 k8s-config 내용을 복사하여 넣는다.
```
```
$ vi /home/ansible/monitroing/script/configMap/kube.conf
```

monitoring **설치**

```
# monitoring 설치 준비
# 파일의 내용을 현재 환경에 맞게 수정
$ vi /home/ansible/monitroing/script/configMap/alarmd.properties
mois.alarm.mail.service.class=com.infranics.mois.alarm.dispatcher.action.SimpleSMTP
mois.alarm.sms.service.class=com.infranics.mois.alarm.dispatcher.action.Simple는
```
```
mois.alarm.email.smtp.host=mail.infranics.com
mois.alarm.email.smtp.port=25
mois.alarm.email.smtp.auth=Y
mois.alarm.email.smtp.username=kkjslee
mois.alarm.email.smtp.password=k8s77!!
mois.alarm.email.smtp.charset.name=UTF- 8
mois.alarm.email.smtp.ssl.enable=N
mois.alarm.email.smtp.starttls.enable=Y
mois.alarm.email.smtp.debug=Y
mois.alarm.email.from.name=infranics
mois.alarm.email.from.email=admin@infranics.com
```
```
mois.alarm.sms.sender=557696
mois.alarm.mattermost.url=http://183.111.127.241
mois.alarm.mattermost.login.id=admin
mois.alarm.mattermost.password=Sysmaster77
```
```
mois.alarm.rabbitmq.server.url=http://monitoring-alarm-rabbitmq-
svc.monitoring.svc.cluster.local:8080
```
```
메일서버 설정
```
```
Mettermost설정
```
```
Monitoring Rabbitmq
URL설정 (변경필요없음)
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/configMap/application.yml
spring:
primary:
datasource:
driver-class-name: com.mysql.jdbc.Driver
jdbc-url: jdbc:mysql://112.175.114.159:3306/K8S_MONITORING?characterEncoding=UTF-
8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
username: root
password: 'Challenge77!!‘
test-on-borrow: true
validation-query: select 1
hikari:
maximum-pool-size: 10
secondary:
datasource:
driver-class-name: com.mysql.jdbc.Driver
jdbc-url: jdbc:mysql://112.175.114.159:3306/K8S_ADMIN?characterEncoding=UTF-
8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
username: root
password: 'Challenge77!!‘
test-on-borrow: true
validation-query: select 1
hikari:
maximum-pool-size: 10
cloud:
vault:
host: vault1.dev.sm-k8s.com
port: 80
scheme: http
authentication: TOKEN
token: s.q8NZepILgCSSAImM8EgA1V6E
portal: path: 'secret/data/dev/portal/user'
```
```
monitoringDB설정
```
```
AdminPortalDB설정
```
```
Vault 설정
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/monitoring-api/monitoring-api.yml
```
```
spec:
containers:
```
- name: monitoring-api
    image: registry1.dev.sm-k8s.com:443/egov_platform_portal/sysmasterk8smonitoringapi:monitoring-v1.6

```
env:
```
- name: SPRING_DATASOURCE_URL
    value: jdbc:mysql://112.175.114.159:3306/K8S_MONITORING?characterEncoding=UTF-
8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
- name: SPRING_DATASOURCE_USERNAME
value: root
- name: SPRING_DATASOURCE_PASSWORD
value: Challenge77!!
- name: ELASTICSEARCH_ENDPOINT_HOSTNAME
value: 183.111.127.246
- name: ELASTICSEARCH_ENDPOINT_PORT
value: '9200‘
- name: ELASTICSEARCH_ENDPOINT_SCHEME
value: http
- name: PROMETHEUS_ENDPOINT_URL
    value: https://k8s.console.dev.sm-k8s.com/k8s/clusters/{clusterId}/api/v1/namespaces/cattle-prometheus/services/access-prometheus:80/proxy
- name: PROMETHEUS_ENDPOINT_USERNAME
    value: token-kw9cr (token의 access key )
- name: PROMETHEUS_ENDPOINT_PASSWORD
    value: plhb2rpjjlhnxl6xz6v8pq99zk248qzbfzbnc9mltbxxdgx69kh6kd (token의 secret key )

```
Api이미지
```
```
Monitoring DB
접속정보
```
```
username과 endpoint password는
rancher의api&key에서 만든 token의
access key와 secret key를 넣는다.
```
```
haproxyip접속정보
```

monitoring **설치**

```
# 파일의 내용을 현재 환경에 맞게 수정
$ vi /home/ansible/monitroing/script/collector/monitoring-collector.yml
spec:
containers:
```
- name: monitoring-collector
    image: registry1.dev.sm-k8s.com:443/egov_platform_portal/sysmasterk8scollector:monitoring-v1.0

```
env:
```
- name: SPRING_PRIMARY_DATASOURCE_JDBC-URL
    value: jdbc:mysql://112.175.114.159:3306/K8S_MONITORING?characterEncoding=UTF-8&sessionVariables=tx_isolation='READ-COMMITTED'
- name: SPRING_PRIMARY_DATASOURCE_USERNAME
    value: root
- name: SPRING_PRIMARY_DATASOURCE_PASSWORD
    value: Challenge77!!
- name: SPRING_SECONDARY_DATASOURCE_JDBC-URL
    value: jdbc:mysql://112.175.114.159:3306/K8S_ADMIN?characterEncoding=UTF-8&sessionVariables=tx_isolation='READ-COMMITTED'
- name: SPRING_SECONDARY_DATASOURCE_USERNAME
    value: root
- name: SPRING_SECONDARY_DATASOURCE_PASSWORD
    value: Challenge77!!
- name: SPRING_CLOUD_VAULT_HOST
    value: vault.vault.svc.cluster.local
- name: SPRING_CLOUD_VAULT_PORT
    value: "8200"
- name: SPRING_CLOUD_VAULT_TOKEN
    value: s.q8NZepILgCSSAImM8EgA1V6E
- name: SPRING_CLOUD_VAULT_K8S_PATH
    value: secret/data/dev/k8s/{project_id}/kubeconfig
- name: SPRING_CLOUD_RANCHER_API_URL
    value: https://k8s.console.dev.sm-k8s.com
- name: SPRING_CLOUD_RANCHER_API_AUTHORIZATION
    value: Basic dG9rZW4ta3c5Y3I6cGxoYjJycGpqbGhueGw2eHo2djhwcTk5emsyNDhxemJmemJuYzltbHRieHhkZ3g2OWtoNmtk
    (rancher token의 Bearer Token을 base 64 명령어로 변경해서 넣는다. $ echo -n ‘token-7ljjn: ~~~~~’ | base64 )
- name: SPRING_CLOUD_WEBHOOK_API_URL
    value: [http://112.175.114.184:32699](http://112.175.114.184:32699)

```
monitoring-collector
이미지 정보
```
```
Monitoring DB 정보
```
```
Admin Portal DB 정보
```
```
Vault 정보
```
```
Rancher API 정보
```
```
WebhookPod Cluster
외부 URL:32699
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/webhook/monitoring-webhook.yml
```
```
spec:
containers:
```
- name: monitoring-webhook
    image: registry1.dev.sm-k8s.com:443/egov_platform_portal/sysmasterk8swebhook:monitoring-v1.0

```
env:
```
- name: SPRING_DATASOURCE_URL
    value: jdbc:mysql://112.175.114.159:3306/K8S_MONITORING?characterEncoding=UTF-
8&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
- name: SPRING_DATASOURCE_USERNAME
value: root
- name: SPRING_DATASOURCE_PASSWORD
value: Challenge77!!
- name: OPENDISTRO_API_URL
value: [http://183.111.127.246:9200](http://183.111.127.246:9200)
- name: API_VM_IP
value: 112.175.114.184:32699
---
apiVersion: v1
kind: Service
metadata:
name: monitoring-webhook-svc
namespace: monitoring
spec:
selector:
app: monitoring-webhook
type: NodePort
ports:
- protocol: TCP
port: 8300
targetPort: 8300
nodePort: 32699

```
monitoring-webhook
Monitoring DB 정보 이미지^ 정보
```
```
OpenSearch API URL(로
그주소 대현프로 )
```
```
자기자신 서비스 URL
IP:NodePort
```
```
Node Port 정보
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/alarm-rabbitmq/alarm-rabbitmq.yml
```
```
spec:
containers:
```
- name: monitoring-alarm-rabbitmq
    image: registry1.dev.sm-k8s.com:443/egov_platform_portal/sysmasterk8smonitoringrabbitmq:monitoring-v0.3
    ports:
       - containerPort: 8080
    resources:
       limits:
          cpu: “0.5”
          memory: 1Gi
       requests:
          cpu: "0.25"
          memory: 0.5Gi
    env:
    - name: SPRING_RABBITMQ_HOST
       value: portal-rabbitmq-ha.portal-dev.svc.cluster.local
    - name: SPRING_RABBITMQ_PORT
       value: "5672"
    - name: SPRING_RABBITMQ_USER
       value: admin
    - name: SPRING_RABBITMQ_PASSWORD
       value: uocYoYvV2OSIGLiw8MJQ

```
Alarm-rabbitmq
이미지 정보
```
```
포탈 Rabbitmq정보
(변경 필요 없음)
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/prometheus-collecotor/prometheus-collector.yaml
```
```
spec:
containers:
```
- name: prometheus-collector-platform
    image: registry1.dev.sm-k8s.com/rancher/prometheus-collect-platform:1.02
resources:
    limits:
       cpu: "0.5"
       memory: 1Gi
    requests:
       cpu: "0.25"
       memory: 0.5Gi
    env:
    - name: SPRING_DATASOURCE_URL
    value: jdbc:mysql://112.175.114.159:3306/K8S_MONITORING?autoReconnect=true&useUnicode=true&characterEncoding=utf-
8&serverTimezone=Asia/Seoul&useLegacyDatetimeCode=false
- name: SPRING_DATASOURCE_USERNAME
value: root
- name: SPRING_DATASOURCE_PASSWORD
value: Challenge77!!
- name: CLUSTER_ID
value: c-f2kgc(플랫폼 CluserID) -> Rancher Cluster UI 참조
- name: RANCHER_CLUSTER_URL
value: https://k8s.console.dev.sm-k8s.com
- name: RANCHER_CLUSTER_TOKEN
value: token-kw9cr:plhb2rpjjlhnxl6xz6v8pq99zk248qzbfzbnc9mltbxxdgx69kh6kd

```
Prometheus collector
이미지 정보
```
```
MontioringDB 정보
```
```
Rancher 정보
```
```
플랫폼 Cluster ID정보
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/prometheus-add-grafana/grafana-add-prometheus.yaml
```
```
spec:
containers:
```
- name: prometheus-add-grafana-admin
    image: registry.systeer.com/rancher/prometheus-add-grafana:1.21
    resources:
       limits:
          cpu: "0.5"
          memory: 1Gi
       requests:
          cpu: "0.25"
          memory: 0.5Gi
    env:
    - name: rancher_url
       value: https://k8s.console.dev.egovp.kr
    - name: rancher_token
       value: R_SESS=token-dpb49:ksgj2r8hsbzwd88xmzx49n8dwt4kxm89b69sbh2d9q92hfxkdm9nwp
    - name: grafana_token
       value: eyJrIjoiTmlLODcyNnY2ancwTzg0Z0pRa3hXVmNONjBEQkVQWXUiLCJuIjoicmFuY2hlciIsImlkIjoxfQ==
    - name: grafana_host
       value: grafana.monitoring.svc.cluster.local
    - name: grafana_protocol
       value: http
    - name: grafana_port
       value: "3001"

```
Prometheus collector
이미지 정보
```
```
Rancher 정보
```
```
Monitoring Grafana정
보
```

monitoring **설치**

#### # 파일의 내용을 현재 환경에 맞게 수정

```
$ vi /home/ansible/monitroing/script/grafana/grafana.yml
```
```
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
name: grafana-pvc
namespace: monitoring
spec:
storageClassName: ceph-rbd-sc
accessModes:
```
- ReadWriteOnce
resources:
requests:
storage: 1Gi
---
spec:
containers:
- name: grafana
image: registry1.dev.sm-k8s.com:443/egov_platform_portal/sysmasterk8sgrafana:monitoring-v0.2
env:
- name: GF_SERVER_ROOT_URL
value: https://dashboard.dev.sm-k8s.com/grafana
- name: GF_SERVER_SERVE_FROM_SUB_PATH
value: 'true‘
- name: GF_AUTH_ANONYMOUS_ENABLED
value: 'true‘
- name: GF_SECURITY_ALLOW_EMBEDDING //이하 생략....
imagePullSecrets:
- name: regcred
volumes:
- name: grafana-pvc
persistentVolumeClaim:
claimName: grafana-pvc

```
grafana
GrafanaURL 이미지 정보
```
```
GrafanaVoulum
```
```
GrafanaVoulum
```

monitoring **설치**

```
# monitoring 설치 준비
# keycloak에 monitclient추가
```
#### # 그림과 같이 설정

```
enabled : on
client protocol : openid-connect
access type : confidential
standard folwenabled : on
direct access grants enabled : on
service accounts enabled : on
authorization enabled : on
```

monitoring **설치**

```
# monitoring 설치 준비
# keycloak에 monitclient추가
```
#### # 그림과 같이 설정

```
valid refirecturls: https://dashboard-admin.sysmasterk8s.com/*
web origins : * # add
https://dashboard-admin.sysmasterk8s.com/* #add
```

monitoring **설치**

```
# monitoring 설치 준비
# monitclient scopes에 read 추가
```

monitoring **설치**

```
# monitoring 설치 준비
# monitclient roles에 ADMIN, USER 추가
```

monitoring **설치**

```
# monitoring 설치 준비
# monit client 의 credentials에서 secret을 확인
```

monitoring **설치**

```
# monitoring 설치 준비
# credentials에서 secret을 다음 파일에 입력
```
```
$ vi /home/ansible/platform_configs/configs/portal/SysMasterK8sMonitoringApp.yml
```
```
# 해당 파일의 url에 도메인과 realm 이름도 변경해줍니다.
# 변경이후 gitpush
```

monitoring **설치**

```
# monitoring 설치 준비
# rancher default 프로젝트에 monitoring namespace 추가
```

monitoring **설치**

```
# monitoring 설치
# config-map 추가
```
```
$ cd /home/ansible/monitroing/script/configMap
```
```
$ ./create-config.sh
```

monitoring **설치**

```
# monitoring 설치
```
```
$ cd prometheus-collecotor/
```
```
$ kubectlcreate configmapprometheus-collector-configmap--from-file bootstrap.yml-n monitoring
$ kubectlcreate -f prometheus-collector.yaml
```
```
$ cd /home/ansible/monitroing/script
```
```
$ kubectlcreate -f alarm-rabbitmq/alarm-rabbitmq.yml
$ kubectlcreate -f collector/monitoring-collector.yml
$ kubectlcreate -f grafana/grafana.yml
$ kubectlcreate -f monitoring-alarm/monitoring-alarm.yml
$ kubectlcreate -f monitoring-api/monitoring-api.yml
$ kubectlcreate -f prometheus-add-grafana/grafana-add-prometheus.yaml
$ kubectlcreate -f webhook/monitoring-webhook.yml
```

monitoring **설치 결과**

```
# monitoring 설치 결과 - workload
```

monitoring **설치 결과**

```
# monitoring 설치 결과 - service
```

monitoring **설치 결과**

```
# monitoring 설치 결과 - loadbalancing
```

monitoring **설치 결과**

```
# monitoring 설치 결과
```
```
브라우저에서 http://dashboard.sysmasterk8s.com/garafana접속시 다음 화면이 출력
```

monitoring **설치 결과**

```
# monitoring grafanaMoisRDB설정
```

clustermonitoring

**설정**


cluster monitoring **설정**

```
# cluster monitoring 설정
```
```
rancher ui에서 다음의 설정을 진행한다.
```

cluster monitoring **설정**

```
# cluster monitoring 설정
```
```
#rancher ui에서 다음의 설정을 진행한다.
```
```
# 반드시 모니터링 버전을 0.1.4로 변경한다.
```

cluster monitoring **설정**

```
# cluster monitoring 설정
#rancher ui에서 다음의 설정을 진행한다.
enable persistent storage on Prometheus : on
default storageclassfor Prometheus : ceph-rbd-sc
# 나머지 limit 등도 2 배씩 올려서 적용한다.
```

cluster monitoring **설정**

```
# cluster monitoring 설정
```
```
#rancher ui에서 다음의 설정을 진행한다.
```
```
enable persistent storage for grafana: true
default storageclassfor grafana: ceph-rbd-sc
```

cluster monitoring **설정**

```
# cluster monitoring 설정
```
```
위의 설정을 완료하고 확인버튼을 클릭하면 system 프로젝트에 다음의 pod가 생성된다.
```

cluster monitoring **결과**

```
# cluster monitoring 설정
```
```
# 설정이 완료되면 다음과 같이 현재 사용 중인 성능이 표시된다.
```

inception **서버에**

c-advisor **설치**


c-advisor **설치**

```
# inception server에 c-advisor 설치
```
```
# inception serve에c-advisor.tar 파일을 업로드 후 다음 명령어를 실행한다.
```
```
$ sudodockerload –I c-advisor.tar
```
```
$ sudodockerpush registry.sysmasterk8s.com/rancher/cadvisor:v0.36.0
```
```
$ sudodockerrun --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --
volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8088:8080 --
detach=true --name=cadvisorregistry.sysmasterk8s.com/rancher/cadvisor:v0.36.0
```
```
$ sudodockerps
```

c-advisor **설치**

```
# inception server에 c-advisor 설치
```
```
# 브라우저에서 다음 url을 접속한다.
```
```
http://inceptionip:8088/containers/docker
```

c-advisor **설치**

```
# inception server에 c-advisor 설치
```
```
# 컨테이너를 클릭하면 다음 화면이 출력된다.
```

c-advisor **설치**

```
# rancher에서 다음 정보를 변경
```
```
# Cluster => System Project => Resources => Secrets => cattle-Prometheus Namespace의
prometheus-cluster-monitoring-additional-scrape-configs수정
```

c-advisor **설치**

```
# Secret 수정
```
# Prometheus가 가져오려고 하는 정보를 추가

**# 아래 내용을 복사하여 붙여넣을 경우 secret이 깨지는 문제가 발생할 수 있으니 수동으로 입력**

# inception ip로 변경

#### ###

- job_name: 'docker-cadvisor'

```
static_configs:
```
- targets: ['183.111.127.245:8088']

```
###
```

c-advisor **설치**

```
# Prometheus exporter import 확인
```
```
# rancher에 로그인 한상태에서 도메인과 클러스터 id를 변경하고 브라우저로 접속하면 Prometheus 화면이 출
력된다.
```
```
https://rancher.sysmasterk8s.com:7443/k8s/clusters/c-k7gm4/api/v1/namespaces/cattle-
prometheus/services/access-prometheus:80/proxy
```
```
# statu의 service discovery를 클릭
```

c-advisor **설치**

```
# Prometheus exporter import 확인
```
```
# docker-cadvisor를 확인할 수 있다.
```

nodeexporter **설정**


node-exporter **설치**

```
# node-exporter 설치
```
```
node-exporter 파일을 bm-ceph-cluster- 1 에 scp로 복사한다.
```
```
bm-inceptio에서
```
```
$ scpnode-exporter node_exporter_exec.sh ceph-admin@bm-ceph-cluster-1:~/
```
```
$ sshceph-admin@bm-ceph-cluster- 1
```
```
$ sudochmod+x node-exporter
$ sudochmod+x node-exporter_exec.sh
```
```
$ ls -al
```

node-exporter **설치**

```
# node-exporter 설치
```
```
# bm-ceph-cluster- 1 에서 node exporter 실행
```
```
$ ./node-exporter_exec.sh
```
```
# node exporter 와 cephprometheus실행 확인
```
```
$ sudonetstat–ntlp
```
```
# 9283 port
# 9100 port
```

c-advisor **설치**

```
# rancher에서 다음 정보를 변경
```
```
# Cluster => System Project => Resources => Secrets => cattle-Prometheus Namespace의
prometheus-cluster-monitoring-additional-scrape-configs수정
```

node exporter **설치**

```
# Secret 수정
```
# Prometheus가 가져오려고 하는 정보를 추가

**# 아래 내용을 복사하여 붙여넣을 경우 secret이 깨지는 문제가 발생할 수 있으니 수동으로 입력**

# inception ip로 변경

#### ###

- job_name: 'ceph-node-exporter'

```
static_configs:
```
- targets: ['183.111.127.213:9100']
- job_name: 'ceph-exporter'
static_configs:
- targets: ['183.111.127.213:9283']

```
###
```

node-exporter **설치 확인**

```
# ceph데이터 수집 확인
```
```
# rancher에 접속한 상태에서 브라우저로 다음 url에 접속한다.
```
```
https://dashboard.sysmasterk8s.com/grafana
```

node-exporter **설치 확인**

```
# ceph데이터 수집 확인
```

clustermonitoring

**설정**


cluster monitoring **설정**

```
# vault 에 다음을 추가
```
```
# /dev/k8s/ 00000000 - 0000 - 0000 - 0000 - 000000000001/kubeconfig
```
```
# kubeconf= cluster의 kubeconfig를 복사하여 입력
```

cluster monitoring **설정**

```
# mysql db데이터 삭제
```
```
# inception node에서 mysql 접속
```
```
$ mysql–u root –p
(비밀번호)
```
```
$ use K8S_MONITORING
```
```
$ show tables;
```
```
$ select * from TMDP_K8S_CLUSTER;
```
```
$ truncate table TMDP_K8S_CLUSTER;
```

loggingservice


logging service **설치**

```
# logging.tar 파일 업로드 및 ansiblehome 디렉토리로 이동
```
```
$ cd download
```
```
$ sudocplogging.tar /home/ansible/
```
```
$ sudosu–ansible
```
```
$ tar xvflogging.tar
```
```
$ cd logging
```
```
$ ls –al
```

logging service **설치**

```
# harbor에 logging 프로젝트 생성
```

logging service **설치**

```
# harbor에 image 업로드
```
```
$ sudodockerload -i [이미지 파일 명]
```
```
$ sudodockertag [기존 이미지 명] [신규 이미지 명]
```
```
$ sudodockerpush [신규 이미지 명]
```
```
# 혹은 docker_push.sh 파일의 내부 domain을 변경후 실행해줍니다.
```
```
./docker_push.sh
```

logging service **설치**

```
# harbor에 helm chart 업로드
```
```
# tar 파일 내부의 chart 디렉토리에 있는 파일들을 logging –helm chart 에 업로드합니다.
```

logging service **설치**

```
# helm repo 등록
# harbor id / pw를 등록해야합니다.
# 등록시 – (대시) 가 정상적으로 안들어가니 복사하지 말고 직접 타이핑하시길 바랍니다.
```
```
$ helm repo add --username 'admin' --password 'challenge77!!' logging
https://registry.sysmasterk8s.com:9443/chartrepo/logging
```

logging service **설치**

```
# namespace 생성
# default project에 logging namespace를 생성합니다.
```

logging service **설치**

```
# 설치 yml수정
```
```
# kafka_helm.yml내부에 이미지 경로 명(2개)과 클러스터 external ip(2개) 를 변경해줍니다.
```
```
# 클러스터 공인 ip는 클러스터 node의 사설 ip를 입력합니다.
```

logging service **설치**

```
# 설치 yml수정
```
```
# kafka_helm.yml내부에 이미지 경로 명(2개)과 클러스터 external ip(2개) 를 변경해줍니다.
```
```
# 클러스터 공인 ip는 클러스터 node의 사설 ip를 입력합니다.
```

logging service **설치**

```
# 설치 yml수정
```
```
# 다른 설치 yml의 이미지 경로명을 수정합니다.
```
```
$ vi logstash_helm.yml
$ vi logstash-shipper_helm.yml
$ vi minio_helm.yml
$ vi opensearch-dashboard_helm.yml
$ vi opensearch_helm.yml
```
```
# 아래 예제와 같이 repository 부분의 domain을 변경해줍니다.
```

logging service **설치**

```
# helm 설치
```
```
# 아래 명령어를 사용하여 helm으로 logging namespace에 설치를 진행합니다.
```
```
# 아래 명령어를 복사할 경우 – (대시) 가 정상적으로 복사 안될 수 있으니 직접 타이핑하시길 바랍니다.
```
```
Kafka -> $ helm install kafka- 01 - f kafka.yamllogging/kafka-n logging
```
```
Opensearch-> $ helm install opensearch- 01 - f opensearch.yamllogging/opensearch-n logging
```
```
Opensearch-Dashboards -> $ helm install opensearch-dashboards- 01 - f opensearch-dashboards.yaml
logging/opensearch-dashboards -n logging
```
```
Logstash-Indexer -> $ helm install logstash- 01 - f logstash_indexer.yamllogging/logstash-n logging
```
```
Logstash-Shipper -> $ helm install logstash- 01 - f logstash_shipper.yamllogging/logstash-n logging
```
```
Minio-> $ helm install minio- 01 - f minio.yamllogging/minio-n logging
```

logging service **설치**

```
# opensearch-dashboards의 컨테이너에 다음 명령어를 입력합니다.
```

logging service **설치**

```
# opensearch-dashboards의 컨테이너에 다음 명령어를 입력합니다.
```
```
$ curl -u admin:admin-X POST "localhost:5 6 01/api/saved_objects/_import?overwrite=true" - H "osd-xsrf:
true" --form file=@/usr/share/opensearch-dashboards/config/export.ndjson
```

logging service **설치**

```
# opensearch-dashboards의 ingress 를 생성해줍니다.
# load balancing에서 add-ingress를 클릭하여 새로운 ingress를 등록한다.
# namespace –logging
# rules에 specifta hostname to use 선택
# request host에 사용할 도메인 입력
```

logging service **설치**

```
# 기존의 workload를 삭제하고 service로 등록합니다.
# path -/
# target –opensearch-dashboard를 선택
# port – 5601 선택
```

logging service **설치 결과**

```
# workloads
```

logging service **설치 결과**

```
# services
```

logging service **설치 결과**

```
# ingress
```

logging service **설치 결과**

```
# volumes
```

logging service **설치 결과**

```
# configmap
```

loggingservice

**등록**


logging service **설정**

```
# cluster -system project –설정 – 로깅에서 kafka를 선택합니다.
```

logging service **설정**

```
# kafkaconfiguration에서 broke를 선택하고 다음의 3 개를 추가합니다.
# 노드 ip: 30092
# 노드 ip: 30093
# 노드 ip: 30094
```

logging service **설정**

```
# topic에 k8s-kafka-클러스터네임을 입력합니다.
# 마지막에 있는 enable jsonparsing을 선택하고 저장합니다.
```

logging service **설정**

```
# system project 에 앱 항목에서 설치가 되는 것을 확인할 수 있습니다.
```

logging service **확인**

```
# 앞에서 load balancer에 등록한 도메인으로 접속합니다.
# 햄버거 버튼에서 discover를 선택하면 로그가 들어오는 것을 확인할 수 있습니다.
```

filebeat **설치**


filebeat **설치**

```
# configmap
```

backendservice


backend **서비스 설치**

```
# catalog 네임스페이스 생성
```
```
# default 에다음 2 개의 네임스페이스를 생성합니다.
```
```
# catalog, helm-broker
```

backend **서비스 설치**

```
# dockerimage 를 harbor에 업로드
# 다음의 7 개의 파일들을 모두 harbor에 업로드 한다.
```
```
etcd-tls-setup_0.3.3 6 7.tar.gz
helm-broker_etcd_v3.3.9.tar.gz
helm-broker-webhook_0.8.tar.gz
service-catalog_v0.3.1.tar.gz
helm-broker.tar.gz
helm-broker-tools.tar.gz
helm-broker-webhook_0.8.tar.gz
```
```
<예제>
$ sudodockerload –I catalog-0.3.1.tgz
```
```
$ sudodockertag k8s-nexus.spaasta.com:8083/kubernetes-service-catalog/service-catalog:v0.3.1
registry.sys-cafe.com/kubernetes-service-catalog/service-catalog:v0.3.1
```
```
$ sudodockerpush registry.sys-cafe.com/kubernetes-service-catalog/service-catalog:v0.3.1
```

backend **서비스 설치**

```
# chart를 사용하여 catalog 설치
```
```
$ cd /home/ansible/helm-broker
```
```
$ tar zxvfcatalog-0.3.1.tgz
```
```
$ cd catalog
```
```
$ vi values.yaml
```
```
### image를 저장한 harbor 경로 변경
```
```
image: registry.sys-cafe.com/kubernetes-service-catalog/service-catalog:v0.3.1
```
```
###
```
```
# 변경이후 다음의 명령어로 설치
```
```
$ helm install catalog --namespace catalog. -f values.yaml\
```

backend **서비스 설치**

```
# chart를 사용하여 helm-broker 설치
```
```
$ tar xvf helm-broker-0.1.0.tgz
```
```
$ cd helm-broker
```
```
$ helm install helm-broker --namespace helm-broker. -f values.yaml\
--set global.containerRegistry.path="registry.sys-cafe.com/" \
--set global.helm_broker.dir="helm-broker/" \
--set global.helm_broker.version=0.8 \
--set global.helm_controller.dir="helm-broker/" \
--set global.helm_controller.version=0.8 \
--set webhook.image="registry.sys-cafe.com/helm-broker/helm-broker-webhook:0.8" \
--set etcd-stateful.etcd.image="registry.sys-cafe.com/helm-broker/etcd" \
--set etcd-stateful.etcd.imageTag="v3.3.9" \
--set etcd-stateful.tlsSetup.image="registry.sys-cafe.com/helm-broker/etcd-tls-setup" \
--set etcd-stateful.tlsSetup.imageTag="0.3.3 67 " \
--set imageRegistry="registry.sys-cafe.com"
```

backend **서비스 설치**

# helm-broker redisservice addons설치

```
$ vi redis-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: redis-cfg
spec:
repositories:
```
- url: "https://nexus.sysmasterk8s.com/repository/downloads/addons/redis-0.1.0/index-redis.yaml"

```
###
```
```
$ kubectlcreate –f redis-cluster-addons-nexus.yaml
```

backend **서비스 설치**

helm-broker mariadbservice addons설치

```
$ vi mariadb-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: mariadb-cfg
spec:
repositories:
```
- url: "https://nexus.sysmasterk8s.com/repository/downloads/addons/mariadb-0.1.0/index-mariadb.yaml"
###

```
$ kubectlcreate –f mariadb-cluster-addons-nexus.yaml
```

backend **서비스 설치**

helm-broker postgresql service addons설치

```
$ vi postgresql-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: postgresql-cfg
spec:
repositories:
```
- url: https://nexus.sysmasterk8s.com/repository/downloads/addons/postgresql-0.1.0/index-
postgresql.yaml

```
###
```
```
$ kubectlcreate –f postgresql-cluster-addons-nexus.yaml
```

backend **서비스 설치**

helm-broker rabbitmqservice addons설치

```
$ vi rabbitmq-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: rabbitmq-cfg
spec:
repositories:
```
- url: https://nexus.sysmasterk8s.com/repository/downloads/addons/rabbitmq-0.1.0/index-
rabbitmq.yaml

```
###
```
```
$ kubectlcreate –f rabbitmq-cluster-addons-nexus.yaml
```

backend **서비스 설치**

helm-broker jenkins service addons설치

```
$ vi jenkins-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: jenkins-cfg
spec:
repositories:
```
- url: https://nexus.sysmasterk8s.com/repository/downloads/addons/jenkins-0.1.0/index-jenkins.yaml

```
###
```
```
$ kubectlcreate –f jenkins-cluster-addons-nexus.yaml
```

backend **서비스 설치**

helm-broker kafkaservice addons설치

```
$ vi kafka-cluster-addons-nexus.yaml
```
```
###
```
```
apiVersion: addons.kyma-project.io/v1alpha1
kind: ClusterAddonsConfiguration
metadata:
name: kafka-cfg
spec:
repositories:
```
- url: https://nexus.sysmasterk8s.com/repository/downloads/addons/kafka-0.1.0/index-kafka.yaml

```
###
```
```
$ kubectlcreate –f kafka-cluster-addons-nexus.yaml
```

