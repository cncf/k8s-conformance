## How to reproduce

### Install NCS 22 (based on kubernetes v1.21.6)

1. Launch up a Deployment server using NCS provided deployserver image.
2. From the local machine, launch a web browser (at the moment only Chrome has been tested).
3. Browse to following address of the Deployment server. Be sure to use https.
		https://<deployment server IP>
4. Input username and password in the login page.
5. The Nokia Container Services Installer page will be displayed.
6. Input the sections displayed in the page according the tips and actual usage requirements.
7. Click button `DEPLOY` to start the installation.
8. `NCS install successfully` and Control nodes info will be shown when the cluster is deployed.

### Prepare conformance test

	!!! note
	You should have access to the internet in your Control node in order to be able to download the sonobuoy images. you can configure a proxy in your Control node and then remove it after you pull the images.
	
1. Login to one Control node of the cluster.

2. Configure proxy

		# export PROXY=<proxy-host:port>
		# export proxy=<proxy-host:port>
		# export HTTP_PROXY=<proxy-host:port>
		# export HTTPS_PROXY=<proxy-host:port>
		# export http_proxy=<proxy-host:port>
		# export https_proxy=<proxy-host:port>
		# export no_proxy=<local-addresses>,localhost,127.0.0.1
		# export NO_PROXY=<local-addresses>,localhost,127.0.0.1

3. Remove proxy after you download the sonobuoy images.

		# unset PROXY
		# unset proxy
		# unset HTTP_PROXY
		# unset HTTPS_PROXY
		# unset http_proxy
		# unset https_proxy
		# unset no_proxy
		# unset NO_PROXY
		
4. You need to manually delete the ephemeral-webhook, before executing the sonobuoy test. This webhook restricts app to consume too much disk space and will block some of the sonobuoy test cases.

		# helm delete -n ncms bcmt-ephemeral-webhook

5. Reinstall after the test is executed.

		# helm install bcmt-ephemeral-webhook stable/ephemeral-webhook --version 1.0.0 -n ncms


### Run conformance test

1. Download binary sonobuoy of the release v0.53.2 to the Control node.
		# wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.53.2/sonobuoy_0.53.2_linux_amd64.tar.gz

2. Extract the tarball. 
		# mkdir -p /root/bin          
		# tar -xzvf sonobuoy_0.53.2_linux_amd64.tar.gz -C /root/bin

3. Move the extracted sonobuoy executable to somewhere on your PATH.
		# chmod +x /root/bin/sonobuoy             
		# cp /root/bin/sonobuoy /usr/bin

4. Prepare a file named conformance-image-config.yaml with following content.

		cat << EOF > /root/conformance-image-config.yaml
		buildImageRegistry: bcmt-registry:5000
		dockerGluster: bcmt-registry:5000
		dockerLibraryRegistry: bcmt-registry:5000
		e2eRegistry: bcmt-registry:5000
		e2eVolumeRegistry: bcmt-registry:5000
		gcRegistry: bcmt-registry:5000
		gcEtcdRegistry: bcmt-registry:5000
		promoterE2eRegistry: bcmt-registry:5000
		sigStorageRegistry: bcmt-registry:5000

		EOF

5. Download Sonobuoy images of the release v0.53.2  (pull/tag/push to bcmt-registry:5000).

		gcr.io/authenticated-image-pulling/alpine:3.7
		gcr.io/authenticated-image-pulling/windows-nanoserver:v1
		gcr.io/k8s-authenticated-test/agnhost:2.6
		gcr.io/kubernetes-e2e-test-images/cuda-vector-add:1.0
		invalid.com/invalid/alpine:3.1
		k8s.gcr.io/build-image/debian-iptables:buster-v1.6.5
		k8s.gcr.io/conformance:v1.21.6
		k8s.gcr.io/e2e-test-images/agnhost:2.32
		k8s.gcr.io/e2e-test-images/apparmor-loader:1.3
		k8s.gcr.io/e2e-test-images/busybox:1.29-1
		k8s.gcr.io/e2e-test-images/cuda-vector-add:2.2
		k8s.gcr.io/e2e-test-images/echoserver:2.3
		k8s.gcr.io/e2e-test-images/glusterdynamic-provisioner:v1.0
		k8s.gcr.io/e2e-test-images/httpd:2.4.38-1
		k8s.gcr.io/e2e-test-images/httpd:2.4.39-1
		k8s.gcr.io/e2e-test-images/ipc-utils:1.2
		k8s.gcr.io/e2e-test-images/jessie-dnsutils:1.4
		k8s.gcr.io/e2e-test-images/kitten:1.4
		k8s.gcr.io/e2e-test-images/metadata-concealment:1.6
		k8s.gcr.io/e2e-test-images/nautilus:1.4
		k8s.gcr.io/e2e-test-images/nginx:1.14-1
		k8s.gcr.io/e2e-test-images/nginx:1.15-1
		k8s.gcr.io/e2e-test-images/node-perf/npb-ep:1.1
		k8s.gcr.io/e2e-test-images/node-perf/npb-is:1.1
		k8s.gcr.io/e2e-test-images/node-perf/tf-wide-deep:1.1
		k8s.gcr.io/e2e-test-images/nonewprivs:1.3
		k8s.gcr.io/e2e-test-images/nonroot:1.1
		k8s.gcr.io/e2e-test-images/perl:5.26
		k8s.gcr.io/e2e-test-images/redis:5.0.5-alpine
		k8s.gcr.io/e2e-test-images/regression-issue-74839:1.2
		k8s.gcr.io/e2e-test-images/resource-consumer:1.9
		k8s.gcr.io/e2e-test-images/sample-apiserver:1.17.4
		k8s.gcr.io/e2e-test-images/volume/gluster:1.2
		k8s.gcr.io/e2e-test-images/volume/iscsi:2.2
		k8s.gcr.io/e2e-test-images/volume/nfs:1.2
		k8s.gcr.io/e2e-test-images/volume/rbd:1.0.3
		k8s.gcr.io/etcd:3.4.13-0
		k8s.gcr.io/pause:3.4.1
		k8s.gcr.io/prometheus-dummy-exporter:v0.1.0
		k8s.gcr.io/prometheus-to-sd:v0.5.0
		k8s.gcr.io/sd-dummy-exporter:v0.2.0
		k8s.gcr.io/sig-storage/nfs-provisioner:v2.2.2
		mcr.microsoft.com/windows:1809
		sonobuoy/sonobuoy:v0.53.2
		sonobuoy/systemd-logs:v0.3
		
6. Run sonobuoy.

		# sonobuoy run --sonobuoy-image bcmt-registry:5000/sonobuoy:v0.53.2 --kube-conformance-image bcmt-registry:5000/conformance:v1.21.6 --systemd-logs-image bcmt-registry:5000/systemd-logs:v0.3 --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=is_control,is_edge" --e2e-repo-config /root/conformance-image-config.yaml --mode=certified-conformance

7. View actively running pods:

		# sonobuoy status

8. To inspect the logs:

		# sonobuoy logs

9. Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

		# sonobuoy retrieve .

		This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

			mkdir ./results; tar xzf *.tar.gz -C ./results

		!!! note
		The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

10. To clean up Kubernetes objects created by Sonobuoy, run:

		# sonobuoy delete