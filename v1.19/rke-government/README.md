# RKE Government
A Kubernetes distribution focused on enabling Federal government compliance-based use cases

## To Reproduce

1. Create two machines, any modern Linux will work but this test was done with Ubuntu 20.04
2. RKE2 provides an installation script that is a convenient way to install it as a service on systemd or openrc based systems.To install RKE2 using this method, just run:
    
    curl -sfL https://get.rke2.io | sh -
    systemctl enable rke2-server
    systemctl start rke2-server

3. To install on worker nodes and add them to the cluster, create a config file with token and server entries. Here is an example showing how to join a worker node. The value to use for token is stored at /var/lib/rancher/rke2/server/node-token on your server node

    mkdir -p /etc/rancher/rke2
    
    Content of /etc/rancher/rke2/config.yaml
     server: https://serverone:9345
     token: <token from server node>
    
    curl -sfL https://get.rke2.io | sh -

    systemctl enable rke2-agent
    systemctl start rke2-agent

4. Run sonobuoy v0.19.0
