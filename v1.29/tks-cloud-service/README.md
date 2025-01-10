# TKS Cloud Service

## Join the TKS

To use TKS Cloud Service(hereafter TKS), you should get account to serve tks service.
TKS is designed for B2B customer. You can get serivce account to call +8215990611 or email to tks-support@sktelecom.com

You will receive the information needed to log in using your registered email address.
OrganiationID, User, Password
You must change your password when logging in for the first time.

## Cloud Account Configuration

First, you should login tks (https://tks-console.sktenterprise.com/login)

You need to create a Cloud Account to create a public cloud environment where Stack is installed.
TKS currently supports AWS.
Stack is a term used in TKS and includes both Kuberentes and services and add-ons for operation.

Click the settings menu represented by the gear icon on the top menu bar, and then select Cloud Account on the right menu bar.

When you click the Create button, the cloud account creation window will appear.
Since the only public cloud currently provided is AWS, enter the necessary information based on AWS.

In order to obtain the information required for input, you must do the following in your AWS Account in advance.

1. Create IAM User
2. Assign AdministratorAccess Policy on the IAM User
3. Creat Access Key Pair (ID/Secret)
4. Create Pulbic Key pair
   . The key pair is used to create EC2 instance for SSH
   . pem key name must set to "tks-seoul"

TKS uses the customer's AWS Access Key to create and use an AWS Assume Role to create and manage AWS resources.

Assume Role is a temporary credential method provided by AWS and is a highly secure method that can be used without storing the customer's key.
After creation, the Secret Access Key is exposed only once, so please store and manage it well.

## Create Stack

Select the stack menu marked with Stack Icon from the top menu bar.
Click the Create button.

1. Environment setting
   After entering management information such as the stack name, select AWS as the installation environment.
   Click the Next button.

2. Select Stack Template
   Select AWS standard. AWS Standard is a basic STACK that uses AWS as the control plane and sets the necessary add-ons and monitoring pipeline.
   Click the Next button.

3. Stack properties
   Set up a pre-created Cloud Account and enter the number of EC2 instances the user will use.
   Click the Check Available Resources button to check whether the selected Cloud Account has sufficient resources.
   Click the Next button.

4. Select Policy Temple
   This is the step of selecting a policy template for Kuberntes Admission control. Don't select it for quick execution.
   Click the Next button.

5. Select Policy
   Select the required policy among the policies included in the Policy Template and change the required attribute values. To speed things up, skip this step.
   Click the Next button.

6. Review & Create
   After viewing and reviewing Sumary, click the Create button to start creating. This operation takes approximately 30 minutes to 1 hour, and this time varies depending on the CSP situation.

## Login The Stack

TKS uses the oidc-login kubectl plugins. Please install by referring to the link below.
https://github.com/int128/kubelogin

Select the stack menu marked with Stack Icon from the top menu bar.
Click the created STACK Tile.
Click the download kubeconfig button to download the Kubeconfig file.
When running kubectl cli based on the downloaded Kubeconfig file, follow the prompt that appears and log in using the user account ID/PW created earlier.

## Run conformance tests

```shell
$ curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
$ tar xvfz sonobuoy_0.57.1_linux_amd64.tar.gz
$ ./sonobuoy run --mode=certified-conformance --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig
$ ./sonobuoy status --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig
$ ./sonobuoy retrieve --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig

```
