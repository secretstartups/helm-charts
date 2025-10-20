{{/*
Expand the name of the chart.
*/}}
{{- define "base-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "base-service.fullname" -}}
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
{{- define "base-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
DAPR Annotations
*/}}
{{- define "base-service.dapr.pod.annotations"}}
dapr.io/enabled: "true"
dapr.io/app-id: {{ include "base-service.name" . }}
dapr.io/app-port: "{{ .Values.dapr.app_port }}"
#dapr.io/config: {{ .Values.dapr.config }}
dapr.io/log-as-json: "{{ .Values.dapr.log_as_json }}"
dapr.io/log-level: {{ .Values.dapr.log_level }}
dapr.io/api-token-secret: {{ .Values.dapr.secret_name }}
dapr.io/enable-api-logging: "true"
dapr.io/app-health-probe-interval: "{{ .Values.dapr.app_health_probe_interval }}"
dapr.io/app-health-check-path: "{{ .Values.dapr.app_health_check_path }}"
dapr.io/app-health-probe-timeout: "{{ .Values.dapr.app_health_probe_timeout }}"
dapr.io/app-health-threshold: "{{ .Values.dapr.app_health_threshold }}"
dapr.io/enable-app-health-check: "{{ .Values.dapr.app_health_check }}"
{{- end }}

{{/*
Common labels
*/}}
{{- define "base-service.labels" -}}
git-commit-hash: {{ .Values.image.tag | default .Chart.AppVersion }}
helm.sh/chart: {{ include "base-service.chart" . }}
{{ include "base-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "base-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "base-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "base-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "base-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper image name (for the container image)
*/}}
{{- define "base-service.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}
