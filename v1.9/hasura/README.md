# Hasura

## Reproducing conformance tests

1. [Install Hasura CLI](https://docs.hasura.io/0.15/platform/manual/install-hasura-cli.html)

2. Login/signup with hasura
  ```bash
  hasura login
  ``` 

3. Create a Pro-Tier Hasura cluster after enabling billing (https://dashboard.hasura.io/account/billing)
  ```bash
  hasura cluster create --infra=MPGQSC
  # MPGQSC is infra code for 4vCPU 8GB RAM machine on Digital Ocean (SFO2)
  # this will create a kubectl context in the system with same name as that of the cluster
  ```

4. Launch the tests
  ```bash
  curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl --context=[cluster-name] apply -f -
  ```
