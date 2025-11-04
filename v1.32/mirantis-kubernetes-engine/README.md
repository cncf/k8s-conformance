# Mirantis Kubernetes Engine 4.1.0

The Mirantis Kubernetes Engine 4.1.0 is made up of a number of
components, including Kubernetes v1.32.

## Installing Mirantis Kubernetes Engine 4.1.0 to reproduce the results

You will need to deploy a cluster of 1 or more nodes. Mirantis recommends using [mkectl](https://docs.mirantis.com/mke-docs/docs/getting-started/install-mke-4k-cli/) to ease the provisioning and installation of an MKE 4.1.0 clusters.

### Provisioning a Cluster with mkectl

The following section assumes that you have provisioned some instances with the necessary specifications defined in [System Requirements](https://docs.mirantis.com/mke-docs/docs/getting-started/system-requirements/)
1. Install MKE 4.x CLI. More details at [Install the MKE 4k CLI](https://docs.mirantis.com/mke-docs/docs/getting-started/install-mke-4k-cli/)

2. Create MKE 4.x configuration file



    MKE 4 clusters are configured using a YAML file. 

    By default, mke4.yaml is used as the name of mke4 config file, unless it is explicitly specified.

    Detailed steps for creating MKE 4 configuration file can be found at [Mirantis Kubernetes Engine 4k Initialize Deployment](https://docs.mirantis.com/mke-docs/docs/getting-started/create-cluster/#initialize-deployment)

    Details of the configuration specification for MKE 4 can be found at [Mirantis Kubernetes Engine 4k Configuration](https://docs.mirantis.com/mke-docs/docs/configuration/)

    Conformance testing requires one host as manager node and 3 hosts as worker nodes. Because a single manager node is used, no load balancer is required.


    For this test, the following values need to be modified in the default configuration spec(this allows Sonobuoy to reach MKE using default ports):
   1. Set `Network.NodePortRange = "30000-32767"` like so(this is present in the default configuration so it is a simple edit):
  ```yaml
    nodePortRange: 30000-32767
  ```

   2. Set `IngressController.NodePorts.HTTP = 30000` and `IngressController.NodePorts.HTTPS = 30001` like so(this may not be present in the default configuration so it is an addition to the default configuration):
   
  ```yaml
    ingressController:
      nodePorts:
        http: 30000
        https: 30001
  ```

  While modifying the above, ensure you do not leave in the following line (otherwise MKE 4.x installation will complain about port 33001 and fail):

  ```yaml
      nodePorts: {} 
  ```

   
 An example `mke4.yaml` file would look like this:

   ```yaml
apiVersion: mke.mirantis.com/v1alpha1
kind: MkeConfig
metadata:
  creationTimestamp: null
  name: mke
  namespace: mke
spec:
  airgap:
    enabled: false
  apiServer:
    audit:
      enabled: false
      logPath: /var/log/k0s/audit/mke4_audit.log
      maxAge: 30
      maxBackup: 10
      maxSize: 10
    encryptionProvider: /var/lib/k0s/encryption.cfg
    eventRateLimit:
      enabled: false
    requestTimeout: 1m0s
  authentication:
    expiry: {}
    ldap:
      enabled: false
    oidc:
      enabled: false
    saml:
      enabled: false
  backup:
    enabled: true
    scheduled_backup:
      enabled: false
    storage_provider:
      external_options: {}
      in_cluster_options:
        admin_credentials_secret: minio-credentials
        enable_ui: true
      type: InCluster
  cloudProvider:
    enabled: false
    provider: aws
  controllerManager:
    terminatedPodGCThreshold: 12500
  devicePlugins:
    nvidiaGPU:
      enabled: false
      mig: {}
  dns:
    lameduck: {}
  etcd: {}
  ingressController:
    affinity:
      nodeAffinity: {}
    enabled: true
    extraArgs:
      defaultSslCertificate: mke/mke-ingress.tls
      enableSslPassthrough: false
      httpPort: 80
      httpsPort: 443
    nodePorts: 
      http: 30000
      https: 30001
    ports: {}
    replicaCount: 2
  kubelet:
    eventRecordQPS: 50
    managerKubeReserved:
      cpu: 250m
      ephemeral-storage: 4Gi
      memory: 2Gi
    maxPods: 110
    podPidsLimit: -1
    podsPerCore: 0
    protectKernelDefaults: false
    seccompDefault: false
    workerKubeReserved:
      cpu: 50m
      ephemeral-storage: 500Mi
      memory: 300Mi
  license:
    token: ""
  monitoring:
    enableCAdvisor: false
    enableGrafana: true
    enableOpscare: false
    grafana:
      ingress:
        enabled: false
    prometheus: {}
  network:
    cplb:
      disabled: true
    kubeProxy:
      iptables:
        minSyncPeriod: 0s
        syncPeriod: 0s
      ipvs:
        minSyncPeriod: 0s
        syncPeriod: 0s
        tcpFinTimeout: 0s
        tcpTimeout: 0s
        udpTimeout: 0s
      metricsBindAddress: 0.0.0.0:10249
      mode: iptables
      nftables:
        minSyncPeriod: 0s
        syncPeriod: 0s
    multus:
      enabled: false
    nllb:
      disabled: true
    nodePortRange: 30000-32767
    providers:
    - enabled: true
      extraConfig:
        cidrV4: 192.168.0.0/16
        linuxDataplane: Iptables
        loglevel: Info
      provider: calico
    - enabled: false
      provider: custom
    - enabled: false
      extraConfig:
        cidrV4: 192.168.0.0/16
        v: "5"
      provider: kuberouter
    - enabled: false
      extraConfig:
        ipam.operator.clusterPoolIPv4PodCIDRList: 192.168.0.0/16
        routingMode: tunnel
        tunnelProtocol: vxlan
      provider: cilium
    serviceCIDR: 10.96.0.0/16
  policyController:
    opaGatekeeper:
      enabled: false
  registries:
    chartRegistry:
      url: oci://registry.mirantis.com/mke
    imageRegistry:
      url: registry.mirantis.com/mke
  scheduler: {}
  tracking:
    enabled: true
  version: v4.1.0
  hosts:
  - ssh:
      address: "35.86.148.205"
      user: ubuntu
      port: 22
      keyPath: ./aws_private.pem
    role: controller+worker
  - ssh:
      address: "54.212.16.157"
      user: ubuntu
      port: 22
      keyPath: ./aws_private.pem
    role: worker
  - ssh:
      address: "54.184.102.20"
      user: ubuntu
      port: 22
      keyPath: ./aws_private.pem
    role: worker
  - ssh:
      address: "54.244.204.202"
      user: ubuntu
      port: 22
      keyPath: ./aws_private.pem
    role: worker
   ```

5. Bootstrap your cluster

   You can create the cluster once the cluster configuration file is fully set up. In the same directory where you created the mke4.yaml file, run:

    ```shell
    mkectl apply
    ```

6. Once the above command is successfully completed, you will see the Admin UI connection information, similar to the following example:

   ```shell
   <- snipped for brevity ->
   INF Configuring default admin user in Dex
   !!! Make sure to save the admin credentials shown below !!!
                 They are only showed once
            You won't be able to see them again

                Generated username:password                 
           admin:aLSgtjNiusU_GF90hgvy_C70ALvlfQZR           
   ```

### Setting up your environment

1. Login to one of the manager nodes and execute the following to get the kubeconfig for the cluster:

   ```shell
   k0s kubeconfig admin
   ```

   Save the output of the above command to a file that will be your KUBECONFIG and export it to make it available to tools like kubectl.

2. Ensure that kubectl is available on the PATH

3. Confirm (by running an arbitrary kubectl command) that kubectl is able to access the above KUBECONFIG 

## Run Conformance Test

1. Install the Sonobuoy CLI at [https://github.com/vmware-tanzu/sonobuoy](https://github.com/vmware-tanzu/sonobuoy). v0.57.3 was used for this submission.

2. Launch the conformance tests

    ```shell
    sonobuoy run --wait --mode=certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v --non-blocking-taints=node-role.kubernetes.io/master" --kubernetes-version=v1.32.3
    ```

3. Once the tests are complete, retrieve the results

    ```shell
    sonobuoy retrieve ./results
    ```

4. (Optional) Clean up the Kubernetes objects created by Sonobuoy

    ```shell
    sonobuoy delete
    ```

