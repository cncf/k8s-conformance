# RKE Government
A Kubernetes distribution focused on enabling Federal government compliance-based use cases. Also known as rke2.

## To Reproduce

1. Create two machines, any modern Linux will work but this test was done on SUSE Linux Enterprise Server 15 SP4 LTS.
2. RKE2 provides an installation script that is a convenient way to install it as a service on systemd or openrc based systems. To install RKE2 using this method, run the below. Note that rke2 provides a built-in ingress controller that should be disabled when running conformance tests as it will interfere with "[sig-network] Ingress API should support creating Ingress API operations [Conformance]":
  ```
  mkdir -p /etc/rancher/rke2 && cat <<EOF > /etc/rancher/rke2/config.yaml
  disable: rke2-ingress-nginx
  token: test
  EOF
  
  curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION=v1.26.0+rke2r1 sh -
  systemctl enable rke2-server
  systemctl start rke2-server
  ```
3. To install on worker nodes and add them to the cluster, create a config file with token and server entries. Here is an example showing how to join a worker node. The value to use for token is stored at /var/lib/rancher/rke2/server/node-token on your server node, or just the value supplied to the token arg when starting your server node, as shown in the example above.
  ```
  mkdir -p /etc/rancher/rke2 && cat <<EOF > /etc/rancher/rke2/config.yaml
  server: https://serverone:9345
  token: test
  EOF
  
  curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_VERSION=v1.26.0+rke2r1 INSTALL_RKE2_TYPE='agent' sh -
  systemctl enable rke2-agent
  systemctl start rke2-agent
  ```
4. Run sonobuoy v0.56.10: `sonobuoy run --mode=certified-conformance --kubernetes-version=v1.26.0`
