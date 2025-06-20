helm upgrade -i camel-k-poc infrastructure

# manual step: extract grafana sa token secret and fill into values.yaml
# oc extract secret/grafana-oauth-sa-token- --keys=token --to=- >> values.yaml

# manual step: note down the tracing endpoint from the distributor and fill into each deployXXX.sh file 
# --trait tracing.endpoint=http://tempo-tempo.poc-camel-k.svc.cluster.local:4318/api/traces
# --trait tracing.endpoint=http://tempo-tempo-distributor.devspaces-georg.svc.cluster.local:14268/api/traces
# --trait tracing.endpoint=http://tempo-tempo.poc-camel-k.svc.cluster.local:4318/api/traces

cd usecase2-db
sh deploy_postgresql-to-mqtt-and-file.sh
cd ..

cd usecase2-mqtt-consumer
sh deploy_mqtt-to-log.sh
cd ..

cd usecase5-xml-to-json
sh deploy_xml-to-json-mqtt.sh
cd ..

cd usecase7-csv-to-json
sh deploy_csv-to-json-mqtt.sh 
cd ..