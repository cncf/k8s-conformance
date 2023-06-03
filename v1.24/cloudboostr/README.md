# Cloudboostr 2.3.0


Clouboostr is an enterprise multicloud Kubernetes distribution.

## Installing Cloudboostr

Below instructions describe how to install on AWS. If you would like to use different provider go [here](https://docs.cloudboostr.com/installation/resource_requirements/).

### Required tools
- yq ([download link](https://github.com/mikefarah/yq/releases/download/1.14.1/yq_linux_amd64))
- terraform version 0.13.x ([download link](https://releases.hashicorp.com/terraform/0.13.5/))
- python and pip configured ([download link](https://www.python.org/downloads/))
- aws cli ([instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html))

### Prepare SSH keys
First step is to prepare SSH keys that will be used for jumpbox and bosh connection. Also GIT key is required for terraform and scripts to download the required repositories.

If SSH keys were prepared before hand or are being created by external tool like Vault skip this and go to the [next step](#upload-keys).

```bash
# Create SSH keys

export EMAIL=[YOUR_EMAIL_HERE]
mkdir keys
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ./keys/jumpbox_devops -N '' -m pem
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ./keys/bosh_devops -N '' -m pem
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ./keys/git_private_key -N '' -m pem
```

### Upload keys
Then keys should be uploaded to the `sensitive-data` container. Filenames and container name can be changed in configuration if required.

```bash
aws s3 cp ./keys/bosh_devops         s3://sensitive-data/bosh_devops
aws s3 cp ./keys/bosh_devops.pub     s3://sensitive-data/bosh_devops.pub
aws s3 cp ./keys/jumpbox_devops      s3://sensitive-data/jumpbox_devops
aws s3 cp ./keys/jumpbox_devops.pub  s3://sensitive-data/jumpbox_devops.pub
aws s3 cp ./keys/git_private_key     s3://sensitive-data/git_private_key
aws s3 cp ./keys/git_private_key.pub s3://sensitive-data/git_private_key.pub
```

### Required Cloudboostr packages
```bash
/aws/latest/cb-bosh-deployment-latest.tgz
/aws/latest/cb-cf-deployment-latest.tgz
/aws/latest/cb-concourse-deployment-latest.tgz
/aws/latest/cb-dns-deployment-latest.tgz
/aws/latest/cb-docker-images-latest.tgz
/aws/latest/cb-elk-deployment-latest.tgz
/aws/latest/cb-env-latest.tgz
/aws/latest/cb-installer-latest.tgz
/aws/latest/cb-k8s-deployment-latest.tgz
/aws/latest/cb-opscontrol-latest.tgz
/aws/latest/cb-prometheus-deployment-latest.tgz
/aws/latest/cb-utils-latest.tgz
/aws/latest/cb-vault-deployment-latest.tgz
```

### Unpack packages
```bash
tar -zxvf cb-installer-latest.tgz
mkdir cloudboostr
./unpackage.sh . cloudboostr latest
```

Navigate to `cb-opscontrol/terraform/aws`.

### Configure terraform
Create file **terraform.tfvars** based on **terraform.tfvars.example** from `aws` directory.

<details>
<summary>Example terraform.tfvars</summary>

```bash
### AWS PROVIDER ########################################################
# AWS access_key for the account                 [REQUIRED]
aws_access_key = ((aws_access_key))

# AWS secret for the account                     [REQUIRED]
aws_secret_key = ((aws_secret_key))

# AWS region                                     [REQUIRED]
aws_region = ((aws_region))

# List of Availability Zones                     [REQUIRED]
azs = ((azs))

# AWS account ID                                 [REQUIRED]
aws_account_id = ((aws_account_id))

### LOAD BALANCERS ######################################################
concourse_certificate_arn = ((concourse_certificate_arn))
grafana_certificate_arn = ((grafana_certificate_arn))
control_plane_certificate_arn = ((control_plane_certificate_arn))
uaa_certificate_arn = ((uaa_certificate_arn))

### SECURITY GROUPS #####################################################
# IP address or range allowed to access jumpbox
jumpbox_whitelist_ssh_in = ((jumpbox_whitelist))

### DNS #################################################################
# DNS domain for externaly accessible services   [REQUIRED]
opscontrol_base_domain = ((opscontrol_base_domain))

# Floating IP created manually for the DNS       [REQUIRED]
dns_instance_public_ip = ((dns_instance_public_ip))

### CUSTOM SCRIPTS ######################################################
# Jumpbox VM type                                [REQUIRED]
jumpbox_instance_type = ((jumpbox_instance_type))

# BOSH Director VM type                          [REQUIRED]
bosh_instance_type = ((bosh_instance_type))

# AZ for bosh VMs                                [REQUIRED]
bosh_vm_az = ((bosh_vm_az))

### DEPLOYMENTS CONFIG ##################################################
# Git repository address for the config files    [REQUIRED]
config_repository_url = ((config_repository_url))

# Git repository branch for the config files     [REQUIRED]
config_repository_branch = ((config_repository_branch))

### BACKUP AND RESTORE ##################################################
# Bucket for Prometheus/Grafana backup
prometheus_backup_bucket_name = ((prometheus_backup_bucket_name))

# Bucket for ELK backup (can be shared with Prometheus)
elk_backup_bucket_name = ((elk_backup_bucket_name))

sensitive_data_storage_container_name = ((sensitive_data_storage_container_name))

### PACKAGES ############################################################
# Packages bucket configuration
cb_deployments_package_bucket = ((cb_deployments_package_bucket))
cb_deployments_package_target_cloud = ((cb_deployments_package_target_cloud))
cb_deployments_package_version = ((cb_deployments_package_version))
```

</details>

The full list of configuration parameters can be found [here](https://docs.cloudboostr.com/installation/configuration/opscontrol/introduction/).

### Environment configuration

Envs configuration is based on GIT repositories with [JSON](https://www.json.org/) configuration files. Starting point of the configuration (main repository) is configured in OpsControl configuration.

When the env is configured the repository is clonned, `config.json` file from the root directory loaded and appropriate Concourse teams and Vault variables created.

More details can be found [here](https://docs.cloudboostr.com/installation/configuration/environments/environments-configuration/).

Configure environments for your purposes. The minimum configuration repository should contain below files:

```
$ ls -lR
-rw-r--r--  config.json
drwxr-xr-x  env1

./env1:
-rw-r--r--  common.json
drwxr-xr-x  infrastructure
drwxr-xr-x  bosh_deployments

./env1/infrastructure:
-rw-r--r--  env.json

./env1/bosh_deployments:
-rw-r--r--  k8s-deployment.json

```

<details>
<summary>config.json</summary>

```json
{
    "envs": [
         {
            "name": "env1",
            "backend_type": "aws",
            "config_repo_url": "git@gitrepository/cb-config",
            "config_repo_branch": "master"
        }
    ]
}
```

</details>

<details>
<summary>env1/common.json</summary>

```json
[
    {"name": "infrastructure_state_bucket_name", "value": "infrastructure-state.env1.aws"},
    {"name": "jumpbox_private_key", "opscontrol_var": "jumpbox_private_key"},

    {"name": "backups_bucket_name", "value": "backups.env1.aws"},

    {"name": "docker_password", "value": ""},
    {"name": "docker_username", "value": ""},
    {"name": "docker_url", "opscontrol_var": "registry_url"},

    {"name": "opscontrol_dns_public_ip", "opscontrol_var": "dns_instance_public_ip"},
    {"name": "dns_instance_public_ip", "value": "<IP_ADDRESS>"},
    {"name": "env_base_domain", "value": "<ENVIRONMENT_DOMAIN>"},

    {"name": "elk_deployment_enabled", "opscontrol_var": "elk_deployment_enabled"},

    {"name": "elasticsearch_host", "opscontrol_var": "elasticsearch_host"},
    {"name": "elasticsearch_port", "opscontrol_var": "elasticsearch_port"},

    {"name": "syslog_host", "opscontrol_var": "syslog_host"},
    {"name": "syslog_port", "opscontrol_var": "syslog_port"},

    {"name": "consul_ip", "opscontrol_var": "consul_ip"},

    {"name": "concourse_url", "opscontrol_var": "concourse_url"},
    {"name": "uaa_url", "opscontrol_var": "uaa_url"},

    {"name": "ssh_allowed_hosts", "opscontrol_var": "ssh_allowed_hosts"}
]
```

</details>

<details>
<summary>env1/infrastructure/env.json</summary>

```json
{
    "source_type": "package",
    "package_bucket": "<BUCKET_WITH_PACKAGES>",
    "package_target_cloud": "aws",
    "package_version": "latest",

    "pipelines": [
        {
            "name": "deploy_bosh",
            "file": "ci/pipelines/aws/deploy-pipeline.yml",
            "vars": []
        },
        {
            "name": "destroy_env",
            "file": "ci/pipelines/aws/destroy-pipeline.yml",
            "vars": []
        },
        {
            "name": "backup_bosh",
            "file": "ci/pipelines/backup-pipeline.yml",
            "vars": [
                {"name": "timer_interval", "value": "24h"}
            ]
        },
        {
            "name": "restore_latest_bosh",
            "file": "ci/pipelines/restore-latest-pipeline.yml",
            "vars": []
        },
        {
            "name": "restore_custom_bosh",
            "file": "ci/pipelines/restore-custom-pipeline.yml",
            "vars": []
        }
    ],

    "vars": [
        {"name": "aws_access_key", "opscontrol_var": "aws_access_key"},
        {"name": "aws_secret_key", "opscontrol_var": "aws_secret_key"},
        {"name": "aws_region", "opscontrol_var": "aws_region"},
        {"name": "aws_account_id", "opscontrol_var": "aws_account_id"},

        {"name": "azs", "value": "[eu-west-1b, eu-west-1c]"},

        {"name": "opscontrol_cidr", "opscontrol_var": "opscontrol_cidr"},
        {"name": "opscontrol_vpc_id", "opscontrol_var": "opscontrol_vpc_id"},
        {"name": "opscontrol_control_plane_route_table_id", "opscontrol_var": "opscontrol_control_plane_route_table_id"},
        {"name": "opscontrol_dmz_route_table_id", "opscontrol_var": "opscontrol_dmz_route_table_id"},

        {"name": "network_cidr", "value": "10.90.0.0/16"},

        {"name": "mgmt_subnet_cidr", "value": "10.90.1.0/26"},
        {"name": "mgmt_gateway_ip", "value": "10.90.1.1"},
        {"name": "mgmt_reserved_ips", "value": "10.90.1.2-10.90.1.10"},

        {"name": "dmz_subnet_cidr", "value": "10.90.2.0/26"},
        {"name": "dmz_gateway_ip", "value": "10.90.2.1"},
        {"name": "dmz_reserved_ips", "value": "10.90.2.2-10.90.2.20"},

        {"name": "services_subnet_cidr", "value": "10.90.4.0/22"},
        {"name": "services_gateway_ip", "value": "10.90.4.1"},
        {"name": "services_reserved_ips", "value": "10.90.4.2-10.90.4.20"},

        {"name": "cf_subnet_cidr", "value": "10.90.16.0/22"},
        {"name": "cf_gateway_ip", "value": "10.90.16.1"},
        {"name": "cf_reserved_ips", "value": "10.90.16.2-10.90.16.20"},

        {"name": "k8s_subnet_cidr", "value": "10.90.32.0/22"},
        {"name": "k8s_gateway_ip", "value": "10.90.32.1"},
        {"name": "k8s_reserved_ips", "value": "10.90.32.2-10.90.32.20"},

        {"name": "k8s_public_subnet_cidr", "value": "10.90.48.0/22"},

        {"name": "jumpbox_instance_type", "value": "t2.small"},
        {"name": "jumpbox_whitelist", "value": "[0.0.0.0/0]"},

        {"name": "bosh_private_ip", "value": "10.90.1.6"},
        {"name": "bosh_instance_type", "value": "t2.small"},
        {"name": "bosh_director_name", "value": "bosh"},

        {"name": "cf_certificate_arn", "value": "arn:aws:acm:eu-west-1:XXXXXXXXXXXX:certificate/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"},
        {"name": "k8s_certificate_arn", "value": "arn:aws:acm:eu-west-1:XXXXXXXXXXXX:certificate/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"},

        {"name": "git_private_key", "opscontrol_var": "git_private_key"},
        {"name": "jumpbox_public_key", "opscontrol_var": "jumpbox_public_key"},
        {"name": "jumpbox_private_key", "opscontrol_var": "jumpbox_private_key"},
        {"name": "bosh_private_key", "opscontrol_var": "bosh_private_key"},
        {"name": "bosh_public_key", "opscontrol_var": "bosh_public_key"},

        {"name": "ssh_allowed_hosts", "opscontrol_var": "ssh_allowed_hosts"}
    ]
}
```

</details>

<details>
<summary>env1/bosh_deployments/k8s-depoloyment.json</summary>

```json
{
    "source_type": "package",
    "package_bucket": "<BUCKET_WITH_PACKAGES>",
    "package_target_cloud": "aws",
    "package_version": "latest",

    "pipelines": [
        {
            "name": "deploy_k8s",
            "file": "ci/pipelines/deploy-pipeline/deploy-pipeline-aws.yml",
            "vars": []
        },
        {
            "name": "backup_k8s",
            "file": "ci/pipelines/backup-pipeline.yml",
            "vars": [
                {"name": "timer_interval", "value": "24h"}
            ]
        },
        {
            "name": "restore_latest_k8s",
            "file": "ci/pipelines/restore-latest-pipeline.yml",
            "vars": []
        },
        {
            "name": "restore_custom_k8s",
            "file": "ci/pipelines/restore-custom-pipeline.yml",
            "vars": []
        },
        {
            "name": "smoke_tests_k8s",
            "file": "ci/pipelines/smoke-tests-pipeline.yml",
            "vars": [
                {"name": "timer_interval", "value": "15m"}
            ]
        }
    ],

    "vars": [
        {"name": "k8s_masters", "value": "1"},
        {"name": "k8s_workers", "value": "3"},
        {"name": "k8s_masters_type", "value": "general_small"},
        {"name": "k8s_workers_type", "value": "storage_large"},
        {"name": "k8s_network_name", "value": "k8s"},
        {"name": "k8s_network_sg", "value": "k8s-sg"},
        {"name": "traefik_certificate_bucket", "value": ""},
        {"name": "traefik_certificate_files", "value": ""},
        {"name": "insecure_registries", "value": ""},
        {"name": "extensions_bucket_name", "value": ""},
        {"name": "extensions_k8s_directory", "value": ""},
        {"name": "extensions_k8s_properties", "value": ""},
        {"name": "extensions_provider_directory", "value": ""},
        {"name": "extensions_provider_properties", "value": ""}
    ]
}
```

</details>

### Run terraform
Start the deployment operation in directory "terraform" in the OpsControl repository:

```bash
terraform init
terraform apply
```

### Environment deployment
Environments are deployed using Concourse CI/CD tool. Each environemnt has its own set of credentials and a team in the Concourse. In addition the main team has access to all other teams.

To create the whole environment follow the steps:

1. Log in to Concourse using environment team credentials (or main team).

Concourse address is `concourse.[opscontrol_base_domain]`, for example if the base domain is set to `cloudboostr.com` the concourse address would be `concourse.cloudboostr.com`.

!!! note "Credentials"

    Teams credentials are available in Vault. To access the data SSH to jumpbox and use following commands:
    ```bash
    vault_login
    vault kv get "<path>"
    ```

    If you don't know the team names it is possible to enumerate credentials using commands:
    ```bash
    vault_login
    vault kv list "<path>"
    ```

2. Unpause the "set-pipelines" pipeline using unpause button.

3. Run the pipeline using `acquire_locks` job and wait for the pipeline to finish.

4. Run `deploy_bosh` pipeline to install the whole environment infrastructure: BOSH, Jumpbox, DNS, Prometheus etc.

5. After `deploy_bosh` is done you can deploy Kubernetes using `deploy_k8s` pipeline.

The last step of both Kubernetes pipeline contains informations how to use the deployed platforms and admin credentials.

!!! note "Access Kubernetes"
    Kubernetes is automatically configured on environment jumpbox with kubectl preinstalled.

## Configuring Kubernetes
To configure Kubernetes cluster you can change the `k8s-deployment.json` file in your `env1/bosh_deployments` directory in the configuration repository.

You can simply change the number and size of master/worker nodes. You can configure `insecure_registries` or traefik default SSL certificates as well.

For more advanced configuration see [Kubernetes](https://docs.cloudboostr.com/operator_guide/configuration/bosh-deployments/k8s-deployment/) and [Extension Ops](https://docs.cloudboostr.com/operator_guide/customization/custom_ops_files/)

## Running conformance tests
1. Log in into kubernetes environment. For credentials follow instructions available [here](https://docs.cloudboostr.com/developer_guide/kubernetes/)
2. Download a [sonobuoy release](https://github.com/heptio/sonobuoy/releases)
3. Deploy a Sonobuoy pod

```
$ sonobuoy run --wait
```

4. Wait for the test to finish
5. Clean up the remains of the test framework:

```
sonobuoy delete --wait
```

Official instructions available [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).
