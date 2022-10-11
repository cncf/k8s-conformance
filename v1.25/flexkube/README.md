How to validate / reproduce [CNCF Kubernetes Conformance](https://github.com/cncf/k8s-conformance):

Make sure following software is installed and configured on your local machine:
- [make](https://www.gnu.org/software/make/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [vagrant](https://www.vagrantup.com/docs/installation/)

Clone [flexkube/libflexkube](https://github.com/flexkube/libflexkube) repository by running the following command:
```sh
git clone https://github.com/flexkube/libflexkube.git
```

Then, change working directory to cloned repository:
```sh
cd libflexkube
```

Then, checkout the desired version to run tests on:
```sh
git checkout v0.9.0
```

And run the following command, which will setup local cluster using VirtualBox and Vagrant and run conformance tests on it:
```sh
make vagrant-conformance
```

After finished testing, results archive file will be copied to your working directory.

Now, follow https://github.com/cncf/k8s-conformance/blob/master/instructions.md#uploading to submit the results.

For more information, see https://github.com/flexkube/libflexkube/blob/master/README.md.
