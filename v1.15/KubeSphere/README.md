## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://kubesphere.io/en/install) documentation.

Step 1:Download Installer 2.1.0 and enter into the installation folder.
```
 curl -L https://kubesphere.io/download/stable/v2.1.0 > installer.tar.gz \
&& tar -zxf installer.tar.gz && cd kubesphere-all-v2.1.0/conf
```

Step 2:Edit the host configuration file conf/hosts.ini

Step 3:Get Started With Installation
It's recommended to install using root user, then execute install.sh:
```
./install.sh
Enter 2 to select Multi-node mode to start:
################################################
         KubeSphere Installer Menu
################################################
*   1) All-in-one
*   2) Multi-node
*   3) Quit
################################################
https://kubesphere.io/               2018-11-08
################################################
Please input an option: 2
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.