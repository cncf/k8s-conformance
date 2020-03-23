#Reproducing test results.

#Initial cmp setup:
1.   Install Morpheus onto Ubuntu:
```console
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.5 LTS"
```

``
see instructions:
``
https://docs.morpheusdata.com/en/3.6.3/getting_started/installation/installation.html#ubuntu

2.  Connect to target clouds/hypervisors

``
see instructions:
``
https://docs.morpheusdata.com/en/3.6.3/integration_guides/Clouds/vmware/vmware.html

3.  (optional) connect external DNS:

``
see instructions:
``
https://docs.morpheusdata.com/en/3.6.3/integration_guides/integration_guides.html#dns

4.  (optional) connect external LB service:

``
see instructions:
``
https://docs.morpheusdata.com/en/3.6.3/integration_guides/integration_guides.html#load-balancers

5.  Use Morpheus KaaS builder to build new cluster based on CNCF compliant architecture
``
see instructions:
``
https://docs.morpheusdata.com/en/3.6.3/integration_guides/Containers/kubernetes.html


6.  SSH to one of the masters

#Sonobuoy test:

1.       $ wget https://github.com/heptio/sonobuoy/releases/download/v0.15.0/sonobuoy_0.15.0_linux_amd64.tar.gz
2.       $ tar -xzf sonobuoy_0.15.0_linux_amd64.tar.gz
3.       $ ./sonobuoy run
4.       $ ./sonobuoy status
5.       $ ./sonobuoy logs
6.       $ ./sonobuoy retrieve ./results
7.       # untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}

