Conformance tests for MacStadium's Orka

Orka is MacStadium's Orchestration with Kubernetes on Apple hosted platform.  A platform designed to allow iOS/MacOS customers to uses docker wrapped, Kubernetes orchestrated Mac OS on genuine Apple hardware.

Run Conformance Test
Access MacStadium 
On the new Kubernetes cluster run the Conformance tests using the following command (use private yaml):

kubectl apply -f sonobuoy.yaml
Watch Sonobuoy's logs with:

kubectl logs -f -n heptio-sonobuoy e2e sonobuoy
Wait for the line no-exit was specified, sonobuoy is now blocking, and then copy the results
