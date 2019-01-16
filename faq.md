# Frequently Asked Questions

## What is the cost of certification?

For [members](https://www.cncf.io/about/members/) of the Cloud Native Computing Foundation, there is no charge for
certification. There is also no charge for non-profit organizations. For commercial organizations that wish to
certify but don't want to become a CNCF member, the fee is the same as [joining](https://www.cncf.io/about/join/) the CNCF.

## What about community distributions?

A community distribution does not have a company behind it.
For the purposes of certification, we treat community distributions/installers as non-profit organizations, so
there is no charge. However, we do require an individual to complete the certification
[agreement](./participation-form/Certified_Kubernetes_Form.md) so
that we have an official contact (or multiple contacts) if your software falls out of compliance.

## How can I track issues that have been opened regarding certification?

When a product fails certification, the issue could be in the implementation or in the conformance
tests. We use a [tracking issue](https://github.com/cncf/k8s-conformance/issues/27) to record issues with the
tests.

## What versions of Kubernetes can be certified?

You can certify the currently released version and the two versions before that. The currently released version is the number at the top right of https://kubernetes.io/. Already certified implementations remain certified as long as a newer version is certified at least once a year after the initial certification.

## Can I certify my private cloud that will not be available outside of our company?

You can, but it requires membership in CNCF. Instead, you may be able to accomplish your goal of ensuring conformance
simply by [running](instructions.md) the conformance tests on your private cloud. As long as you pass, your
implementation is conformant. It can't be certfied unless you complete the participation form, but certification
(and the ability to use the Certified Kubernetes mark) is probably unnecessary for an internal-only product.

## What is a distribution, hosted platform, and an installer?

From the bottom of the Kubernetes Distributions & Platforms [spreadsheet](https://docs.google.com/spreadsheets/d/1LxSqBzjOxfGx3cmtZ4EbB_BGCxT_wlxW_xgHVVa23es/edit#gid=0):

* A **vendor** is an organization providing a Kubernetes distribution, hosted platform, or installer.
* A **product** is a distribution, hosted platform, or installer provided by a vendor.	
* A **distribution** is software based on Kubernetes that can be installed by an end user on to a public cloud or bare metal and includes patches, additional software, or both.	
* A **hosted** platform is a Kubernetes service provided and managed by a vendor.	
* An **installer** downloads and then installs vanilla upstream Kubernetes.	

## What are the additional naming options for Certified Kubernetes?

Certified Kubernetes products may use the word Kubernetes in their product name. E.g., Acme Kubernetes Engine or Acme Kubernetes. See this [section](https://github.com/cncf/k8s-conformance/blob/master/terms-conditions/Certified_Kubernetes_Terms.md#use-of-the-certified-kubernetes-marks-and-participant-kubernetes-combinations) of the terms and conditions for the exact details.

## Do I need to re-submit results if we rebrand our offering?

No. If the software is the same, and just the name has changed, you just need to submit a revised Participation Form available at https://github.com/cncf/k8s-conformance/blob/master/participation-form/Certified_Kubernetes_Form.md that includes the new name. Please also open a pull request to update the name in your PRODUCT.yaml file. We do ask that you send us the new Participation Form **prior** to announcing the name change. You can submit the pull request after the announcement, if necessary.

## I still have questions. Can you help?

Yes. Please email us at conformance@cncf.io.
