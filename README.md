# Introduction
Documentation on Kubernetes deprecated APIs can be found in the [Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/). That being said, it has been found that APIs were deprecated without appearing in the document. The first section of this document describes how to generate a complete list of available Kubernetes APIs for a given Kubernetes version. This list can be compared to lists generated for newer versions of Kubernetes in order to find deprecated APIs.
# List of Deprecated APIs
The script [scripts/deprecated-by-release.sh](./scripts/deprecated-by-release.sh) creates Kubernetes clusters using the [kind](https://github.com/kubernetes-sigs/kind/) Kubernetes implementation, lists all available Kubernetes APIs and then compares the list with the list of APIs from the previous Kubernetes release.

The results of the script can be found in the [deprecated](./deprecated) directory.

# Identifying Deprecated APIs by Request Counts
Run the script [scripts/find-deprecated-apis-by-requestcount.sh](./scripts/find-deprecated-apis-by-requestcount.sh) and pass as an argument the deprecated API list generated from the step above or a file created manually. In order to find all deprecated APIs from Kubernetes 1.22 to 1.27 run:
```bash
cat deprecated/*.txt > deprecated-apis.txt
scripts/find-deprecated-apis-by-requestcount.sh deprecated-apis.txt
```
Check the output of the for lines similar to:
```
=== ingresses.v1beta1.extensions ===
VERBS       USERNAME                        USERAGENT
list watch  system:kube-controller-manager  cluster-policy-controller/v0.0.0
list watch  system:kube-controller-manager  kube-controller-manager/v1.21.8+ed4d8fd
```

Kubernetes components will be upgraded automatically and can be ignored. APIs used by operators and user applications should be updated before attempting a cluster upgrade.
<!--
# Identifying Deprecated APIs by Request Counts
Usage of this script is not recommended as it will generate statistics in the `Request Counts` described in the section above.

In order to find deprecated APIs that are currently in use run:
```bash
scripts/find-deprecated-apis-by-usage.sh deprecated-apis.txt
```
-->