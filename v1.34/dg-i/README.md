# DG-i Kubernetes Platform conformance tests

- Contact [DG-i](https://www.dg-i.net/en/company/contact) to order a DG-i Kubernetes Platform.
- Obtain the cluster's `kubeconfig` from the project's Git repository or from your technical contact.
- Authenticate with a user who has cluster-admin permissions.
- Install Sonobuoy by downloading a binary release of the CLI or building it yourself.
- Deploy a Sonobuoy pod to your cluster: `sonobuoy run --mode=certified-conformance`
- Observe the Sonobuoy run: `sonobuoy status`
- Once Sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory: `outfile=$(sonobuoy retrieve)`
- Extract the contents: `mkdir ./results; tar xzf $outfile -C ./results`
- Copy the files required for submission: `cp results/plugins/e2e/results/global/{e2e.log,junit_01.xml} .`
- Cleanup: `rm -rf results/ $outfile`
- Clean up Kubernetes objects created by Sonobuoy: `sonobuoy delete`
