## How to reproduce

### Install NCS 20 (based on kubernetes v1.17.4)

1. Launch up a Deployment server using NCS provided deployserver image.
2. Login to the Deployment Server and get the installer username and password from the file `/opt/bcmt/userinfo`.
3. From the local machine, launch a web browser (at the moment only Chrome has been tested).
4. Browse to following address with the Elastic IP address of the Deployment server. Be sure to use https.

        https://<deployment server IP>:8082

5. Input username and password in the login page.
6. The Nokia Container Services Installer page will be displayed.
7. Input the sections displayed in the page according the tips and actual usage requirements.
8. Click button `START DEPLOY` to start the installation.
9. `NCS install successfully` and Control nodes info will be shown when the cluster is deployed.

### Prepare conformance test

1. Login to one Control node of the cluster.

2. Configure proxy to external network.

        # vi ~/.profile

    Add following content.

        http_proxy=http://100.100.100.100:8000/
        https_proxy=http://100.100.100.100:8000/
        no_proxy="localhost,127.0.0.1,cluster.local,bcmt.cluster.local,<internal_service_ips>"

        export http_proxy https_proxy no_proxy
    
        # source ~/.profile

3. Configure docker proxy for all cluster nodes.

        # mkdir -p /etc/systemd/system/docker.service.d
        # vi /etc/systemd/system/docker.service.d/proxy.conf

    Add following content:

        [Service]
        Environment="HTTP_PROXY=http://100.100.100.100:8000/" "HTTPS_PROXY=http://100.100.100.100:8000/" "NO_PROXY=localhost,127.0.0.1,cluster.local,bcmt.cluster.local,bcmt-registry:5000,<internal_service_ips>"

    Restart docker:

        systemctl daemon-reload
        systemctl restart docker

### Run conformance test

1. Download binary sonobuoy of the release v0.17.2.

2. Run sonobuoy.

        # sonobuoy run --mode=certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=is_control,is_edge"

3. View actively running pods:

        # sonobuoy status

4. To inspect the logs:

        # sonobuoy logs

5. Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

        # sonobuoy retrieve .

    This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

        mkdir ./results; tar xzf *.tar.gz -C ./results

    !!! note
        The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

6. To clean up Kubernetes objects created by Sonobuoy, run:

        # sonobuoy delete
