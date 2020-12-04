### How to Reproduce

### 1. Deploy 'Netease Qingzhou MicroService' product.
**Preparation**
- 1 Download the package from [Netease NOS](https://k8s-package.nos-eastchina1.126.net/qingzhou-k8s.tar.gz).

- 2 Get at least 2 machines for k8s master, 3 machines for etcd and 1 machine for k8s node.

- 3 Install the ansible by pip at the machine which can ssh all machines above.
	```bash
	pip install ansible
	```

**Setup kubernetes cluster**

- Modify parameters in directory`envs_example`. The default values will setup a standalone cluster.

	Typically, you can only modify the parameters in `hosts`
	```yaml
	[etcd]
	etcd-0
	etcd-1
	etcd-2
	[master]
	master-0
	master-1
	[node]
	node-0
	```

- Setup by `main.sh`:

	```bash
	bash main.sh
	```

### 2. Launch the e2e conformance test with following the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)

**Note**: If you have trouble with pulling the images k8s-conformance related by reason of Firewall, just to find a server which located outside of China Mainland and make sure you can ssh login the server by public IP, then you can use ssh port-forward to access the repositories of google(such as k8s.gcr.io, quay.io), the steps of ssh port-forward as below: 
```
   1) execute command: ssh -Nf -D 127.0.0.1:4000 root@{the-public-ip}
   2) add "all_proxy=socks5://127.0.0.1:4000" environment to docker setup config 
   3) restart docker daemon service
```

