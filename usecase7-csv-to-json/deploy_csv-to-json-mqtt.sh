#!/usr/bin/env bash

# Camel JBang Export into a Quarkus application
echo "Using Camel JBang to export into a Quarkus application..."
rm -rfv ./ceq
camel export * \
--runtime=quarkus \
--gav=vw.man.poc:csv-to-json-mqtt:1.0.0 \
--quarkus-artifact-id=quarkus-bom \
--quarkus-group-id=com.redhat.quarkus.platform \
--quarkus-version=3.15.3.SP1-redhat-00002 \
--maven-settings=/home/user/.m2/settings.xml \
--dir=./ceq \
--dep=io.quarkus:quarkus-openshift,io.quarkus:quarkus-kubernetes-config,org.apache.camel.quarkus:camel-quarkus-microprofile-health,\
org.apache.camel.quarkus:camel-quarkus-micrometer,io.quarkus:quarkus-micrometer-registry-prometheus,\
org.apache.camel.quarkus:camel-quarkus-opentelemetry,org.apache.camel.quarkus:camel-quarkus-management,\
org.apache.camel.quarkus:camel-quarkus-jaxb,org.jolokia:jolokia-agent-jvm:2.1.1
echo "Export completed."

echo "[custom] Adding extra properties..."
echo "quarkus.openshift.labels.\"app.openshift.io/runtime\"=camel" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.labels.\"app.kubernetes.io/part-of\"=camel-poc-apps" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.build-strategy=DOCKER" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.jvm-dockerfile=src/main/docker/Dockerfile.jvm" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.resources.requests.cpu=10m" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.resources.requests.memory=512Mi" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.resources.limits.cpu=500m" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.resources.limits.memory=512Mi" >> ./ceq/src/main/resources/application.properties
echo "quarkus.openshift.ports.jolokia.container-port=8778" >> ./ceq/src/main/resources/application.properties
echo "quarkus.otel.exporter.otlp.traces.endpoint=http://tempo-tempo.camel-k-poc.svc:4317" >> ./ceq/src/main/resources/application.properties
# echo "quarkus.otel.exporter.otlp.traces.endpoint=http://tempo-tempo-distributor.poc-camel-k.svc.cluster.local:4317" >> ./ceq/src/main/resources/application.properties
echo "quarkus.camel.metrics.enable-route-policy=true" >> ./ceq/src/main/resources/application.properties
echo "quarkus.camel.metrics.enable-message-history=true" >> ./ceq/src/main/resources/application.properties
echo "quarkus.camel.metrics.enable-exchange-event-notifier=true" >> ./ceq/src/main/resources/application.properties
echo "quarkus.camel.metrics.enable-route-event-notifier=true" >> ./ceq/src/main/resources/application.properties
echo "quarkus.camel.metrics.enable-instrumented-thread-pool-factory=true" >> ./ceq/src/main/resources/application.properties

echo "%prod.quarkus.kubernetes-config.enabled=true" >> ./ceq/src/main/resources/application.properties
echo "%prod.quarkus.kubernetes-config.secrets.enabled=true" >> ./ceq/src/main/resources/application.properties
echo "%prod.quarkus.kubernetes-config.secrets=mqtt-secret,minio-secret" >> ./ceq/src/main/resources/application.properties
echo "[custom] Extra properties added."

echo "[custom] Adding Jolokia agent configuration for the connection with Hawtio Online in the Dockerfile.jvm..."
# For MacOS
# sed -i '' 's|ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"|ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -javaagent:/deployments/lib/main/org.jolokia.jolokia-agent-jvm-2.1.1-javaagent.jar=caCert=/var/run/secrets/kubernetes.io/serviceaccount/service-ca.crt,clientPrincipal=cn=hawtio-online.hawtio.svc,discoveryEnabled=false,host=*,port=8778,protocol=https,useSslClientAuthentication=true"|' ./ceq/src/main/docker/Dockerfile.jvm
# For Linux
sed -i 's|ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"|ENV JAVA_OPTS_APPEND="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager -javaagent:/deployments/lib/main/org.jolokia.jolokia-agent-jvm-2.1.1-javaagent.jar=caCert=/var/run/secrets/kubernetes.io/serviceaccount/service-ca.crt,clientPrincipal=cn=hawtio-online.hawtio.svc,discoveryEnabled=false,host=*,port=8778,protocol=https,useSslClientAuthentication=true"|' ./ceq/src/main/docker/Dockerfile.jvm
echo "[custom] Jolokia agent configuration added in Dockerfile.jvm."

echo "Adding javaagent classifier to the jolokia-agent-jvm dependency in the POM file..."
# For MacOS
# sed -i '' 's|<artifactId>jolokia-agent-jvm</artifactId>|<artifactId>jolokia-agent-jvm</artifactId><classifier>javaagent</classifier>|' ./ceq/pom.xml
# For Linux
sed -i 's|<artifactId>jolokia-agent-jvm</artifactId>|<artifactId>jolokia-agent-jvm</artifactId><classifier>javaagent</classifier>|' ./ceq/pom.xml
echo "POM file updated."

# echo "Deploying to OpenShift..."
cd ./ceq
./mvnw clean package -Dquarkus.openshift.deploy=true
echo "Deployment to OpenShift done."