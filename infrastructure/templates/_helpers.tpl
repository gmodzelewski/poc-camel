{{/*
Expand the name of the chart.
*/}}
{{- define "infrastructure.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "infrastructure.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "infrastructure.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "infrastructure.labels" -}}
helm.sh/chart: {{ include "infrastructure.chart" . }}
{{ include "infrastructure.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "infrastructure.selectorLabels" -}}
app.kubernetes.io/name: {{ include "infrastructure.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "infrastructure.image_fill_db" -}}
{{- if .Values.fill_db_image }}
{{- printf "%s" .Values.fill_db_image }}
{{- else }}
{{- printf "%s/%s/%s" "image-registry.openshift-image-registry.svc:5000" .Release.Namespace "fill-db:latest" }}
{{- end }}
{{- end }}

{{- define "infrastructure.image_fill_bucket" -}}
{{- if .Values.fill_bucket_image }}
{{- printf "%s" .Values.fill_bucket_image }}
{{- else }}
{{- printf "%s/%s/%s" "image-registry.openshift-image-registry.svc:5000" .Release.Namespace "fill-bucket:latest" }}
{{- end }}
{{- end }}

{{- define "infrastructure.image_ensure_bucket_exists" -}}
{{- if .Values.ensure_bucket_exists_image }}
{{- printf "%s" .Values.ensure_bucket_exists_image }}
{{- else }}
{{- printf "%s/%s/%s" "image-registry.openshift-image-registry.svc:5000" .Release.Namespace "ensure-bucket-exists:latest" }}
{{- end }}
{{- end }}

{{- define "infrastructure.image_minio" -}}
{{- if .Values.minio_image }}
{{- .Values.minio_image | quote }}
{{- else }}
{{- printf "quay.io/minio/minio:latest" }}
{{- end }}
{{- end }}

{{- define "infrastructure.amqbrokerurl" -}}
{{- printf "%s:%s" (coalesce .Values.amqbroker_url "tcp://broker-amq-mqtt-mqtt-0-svc") (coalesce .Values.amqbroker_port "1883" ) }}
{{- end }}
