To recreate these results

1. Install  H3C CloudOS5.0 Platform.
2. Retrieve a \`.kubeconfig\` file with administrator credentials on that cluster and set the environment variable KUBECONFIG
    export KUBECONFIG=PATH_TO_KUBECONFIG
    export KUBECTL_PATH=PATH_TO_KUBECTL
3. Run Conformance Test:
	Download the CLI by running:
	$ go get -u -v github.com/heptio/sonobuoy
	Deploy a Sonobuoy pod to your cluster with:
	$ sonobuoy run
	View actively running pods:
	$ sonobuoy status 
	To inspect the logs:
	$ sonobuoy logs
	Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
	$ sonobuoy retrieve .
	This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
	mkdir ./results; tar xzf *.tar.gz -C ./results


