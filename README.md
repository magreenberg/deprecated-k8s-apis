# List Generation (Optional)
Connect to the OpenShift base cluster and run the following from a `bash` shell:
```bash
scripts/all-api-versions | sort > base-cluster-api-versions.txt
```
Connect to an OpenShift cluster with the target version and run:
```bash
scripts/all-api-versions | sort > target-cluster-api-versions.txt
```
Identify the list of APIs that are not available in the target cluster using:
```bash
comm -23 base-cluster-api-versions.txt  target-cluster-api-versions.txt > deprecated-apis.txt
```
For example, when comparing Kubernetes 1.21 with Kubernetes 1.22 the contents of the file `deprecated-apis.txt` might be similar to the following:
```
apiservices                          apiregistration.k8s.io/v1beta1
certificatesigningrequests           certificates.k8s.io/v1beta1
clusterrolebindings                  rbac.authorization.k8s.io/v1beta1
clusterroles                         rbac.authorization.k8s.io/v1beta1
csidrivers                           storage.k8s.io/v1beta1
csinodes                             storage.k8s.io/v1beta1
customresourcedefinitions            apiextensions.k8s.io/v1beta1
ingressclasses                       networking.k8s.io/v1beta1
ingresses                            extensions/v1beta1
ingresses                            networking.k8s.io/v1beta1
leases                               coordination.k8s.io/v1beta1
localsubjectaccessreviews            authorization.k8s.io/v1beta1
mutatingwebhookconfigurations        admissionregistration.k8s.io/v1beta1
priorityclasses                      scheduling.k8s.io/v1beta1
rolebindings                         rbac.authorization.k8s.io/v1beta1
roles                                rbac.authorization.k8s.io/v1beta1
selfsubjectaccessreviews             authorization.k8s.io/v1beta1
selfsubjectrulesreviews              authorization.k8s.io/v1beta1
storageclasses                       storage.k8s.io/v1beta1
subjectaccessreviews                 authorization.k8s.io/v1beta1
tokenreviews                         authentication.k8s.io/v1beta1
validatingwebhookconfigurations      admissionregistration.k8s.io/v1beta1
volumeattachments                    storage.k8s.io/v1beta1
```
# Identifying Deprecated APIs
Run the script `scripts/find-deprecated-apis.sh` and pass as an argument the deprecated API list generated from the step above or created manually. For example:
```bash
scripts/find-deprecated-apis.sh deprecated-apis.txt
```
Check the output of the for lines similar to:
```
=== ingresses.v1beta1.extensions ===
VERBS       USERNAME                        USERAGENT
list watch  system:kube-controller-manager  cluster-policy-controller/v0.0.0
list watch  system:kube-controller-manager  kube-controller-manager/v1.21.8+ed4d8fd
```
Messages of the form `Error from server (NotFound)` can be ignored.

Refer to the document [Preparing to upgrade to OpenShift Container Platform 4.9](https://access.redhat.com/articles/6329921) regarding which messages can be ignored.