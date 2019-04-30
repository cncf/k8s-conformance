## To Reproduce:

Note: to reproduce you need a Mail.Ru Cloud Solutions account. You can create it by signing up at https://mcs.mail.ru/app/en/signup/ 

### Create cluster

Login to Mail.Ru Cloud Solutions and activate your account at https://mcs.mail.ru/app/en/ 

Here you can find out how to create a single cluster:

https://mcs.mail.ru/help/kubernetes/clusterfast

### Get Credentials

Open up the firewall from your IP to the cluster for kubectl:

Head to Network Settings, add a new rule and enter your IP address (from), Kubernetes servers (to) and TCP (protocol) 6443 (port).

Go to https://mcs.mail.ru/app/en/services/containers/list/ then select your cluster and download kubeconfig archive.

After you unpack the archive, set KUBECONFIG env variable and check access to your cluster:

```bash
export KUBECONFIG=~/Downloads/<cluster_name>/config
kubectl get nodes
```

### Run the tests

You can use the Sonobuoy Scanner to run the tests:

https://scanner.heptio.com/
