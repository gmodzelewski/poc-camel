# Kaoto + Apache Camel JBang PoC repo

## install:

1. create namespace via `oc new-project camel-poc`
2. run `1-install.sh` file or rollout manually using whatever is written there
3. ???
4. Profit.

---

## Troubleshooting: 

- finalizer prevents deletion, for example the namespace (usually some pvcs)
  ```sh
  oc patch ns camel-k-poc  -p '{"metadata":{"finalizers": []}}' --type=merge
  ```

- invalid ownership metadata; label validation error: missing helm keys ...
  ```sh
  oc label ns openshift-tempo-operator app.kubernetes.io/managed-by=Helm meta.helm.sh/release-name=camel-k-poc
  oc annotate ns openshift-tempo-operator meta.helm.sh/release-name=camel-k-poc meta.helm.sh/release-namespace=devspaces-georg
  ```
  example:
  ```
  Subscription "amq-broker-rhel8" in namespace "openshift-operators" exists and cannot be imported into the current release: invalid ownership metadata; label validation error: missing key "app.kubernetes.io/managed-by": must be set to "Helm"; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "camel-k-poc"; annotation validation error: missing key "meta.helm.sh/release-namespace": must be set to "poc-camel-k"
  
  fix via:
  oc label sub amq-broker-rhel8 -n openshift-operators app.kubernetes.io/managed-by=Helm meta.helm.sh/release-name=camel-k-poc
  oc annotate sub amq-broker-rhel8 -n openshift-operators meta.helm.sh/release-name=camel-k-poc meta.helm.sh/release-namespace=poc-camel-k
  ```