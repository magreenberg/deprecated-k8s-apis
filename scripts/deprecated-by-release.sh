#!/bin/bash
RELEASES="
kindest/node:v1.21.14@sha256:220cfafdf6e3915fbce50e13d1655425558cb98872c53f802605aa2fb2d569cf
kindest/node:v1.22.17@sha256:9af784f45a584f6b28bce2af84c494d947a05bd709151466489008f80a9ce9d5
kindest/node:v1.23.17@sha256:f77f8cf0b30430ca4128cc7cfafece0c274a118cd0cdb251049664ace0dee4ff
kindest/node:v1.24.13@sha256:cea86276e698af043af20143f4bf0509e730ec34ed3b7fa790cc0bea091bc5dd
kindest/node:v1.25.9@sha256:c08d6c52820aa42e533b70bce0c2901183326d86dcdcbedecc9343681db45161
kindest/node:v1.26.4@sha256:f4c0d87be03d6bea69f5e5dc0adb678bb498a190ee5c38422bf751541cebe92e
kindest/node:v1.27.1@sha256:b7d12ed662b873bd8510879c1846e87c7e676a79fefc93e17b2a52989d3ff42b
"

unset LAST_VERSION
for release in ${RELEASES};do
    VERSION="${release:14:4}"
    #echo "processing Kubernetes ${VERSION}"
    kind -v 0 -q create cluster --name "${VERSION}" --image "${release}"
    kubectl config set-context kind-"${VERSION}" > /dev/null 2>&1
    scripts/all-api-versions | sort > "/tmp/${VERSION}.txt"
    kind -v 0 -q delete cluster --name "${VERSION}"
    if [ -n "${LAST_VERSION}" ];then
        # echo "API deprecated in Kubernetes version ${VERSION}"
        comm -23 "/tmp/${LAST_VERSION}.txt" "/tmp/${VERSION}.txt" > "${VERSION}-deprecated.txt"
    fi
    LAST_VERSION="${VERSION}"
done
