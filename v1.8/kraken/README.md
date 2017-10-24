## To Reproduce:

This will install and run sonobuoy against a kubernetes v1.8 cluster as created by [kraken](https://github.com/samsung-cnct/kraken).

### Download and unpack the appropriate cli tarball for your host OS (kraken v1.2.2):
 - [darwin](https://github.com/samsung-cnct/kraken/releases/download/1.2.2/kraken_1.2.2_darwin_amd64.tar.gz)
 - [linux 32bit](https://github.com/samsung-cnct/kraken/releases/download/1.2.2/kraken_1.2.2_linux_386.tar.gz)
 - [linux 64 bit](https://github.com/samsung-cnct/kraken/releases/download/1.2.2/kraken_1.2.2_linux_amd64.tar.gz)

### Generate a kraken configuration file for aws
`./kraken generate <complete\path\to\config>\sonobuoy.yaml --provider aws`

`<complete\path\to\config>` can be any directory your user has read/write permissions on but it should be the full path.

### Set name of cluster
`vim <complete\path\to\config>\sonobuoy.yaml +389`

set `name:` to be `sonobuoy`

### Create cluster
`./kraken cluster up --config <complete\path\to\config>\sonobuoy.yaml --output <complete\path\to\output\directory>`

`<complete\path\to\output\directory>` can be any directory your user has read/write permissions on but it should be the full path.

This will take 5-20 minutes, depending on how AWS is responding.  

*note the above command assumes you have rsa keys at `~/.ssh` and that you have configured aws credentials at `~/.aws`.  If you have not done either of those, please do so and re-run the `cluster up` command.

### Install sonobuoy
1. `wget https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml -O <complete\path\to\output\directory>\sonobuoy-conformance-1.7.yaml`
2. `./kraken tool kubectl --config <complete\path\to\config>\sonobuoy.yaml --output <complete\path\to\output\directory> -- apply -f <complete\path\to\output\directory>\sonobuoy-conformance-1.7.yaml`

### Fetch the results
1. `./kraken tool kubectl --config <complete\path\to\config>\sonobuoy.yaml --output <complete\path\to\output\directory> -- exec -n sonobuoy sonobuoy ls /tmp/sonobuoy`
2. `./kraken tool kubectl --config <complete\path\to\config>\sonobuoy.yaml --output <complete\path\to\output\directory> -- cp -n sonobuoy sonobuoy:/tmp/sonobuoy/<filename of results> <complete\path\to\output\directory>\<filename of results>`

### Destroy cluster
 `./kraken cluster down --config \<complete\path\to\config>\sonobuoy.yaml --output <complete\path\to\target\directory>`