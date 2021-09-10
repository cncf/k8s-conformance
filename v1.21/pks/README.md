# VMware Tanzu Kubernetes Grid Integrated Edition v1.12

VMware Tanzu Kubernetes Grid Integrated Edition (TKGI) is a production grade Kubernetes-based container solution equipped with advanced networking, a private container registry, and full lifecycle management. TKGI radically simplifies the deployment and operation of Kubernetes clusters so you can run and manage containers at scale on private and public clouds.

## Installing TKGI

To get started, follow the guide [here](https://docs.pivotal.io/tkgi). The guide includes instructions on how to provision and manage the TKGI control plane.

A summation of that guide is reproduced here starting from after you've deployed
Ops Manager:

### Step 1: Install TKGI

1. Download the product file from VMware Tanzu Network.
2. Navigate to `https://YOUR-OPS-MANAGER-FQDN/` in a browser to log in to the
   Ops Manager Installation Dashboard.
3. Click Import a Product to upload the product file.
4. Under **Tanzu Kubernetes Grid Integrated Edition** in the left column, click the plus sign to add this
   product to your staging area.

### Step 2: Configure TKGI

See the linked guide for full configuration documentation. At a minimum you must:

1. Assign AZs and Networks to be used by the TKGI component VMs and Kubernetes
   cluster VMs.
2. Assign a FQDN and a certificate/private key pair to be used by the TKGI API.
3. Activate and configure **Plan 1**.
4. Configure the Kuberentes Cloud Provider with IaaS credentials.
5. Configure a Container Networking Interface.

### Step 3: Deploy TKGI

1. Click **Review Pending Changes**. Select the product that you intend to
   deploy and review the changes.
2. Click **Apply Changes**.

### Step 4: Configure the TKGI API Load Balancer

1. Navigate to the Ops Manager **Installation Dashboard**.
2. Click the **Tanzu Kubernetes Grid Integrated Edition** tile.
3. Click the **Status** tab and locate the **TKGI API** job. The IP address of
   the TKGI API job is the **TKGI API** endpoint.
4. Configure an external load balancer to resolve to the domain name you entered
   in the **Tanzu Kubernetes Grid Integrated Edition** tile > **TKGI API** > **API Hostname (FQDN)** using
   this IP address, ports 8443 and 9021, and either HTTPS or TCP as the protocol.

### Step 5: Set Up a TKGI Admin User

1. Install UAAC on your machine. For example `gem install cf-uaac`.

2. Download a copy of your Ops Manager root CA certificate to the machine. To
   download the certificate, do the following:
   1. In a web browser, navigate to the FQDN of Ops Manager and log in.
   2. In Ops Manager, navigate to **Settings** in the drop-down menu under your
      username.
   3. Click **Advanced Options**.
   4. On the **Advanced Options** configuration page, click **Download Root CA
      Cert**.
   5. Move the certificate to a secure location on your machine and record the
      path.

3. Retrieve the UAA management admin client secret:
   1. In a web browser, navigate to the **Ops Manager Installation Dashboard**
      and click the **Tanzu Kubernetes Grid Integrated Edition** tile.
   2. Click the **Credentials** tab.
   3. Click **Link to Credential** next to **TKGI Uaa Management Admin Client**
      and copy the value of `secret`.

4. Target your UAA server by running the following command:

   ```
   uaac target https://TKGI-API:8443 --ca-cert CERTIFICATE-PATH
   ```

   Where `TKGI-API` is the domain name of your TKGI API server and
   `CERTIFICATE-PATH` is the path to your Ops Manager root CA certificate.

5. Authenticate with UAA by running the following command:

   ```
   uaac token client get admin -s ADMIN-CLIENT-SECRET
   ```

   Where `ADMIN-CLIENT-SECRET` is your UAA management admin client secret that
   you retrieved in a previous step.

6. Create a new user by running the following command:

   ```
   uaac user add USERNAME --emails USER-EMAIL -p USER-PASSWORD
   ```

7. Assign a TKGI cluster scope to the new user by running the following command:

   ```
   uaac member add tkgi.clusters.admin USERNAME
   ```

8. Run the following command in your terminal to log in to the TKGI CLI:

   ```
   tkgi login -a TKGI-API -u USERNAME -p PASSWORD --ca-cert CERT-PATH
   ```

   Where `TKGI-API` is the domain name of your TKGI API server, `USERNAME` and
   `PASSWORD` belong to the account you created earlier, and `CERT-PATH` is the
   path to your root CA certificate.

## Creating a Kubernetes Cluster

```
tkgi create-cluster CLUSTER-NAME -e HOSTNAME -p PLAN_NAME
tkgi get-credentials CLUSTER-NAME
```

## Running Conformance Tests

The standard tool for running these tests is
[Sonobuoy](https://github.com/vmware-tanzu/sonobuoy). Sonobuoy is regularly built and
kept up to date to execute against all currently supported versions of
kubernetes.

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
