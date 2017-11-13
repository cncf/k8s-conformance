# To reproduce:

This will run the conformance tests against a reference KET K8s v1.8 cluster, running on AWS. 

Instructions below assume you're running on a utility EC2 instance. They can also be run from a macOS (darwin) machine by changing the release package name accordingly.

These creds are required to provision a cluster on your AWS account

```console
export AWS_ACCESS_KEY_ID="Your AWS Access Key Here"
export AWS_SECRET_ACCESS_KEY="Your AWS Secret Key Here"
```

Retrieve and unpack KET release

```console
wget https://github.com/apprenda/kismatic/releases/download/v1.6.0/kismatic-v1.6.0-linux-amd64.tar.gz
mkdir ket160
tar -xf kismatic-v1.6.0-linux-amd64.tar.gz -C ket160
cd ket160
```

Copy and rename your .pem file to kismatic.pem in the root of the KET directory and make sure it has the proper permissions

```console
cp /path/to/aws.pem ./kismatic.pem
chmod 600 kismatic.pem
```

Provision and install KET on AWS EC2 instances

```console
./provision aws create -f -w 4 -i beefy
./kismatic install apply
```

Run sonobuoy against newly created cluster

```console
curl -L https://gist.githubusercontent.com/ikester/53be5b68f4412d8c863ce6686a094c6e/raw/7221cc9367b16c8f004339b3bcf24c8e4498b218/sonobuoy-conformance.yaml | sed 's/3600/5400/' | kubectl --kubeconfig generated/kubeconfig create -f -
```

Check the logs and wait for "no-exit was specified, sonobuoy is now blocking" and press CTRL-C

```console
kubectl --kubeconfig generated/kubeconfig logs -n sonobuoy sonobuoy
```

Copy the test results out of the container and into the `./results` directory

```console
kubectl --kubeconfig generated/kubeconfig cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

Untar the tarball inside `./results`, look for `plugins/e2e/results/{e2e.log,junit_01.xml}`

Destroy the AWS cluster if you no longer need it

```console
./provision aws delete-all
```