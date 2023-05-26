# How to review conformance results

## Technical Requirements

The technical requirements for a conformance submission are described in the [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) file. The [prow.cncf.io bot](https://github.com/apps/prow-cncf-io) verifies conformance product submissions against these [requirements](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#requirements).

If any of the requirements are not met the [prow.cncf.io bot](https://github.com/apps/prow-cncf-io) will add a `not-verifiable` label to the PR and comment with explanations for all requirements that have not been met. The bot will however add `labels` for all requirements that have been met along with the `not-verifiable` label.  The user can **force push** updated files to address the errors highlighted by bot.

Once the bot finds all requirements have been met the `not-verifiable` label would be removed and applicable labels will be added.

A PR meeting all the technical requirement would have the following labels:
- `conformance-product-submission`
- `no-failed-tests-v1.xx`
- `release-documents-checked`
- `release-v1.xx`
- `tests-verified-v1.xx`

If a PR does not have a `not-verifiable` label and all other required labels are present, the technical verification is complete.

## Policy Requirements

1. Confirm that the vendor is currently a
[member](https://www.cncf.io/about/members/) of CNCF. If they are not, request
that they reach out to memberships@cncf.io to become a member in order to
complete their certification. (Companies can alternatively pay a certification
fee equal to the cost of membership if, for whatever reason, they don't wish to
become a CNCF member.) Alternatively, non-profit organizations (including community
distributions like Debian) can certify at no cost.

Review the `PRODUCT.yaml` file, and:

2. Verify that there is a Participation Form on file for the `vendor`, and that
the vendor is in good standing in the program.

3. Verify the product `name` and `website_url` are listed in the
"Qualifying Offerings" section of the vendor's Participation Form, i.e. that
the `name` and `website_url` are listed.

4. Review the `name`. If it contains the word "Kubernetes" in a non-descriptive
fashion, verify that the `name` is listed in "Participant Kubernetes
Combinations" section of the vendor's Participation Form.

If the submission doesn't meet all policy requirements, reply with a message indicating "Signed participation form needed", "Files missing from PR", "Membership in CNCF or confirmation of non-profit status needed", etc.

## Tasks to Complete After Review

1. Update the Kubernetes Distributions & Platforms [spreadsheet](https://docs.google.com/spreadsheets/d/1uF9BoDzzisHSQemXHIKegMhuythuq_GL3N1mlUUK2h0/edit?usp=sharing) to reflect the vendor's certified offering.

2. Add the vendor's information to the [CNCF landscape](https://landscape.cncf.io/grouping=landscape&landscape=certified-kubernetes-distribution,certified-kubernetes-hosted,certified-kubernetes-installer) which also causes them to appear on https://www.cncf.io/certification/software-conformance/ and https://kubernetes.io/partners/#conformance.

3. Add a comment saying "You are now Certified Kubernetes" and merge the PR.
