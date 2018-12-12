To reproduce.

#### Create cluser using pharmer

```console
$ pharmer create credential do1
$ pharmer create cluster con113 \
    --provider=digitalocean \
    --zone=nyc3 \
    --nodes=2gb=1
    --credential-uid=do1 \
    --kubernetes-version=v1.13.0


$ pharmer apply con113 --v=3

# wait for completion the process.
$ pharmer use cluster con113

```

#### Run Conformance Test

Follow the instructions from [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)


Then grab `plugins/e2e/results/{e2e.log,junit_01.xml,version.txt}` and add them to this PR.