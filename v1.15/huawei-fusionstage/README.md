## To reproduce:

#### Setup Huawei FusionStage Kubernetes Cluster

Deploy Huawei FusionStage Kubernetes Cluster according to the FusionStage [Installation Guide](https://support.huawei.com/enterprise/en/cloud-computing/fusionstage-pid-21733180?category=installation-upgrade&subcategory=software-deployment-guide) documentation with following steps:

- Download `FusionStage_CCE-8.0.RC3-X86_64.zip` from our [Official website](https://support.huawei.com/enterprise/en/cloud-computing/fusionstage-pid-21733180/software).

- Unzip FusionStage_CCE-8.0.RC3-X86_64.zip

```bash
  $ unzip FusionStage_CCE-8.0.RC3-X86_64.zip
```

- Excute install
```bash
 $ cd FusionStage_CCE/bootstrap/bin
 $ nohup ./fsadm create LiteCoreBase -m base >> /var/paas/deploy.log &
```

- Access the FusionStage console as a VDC administrator or VDC operator and then create a cluster  

#### Deploy sonobuoy Conformance test 

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it. 
