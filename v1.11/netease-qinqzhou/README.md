### How to Reproduce

1. Deploy 'Netease Qinqzhou MicroService' product please refer to [documentation](https://www.163yun.com/product-nsf)

2. Launch the e2e conformance test with following the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)

**Note**: If you have trouble with pulling the images k8s-conformance related by reason of Firewall, just to find a server which located outside of China Mainland and make sure you can ssh login the server by public IP, then you can use ssh port-forward to access the repositories of google(such as k8s.gcr.io, quay.io), the steps of ssh port-forward as below: 
```
   1) execute command: ssh -Nf -D 127.0.0.1:4000 root@{the-public-ip}
   2) add "all_proxy=socks5://127.0.0.1:4000" environment to docker setup config 
   3) restart docker daemon service
```

