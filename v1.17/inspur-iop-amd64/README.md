# Inspur Cloud Container Engine and Inpsur Open Platform

## Login or Create Account 

You'll first need to get started with Inspur Open Platform by setting up
an Inspur Cloud account if you don't have one before. For details, see the
[register](https://console1.cloud.inspur.com/document/account/1-registered.html)
instructions.

## Create a cluster

1、You should login into the website and go to the [console](https://console1.cloud.inspur.com/cks/#/cks-overview?region=cn-north-3);
2、Click the button "Buy Container Cluster"(![avatar](buy_cke.jpg)) to buy a cluster;
3、When you successfully complete the payment，you have your own cluster, and you can use ssh tool to login your cluster to publish your applications;

## Create an application

You can also create your own cluster applications with your console.

1、click the button named "Product and Service"
2、choose "Container Engine",then click "Applications"
3、Click the button "+ Create New" to create new applications;

when you successfully create an application, you can Click publish button to publish the application you just created to your cluster you just purchased;

## Run conformance tests

Wait for the cluster and all worker nodes to reach `running` state then follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.
