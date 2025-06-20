# Kaoto + Apache Camel JBang PoC repo

# Manual steps at install
- `oc edit -n openshift-tempo-operator cm tempo-operator-manager-config`
  set grafanaOperator feature gate to "true"

## Notes from last meetings
### 08-07
- Discussed
  - helm chart intro
  - walkthrough use cases
  - installation of infrastructure helm chart and kamel integrations on vw cluster worked
- todos:
    - Michael: 
      - fix bitbucket to openshift webhook connection (network restriction?) at cicd run
    - use cases: 
      - fix mqtt consumer url
      - file upload to minio use cases (5&7) run and hope it works
      - fill_bucket go app
      - exception handling -> when something breaks -> validate file/stacktrace?
    - grafana:
      - grafana is deployed twice? why? Operator is deployed in namespace only mode. Clusterwide grafana-operator installed?
      - grafana dashboard - no namespace. Permission error? 
      - add loki datasource
    - tempo: Find a way to set endpoint without the need to name the deployment namespace "poc-camel-k" in all use cases
      `--trait tracing.endpoint=http://tempo-tempo-distributor.poc-camel-k.svc.cluster.local:14268/api/traces`


    
---

# Internal repo things

## todo
- line 7 in postgresql route --> use datasource environment variable
- set used images in values.yaml

## Issues to fix
- better automation
  ```sh
  oc extract secret/grafana-oauth-sa-token-nhpzm --keys=token --to=- >> values.yaml
  ```
- datasource env variable use in kaoto parameter

## Troubleshooting: 

- grafana datasource not working
    oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-oauth-sa 

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