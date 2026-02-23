1. Install H3C CloudOS Platform.
2. Retrive a \`.kubeconfig\` file with administrator credentials on that cluster and set the enviroment variable KUBECONFIG
    export KUBECONFIG=PATH_TO_KUBECONFIG
    export KUBECTL_ATH=PATH_TOKUBECTL
3. Run Conformance Test:
    Download the CLI by running:
    $ go get -u -v github.com/vmware-tanzu/sonobuoy
    Deploy a Sonobuoy pod to your cluster with:
    $ sonobuoy run --mode=certified-conformance
    View actively running pods:
    $ sonobuoy status
    To inspect the logs:
    $ sonobuoy logs
    Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
    $ sonobuoy retrieve 
    This copies a single .tar.gz snapshot from the Sonobuoy pod into your local current directory. Extract the file 
    with: tar -xzf <filename>.tar.gz  and the result files is located in plugins/e2e/results/global/