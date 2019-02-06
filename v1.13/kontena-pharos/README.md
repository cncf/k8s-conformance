# Conformance testing Kontena Pharos

## Setup Kontena Pharos cluster

Setup Kontena Pharos cluster as per the [Pharos documentation](https://www.pharos.sh/docs/). To run conformance tests, we recommend that you use a cluster that provides sufficient resources.

## Run conformance tests

Download latest version of Heptio Sonobuoy tool from [here](https://github.com/heptio/sonobuoy/releases/latest).

Start the conformance tests on your Kontena Pharos cluster

```sh
$ sonobuoy start
```

View status:

```sh
$ sonobuoy status
```

View logs:

```sh
$ sonobuoy logs
```

Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

```sh
$ sonobuoy retrieve .
```