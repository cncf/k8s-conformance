To recreate these results

**1.Install H3C CloudOS Platform:**.
- Get H3CloudOS Plat iso from H3C.
- Prepare three baremetals or virtual machines as nodes, install H3CloudOS Plat iso on these nodes.
- Select one of three nodes , assume the node’s ip is ${IP},visit the url <http://${IP}:9091> and jump to deployment web UI.
- Follow the instructions on the web UI and deploy H3C CloudOS Platform.

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



