# Introduction
This repository provides scripts and data used to determine whether deprecated APIs are being used on a Kubernetes cluster.

Documentation on Kubernetes deprecated APIs can be found in the [Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/).
That being said, it has been found that APIs were deprecated without appearing in the document. The first section of this document provides a procedure that compares all available APIs in different Kubernetes versions and identifies which were removed between consecutive version. The scripts used for this procedure are present here for the use of the user. The scripts have been run on Kubernetes version 1.22 through 1.27 and the results are available in the [deprecated](./deprecated) directory.

The second section of the documents checks whether any of the deprecated APIs were created/queried in the previous 24 hours.

## Notes on Kubernetes Handling Deprecated APIs
As discussed in [Kubernetes Issue 58131](https://github.com/kubernetes/kubernetes/issues/58131), Kubernetes stores API instances in `etcd` using the latest version. Therefore, for exampl,e if a deprecated CronJob instance is created with `apiVersion: batch/v1beta1`, from Kubernetes 1.21 and newer, the API would be stored internally as `apiVersion: batch/v1`. Similarly, if deprecated instances of CronJobs are queried using `kubectl get --all-namespaces cronjobs.v1beta1.batch`, CronJobs with `apiVersions: batch/v1` will also be listed.

In order to indentify if/when deprecated APIs are used, Kubernetes keeps a counter of the usage with some additional information. The data is stored for up to 24 hour after the last API usage.

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