# How to reproduce

## 1. Create your account on Nexastack platform

Open [Nexastack](https://www.nexastack.com) and apply for invite. <em>(Currently we are supporting registrations via invitation only)</em>. Once received the invite, continue the onboarding process via following the instructions alongwith invite.

Nexastack is Infrastructure as Code Platform allowing to install applications on a managed kubernetes. With Nexastack you manage applications and we manage kubernetes and the underlying Infrastructre.


## 2. Create a new cluster and download kubeconfig
On the main Navigation Panel go to your Project, choose Clusters, select Nexastack managed clusters. Here you will find the cluster managed by Nexastack for you.

Request t kubeconfig using the cluster's action button.


## 3. Access the cluster
To access the cluster export kubeconfig file from step 4, for example:
```
export KUBECONFIG=~/cncf/kubeconfig
```
Now you're authorized to interact with your cluster:
```
kubectl get pods --all-namespaces
```

## 4. Run the tests
Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster and instruct it to ignore master taints:

```
$ sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=CriticalAddonsOnly,dedicated" --mode=certified-conformance
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
