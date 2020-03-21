To recreate these results

**1.Install H3C CloudOS Platform:**.
- Get H3CloudOS Plat iso from H3C.
- Prepare three baremetals or virtual machines as nodes, install H3CloudOS Plat iso on these nodes.
- Select one of three nodes , assume the node’s ip is ${IP},visit the url <http://${IP}:9091> and jump to deployment web UI.
- Follow the instructions on the web UI and deploy H3C CloudOS Platform:
  - Click 'Deploy' Button to start the deployment.
  - Fill in the other two nodes's ip and ssh root user info, for example:<NODE2_IP>,root/<ROOT_PASSWORD>, join them to cluster.
  - Set VIP for the Cluster,please ensure the VIP has not been used.
  - Choose componets to deploy, recommend all.
  - Prepare four shared storage（e.g.,ICSCI、NFS、GClusterFS) volumes which connectted to three nodes,and format these volumes with mkfs.ext4.
  - After completing the above steps，click 'Confirm' button, start the deploy task.

**2. Run Conformance Test:**
- Download and Run sonobuoy v0.17.2:  
		$ sonobuoy run  
- View actively running pods:  
		$ sonobuoy status   
- To inspect the logs:  
		$ sonobuoy logs  
- Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:  
		$ sonobuoy retrieve.  
- This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:  
		mkdir ./results; tar xzf *.tar.gz -C ./results  



