# Hasura

## Reproducing conformance tests

1. [Install Hasura CLI](https://docs.hasura.io/0.15/manual/install-hasura-cli.html)

2. Login/signup with hasura
  ```bash
  $ hasura login
  ``` 

3. Create a free Hasura cluster
  ```bash
  $ hasura cluster create --type=vps
  # this will add a kubectl context to the system with same name as that of the cluster
  ```

4. Launch the tests
  ```bash
  $ kubectl --context=[cluster-name] apply -f sonobuoy-conformance.yaml
  ```
(using a custom yaml file with RBAC disabled)
