## To reproduce:

#### Setup Huawei FusionStage Kubernetes Cluster

Deploy Huawei FusionStage Kubernetes Cluster according to the FusionStage [Installation Guide](https://support.huawei.com/carrier/docview?nid=DOC1100813443&path=PBI1-21262245/PBI1-21435125/PBI1-21435910/PBI1-22892300/PBI1-251091346&detailId=PBI1-252220093) documentation with following steps:

- Download `NFV_FusionStage-21.3.RC1-X86_64.zip` from our [Official website](https://support.huawei.com/carrier/navi?coltype=software#col=software&from=product&detailId=PBI1-252220093&path=PBI1-21262245/PBI1-21435125/PBI1-21435910/PBI1-22892300/PBI1-251091346).


- Unzip NFV_FusionStage-21.3.RC1-X86_64.zip
```bash
  $ su - install
  $ cd /var/install
  $ unzip NFV_FusionStage-21.3.RC1-X86_64.zip
  $ unzip -d FusionStage_CCE packages/fsadmin_*_X86_64.zip
```

- Unzip privilegedtools
```
  $ su -root
  $ cd /var/installer
  $ unzip -d /opt/fsprivileged_tool packages/privilegedtools-*-X86_64.zip
```

- Configure FusionStage configuration file according to business scenarios
Get the product documentation through https://support.huawei.com/carrier/docview?nid=DOC1100813443&path=PBI1-21262245/PBI1-21435125/PBI1-21435910/PBI1-22892300/PBI1-251091346&detailId=PBI1-252220093, In "NFV_FusionStage 21.3 产品文档(FusionSphere).chm -> 网络部署 -> 手工部署Fusionstage（中心侧）-> 安装FusionStage软件 -> 修改FusionStage配置文件" chapter, it has introduces the configuration method of parameters in detail.
```
 $ su - installer
 $ vi /var/installer/FusionStage_CCE/bootstrap/knowledge/fusionstage_LiteCoreBase.yaml
```

- Excute install
```bash
 $ su - installer
 $ touch /var/installer/deploy.log;chown installer:installer /var/installer/deploy.log
 $ cd FusionStage_CCE/bootstrap/bin
 $ nohup ./fsinstall LiteCoreBase -m base >> /var/installer/deploy.log &
```

- Access the FusionStage console as a VDC administrator or VDC operator and then create a cluster  

#### Deploy sonobuoy Conformance test 
```
sonobuoy run --mode=certified-conformance --kube-conformance-image-version=v1.19.4
```