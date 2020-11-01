## To Reproduce:

### Prepare resources on TECS Openstack

The TECS system administrator is required to perform the following preparations:

1. Sign in to TECS
  - Enter the visit URL of TECS in your browser (eg https: //xx.xx.xx.xx), and login with the admin user.

2. Create an external network (Administrator-> Network-> Create Network) (ignore this step if an external network already exists)
  - Create a network for external access under the admin user to ensure that all IP addresses in the subnet are not occupied. (The network needs to be set to shared and external networks).

3. Create PaaS project (Identity-> Project-> Create Project)
  - Create a new project under the admin user, and set the project name (eg paas), and username / password (eg paas / paas).
  - The project quota is set according to the project requirements. The recommended quota is: 20 networks / subnets, 300 ports, 2 floating IPs. The virtual core and memory should be greater than the sum of all virtual machines in the project. Other parameters can use default values.
  - It should be ensured that the quota is not less than the sum of the resources actually consumed by the PaaS project.

4. Create Cloud Host Type (Admin-> Cloud Host Type-> Create Cloud Host Type)
  - The cloud host type (eg flavor_node) corresponds to the virtual machine configuration, which is divided into general scenarios and all_in_one scenarios (all roles are deployed on the paas controller node), and different parameters need to be configured.

5. Upload image (Project-> Compute-> Mirror-> Create Image)
  - Log out of the admin user and log in to the PaaS project with the username / password you just set. Upload the node image used by OpenPalette (eg cgsl.img).
  - For image release instructions, please refer to: Image Release. Both the first and non-first nodes use the CGSL operating system image. Copy the link to your browser to download the desired image.

6. Create a virtual machine network (Project-> Network-> Network-> Create Network)
  - Under the PaaS project, create a virtual machine network with the name net_api. When creating the subnet of net_api, you need to set the subnet mask reasonably according to the size of the application that is ultimately deployed. If the cluster size is large, it is recommended to set the mask to 16 bits. If you need to use the storage network plane, you need to create a network named net_sto.

7. Create route
  - First create a route Project-> Network-> Route-> New Route-> Select External Network.
Add routing interface Project> Network> Routing> Click on the route just created> Interface> Add Interface> Select the network that needs to be bound to the floating IP (paas project uses net_api to bind the floating IP)

8. Start paas controller cloud host
  - Under the PaaS project, use the CGSL image to start the paas controller cloud host. The cloud host name must be paas-controller and the cloud host type is the type created by the previous admin user. Number of cloud hosts: 3 for HA environment, 1 for non-HA. First select net_api for the network. If you need to use the storage network plane, select net_sto. (The order of network selection cannot be wrong).

9. Binding Floating IP
  - Under the PaaS project, select any paas controller cloud host and bind the floating IP in the action options. Use a computer on the same network segment as the floating IP to ping the floating IP. If the ping succeeds, the cloud host configuration is successful.


### Deploy OpenPalette kubernetes cluster
1. Execute the deployment command on controller node:
```bash
pdm-cli deploy
```

  - Wait about 60 minutes to complete the installation of OpenPalette.

2. Verify deployment results
  - View the interface prompt when deployment is complete:
```bash
Deploy PaaS successfully, and create cluster complete!
```


### Run conformance tests

Install the git & golang software, then build the Sonobuoy tool by myself:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to the OpenPalette Kubernetes cluster with:

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
$ outfile=$(sonobuoy retrieve)
```

Extract the `.tar.gz` contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

Clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

Prepare the necessary documents and submit the PR according to [official guide - uploading](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#uploading).

Done! ☺️
