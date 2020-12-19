# To reproduce

## Set up the cluster

### By installer

1. Run the VanillaStack Installer
```
$ docker run --name VanillaStack-installer -d -p 8080:8080 harbor.vanillastack.io/vanillastack/installer:latest
```

2. Connect to http://localhost:8080 by using your local browser.

3. Complete the installation by using the WebUI

### By ansible playbook

1. Clone VanillaStack repository
```
$ git clone https://github.com/vanillastack/vanillastack.git
$ cd vanillastack/ansible
```

2. Create inventory file

3. Prepare configuration (example: group_vars.testing/all/*), disable all not needed components (like OpenStack, Cloud Foundry, Harbor, EFK, etc.)

4. Run Playbook
```
$ ansible-playbook -i <inventory-file> type_vanillastack_deploy.yaml"
```

## Run the conformance test

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode certified-conformance --dns-pod-labels "app.kubernetes.io/name=kube-dns,app=coredns"
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```
