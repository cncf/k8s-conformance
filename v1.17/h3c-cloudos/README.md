To recreate these results

1. Install  H3C CloudOS5.0 Platform.
2. Run Conformance Test:
	Download and Run sonobuoy v0.17.2:
	$ sonobuoy run
	View actively running pods:
	$ sonobuoy status 
	To inspect the logs:
	$ sonobuoy logs
	Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
	$ sonobuoy retrieve .
	This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
	mkdir ./results; tar xzf *.tar.gz -C ./results


