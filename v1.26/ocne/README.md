The latest prerequisite and software installation steps are documented in the [Getting Started](https://docs.oracle.com/en/operating-systems/olcne/start/) guide.
This is a site-specific example to validate conformance and not to be used in production. Users should review the _Getting Started_ guide to understand the reasoning behind the choices made, especially in relation to security.
***
Oracle Cloud Native Environment uses three open source tools to simplify the installation and management of Kubernetes and other CNCF projects as objects called modules.
These include: Platform API Server `olcne-api-server`, Platform Agent `olcne-agent` and Platform Command-Line Interface `olcnectl`

This deployment uses six Oracle Linux 8 nodes; one operator node, three control plane nodes, and two worker nodes.

1. The [Terraform for Oracle Cloud Native Environment](https://github.com/oracle-terraform-modules/terraform-oci-olcne) with following Terraform variables can be used to provision the six Oracle Linux 8 compute instances and the Kubernetes cluster.
   ~~~
       ocne_version = "1.7.0"
       provision_mode = "OCNE"
   ~~~


2. After `terraform apply` finished, the `kubeconfig` file will be retrieved to the working directory.
    ~~~
       export KUBECONFIG=$(pwd)/kubeconfig
       kubectl get nodes
       NAME                         STATUS   ROLES           AGE    VERSION
       k8s-test-control-plane-001   Ready    control-plane   118m   v1.26.6+1.el8
       k8s-test-control-plane-002   Ready    control-plane   117m   v1.26.6+1.el8
       k8s-test-control-plane-003   Ready    control-plane   117m   v1.26.6+1.el8
       k8s-test-worker-001          Ready    <none>          116m   v1.26.6+1.el8
       k8s-test-worker-002          Ready    <none>          116m   v1.26.6+1.el8
    ~~~

3. Obtain sonobuoy
    ~~~
       export SONOBUOY_VERSION="0.56.16"
       export SONOBUOY_FILENAME="sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"
       curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/${SONOBUOY_FILENAME}
       tar zxf ${SONOBUOY_FILENAME}
    ~~~
    Begin test
    ~~~
       sonobuoy version --kubeconfig $KUBECONFIG
       Sonobuoy Version: v0.56.16
       MinimumKubeVersion: 1.17.0
       MaximumKubeVersion: 1.99.99
       GitSHA:
       GoVersion: go1.20.1
       Platform: darwin/amd64
       API Version:  v1.26.6+1.el8
       echo "dockerLibraryRegistry: mirror.gcr.io/library" > conformance-image-config.yaml

       sonobuoy run --sonobuoy-image projects.registry.vmware.com/sonobuoy/sonobuoy:v0.56.16 \
         --systemd-logs-image projects.registry.vmware.com/sonobuoy/systemd-logs:v0.4 \
         --e2e-repo-config conformance-image-config.yaml --mode=certified-conformance
    ~~~
