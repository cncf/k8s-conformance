The latest prerequisite and software installation steps are documented in the [Installation](https://github.com/oracle-cne/ocne#installation).
This is a site-specific example to validate conformance and not to be used in production.
***
Release 2.0 of Oracle Cloud Native Environment provides a new way of creating and managing Kubernetes clusters, compared to previous releases. 

1. Use the following example command for a quick start to create a 3 control plane nodes and 2 worker nodes on a local system 
    ~~~
       ocne cluster start --version 1.32 --control-plane-nodes 3 --worker-nodes 3
       export KUBECONFIG=$(ocne cluster show)
       kubectl get nodes
       NAME                   STATUS   ROLES           AGE    VERSION
       ocne-control-plane-1   Ready    control-plane   118m   v1.32.5+1.el8
       ocne-control-plane-2   Ready    control-plane   117m   v1.32.5+1.el8
       ocne-control-plane-3   Ready    control-plane   117m   v1.32.5+1.el8
       ocne-worker-1          Ready    <none>          116m   v1.32.5+1.el8
       ocne-worker-2          Ready    <none>          116m   v1.32.5+1.el8
       ocne-worker-3          Ready    <none>          116m   v1.32.5+1.el8
    ~~~

2. Obtain sonobuoy
    ~~~
       wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
       tar xf sonobuoy_0.57.3_linux_amd64.tar.gz
    ~~~
    Begin test
    ~~~
       sonobuoy version --kubeconfig $KUBECONFIG
       Sonobuoy Version: v0.57.3
       MinimumKubeVersion: 1.17.0
       MaximumKubeVersion: 1.99.99
       GitSHA: a988242e8bbded3ef4602eda48addcfac24a1a91
       GoVersion: go1.23.6
       Platform: linux/amd64
       API Version: v1.32.5+1.el8

       sonobuoy run --mode=certified-conformance
    ~~~
