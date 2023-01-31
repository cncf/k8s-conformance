Conformance tests for MacStadium's Orka

Orka is MacStadium's Orchestration with Kubernetes on Apple hosted platform. A platform designed to allow iOS/MacOS customers to uses docker wrapped, Kubernetes orchestrated Mac OS on genuine Apple hardware.

To setup the initial Orka cluster you will need to contact MacStadium as we deploy and configure the Apple-based metal with the Kubernetes version pre-deployed. Proper steps are:

1.  Contact MacStadium for an Orka cloud [Orka](http://www.macstadium.com/orka)
2.  Select a region (US East/US West/Europe) and cluster size/type (2013 MacPro or 2018 mini)
3.  Login to customer portal upon notification to receive IP and credential information [MacStadium Customer Portal](https://portal.macstadium.com/login)
4.  Configure your VPN connection via these instructions [Cluster VPN Configuration](https://orkadocs.macstadium.com/docs/vpn-connect)
5.  Leverage your Kubernetes cluster via these instructions [Kubernetes Orka Configuration Docs](https://orkadocs.macstadium.com/docs/tapping-into-kubernetes)

For Conformance we run the following cluster setup command:

```
kubeadm init --config <config> --upload-certs
```

Run Conformance Test
Access MacStadium
On the new Kubernetes cluster run the Conformance tests using the following command (use private yaml):

```
sonobuoy run --mode=certified-conformance
```

Watch Sonobuoy's status with:

```
sonobuoy status
```

Retreive the results files by using:

```
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```
