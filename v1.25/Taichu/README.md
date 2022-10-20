# Conformance tests for TaiChu v1.4.0

## Deploy Kubernetes

1. Prepare The Servers
- Prepare a server for installing TaiChu, and then excute the script ```install.sh```.
- Prepare three servers, one master and two workers to deploy kubernetes.

2. Deploy Cluster
- Click the "Resource Manager -> Compute Node -> Add" button to add the servers to TaiChu Kubernetes Platform. 
- Click the "Cluster Manager -> Cluster -> Add" button to choose the servers and create the cluster.

## Run Conformance Test
1. kubernetes version
```
k8s_version=v1.25.1
```
2. product name
```
TaiChu 
```
3. Download sonobuoy
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
```

4. Unpack ```sonobuoy_0.56.10_linux_amd64.tar.gz``` to ```/usr/local/bin```
```
tar -zxvf sonobuoy_0.56.10_linux_amd64.tar.gz -C /usr/local/bin
```

5. Add permissions to ```/usr/local/bin/sonobuoy```
```
chmod +x /usr/local/bin/sonobuoy
```

6. Run sonobuoy to launch conformance tests and wait for them to complete.
```
sonobuoy run --mode=certified-conformance --wait
```

7. Get the results
```
outfile=$(sonobuoy retrieve)
mkdir ./sonobuoy; tar xzf $outfile -C ./sonobuoy
```

8. create directory ```v1.25.1/taichu``` and copy  ```e2e.log, junit_01.xml``` to here.
```
mkdir -p ./v1.25.1Taichu
cp ./sonobuoy/plugins/e2e/results/global/* ./v1.25.1/Taichu
```

9. Generate ```PRODUCT.yaml```
```
cat << EOF > ./v1.25.1/TaiChu/PRODUCT.yaml
vendor:  Xi'an TieKe Jingwei Information Technology Co.,Ltd. 
name: TaiChu
version: v1.4.0
website_url: https://www.rails.cn/xian/en-us/src/prointroduce/kmpp
documentation_url: https://www.rails.cn/xian/en-us/src/prointroduce/kmppfile
product_logo_url: https://www.rails.cn/xian/assets/static/logo1.179003c.2b0dfa30eeb2a44c4d53445a8da814de.svg
type: distribution
description: 'TaiChu kubernetes engine provie an easier,powerful platform that helps enterprise to use Kubernetes faster and better, include but not limited to installation and maintenance of k8s, deployment, monitoring and management of containerized applications,etc.'
EOF
```