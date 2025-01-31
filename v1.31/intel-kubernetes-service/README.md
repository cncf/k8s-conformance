Intel Kubernetes Service 
 
To get started, you will first need to set up an Intel Cloud account and log into the console. Once you log in, please refer to the steps shown below to create your Kubernetes cluster and run the conformance tests. 
 
Create a new Kubernetes Cluster 
To create a new cluster using Intel Kubernetes Service, click on the menu item in the left hand side navigation that says ‘Intel Kubernetes Service’. This will open a  product page on the right , providing you graphical representation of all the major steps involved in creating and using the cluster. On this page, click on the button “Launch Cluster”. This will open a form requesting a cluster name and Kubernetes version. Once you select the options and click on the “Launch” button, it will take you to the list cluster page. On this page, please wait for cluster to be in “Active” state and then click on “Download” link under kube Config column. Please refer to documentation here for detailed step by step instructions with screen shots. 
 
Running conformance tests 
Once you set up your kubeconfig file for use by setting up as KUBECONFIG environment variable (see more details in how to connect section) , please follow the k8s-conformance test instructions to run the conformance tests.

