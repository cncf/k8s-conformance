# t8s Kubernetes Engine

## Create a cluster

1. Contact the teuto.net staff about creating an account,
   see <https://teuto.net/products-services/kubernetes/?lang=en>.
2. Then you can access our [customer portal](https://kundenportal.teuto.net).
3. After this you select the customer you wish to order the cluster for.
4. On this page on the left hand side you can go to Products/Kubernetes
5. Here you can order a new cluster
   1. currently you can't create a production cluster without contacting
      us; only a demo cluster is available below
6. On the cluster order page you need to supply the following info;
   - cluster name
   - in which cloud the cluster should run
   - on which update schedule the cluster should be
   - which SLA you want
7. And configure the nodepools with name, size and number of instances.
8. After having accepted our AGBs and terms of services you can order the
   cluster.
9. After the cluster has been created you can download the kubeconfig from
   the cluster details page.

## Run conformance tests

Follow the k8s-conformance
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
to run the conformance tests.

The output here was obtained with hydrophone 0.7.0 running on a
Kubernetes 1.35.2 cluster.
