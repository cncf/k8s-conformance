# To recreate these results

## 1.Install Dahua Magic Cube Platform

## 2.Run Conformance Tests

- Download Sonobuoy (0.52.0)

```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.52.0/sonobuoy_0.52.0_linux_amd64.tar.gz
tar -xzf sonobuoy_0.52.0_linux_amd64.tar.gz
mv sonobuoy /usr/local/bin
```

- Prepare images

```
docker pull sonobuoy/sonobuoy:v0.52.0
docker pull sonobuoy/systemd-logs:v0.3
docker pull k8s.gcr.io/conformance:v1.19.4
```

- Run Sonobuoy

```
sonobuoy run --kubeconfig=/root/.kube/config --image-pull-policy=IfNotPresent --mode=certified-conformance --wait
```

- Check the status

```
sonobuoy status --kubeconfig=/root/.kube/config
```

- Inspect the logs

```
sonobuoy logs --kubeconfig=/root/.kube/config
```

- Once `sonobuoy status` shows the run as `completed`, download the results tar.gz file

```
result=$(sonobuoy retrieve --kubeconfig=/root/.kube/config)
tar xzf $result -C results/
```









