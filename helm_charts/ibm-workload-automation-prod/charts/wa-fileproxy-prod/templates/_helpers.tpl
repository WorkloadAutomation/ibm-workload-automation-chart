{{/*
Expand the name of the chart.
*/}}
{{- define "wa-fileproxy-prod.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wa-fileproxy-prod.fullname" -}}
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
{{- define "wa-fileproxy-prod.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Common labels
*/}}
{{- define "wa-fileproxy-prod.labels" -}}
helm.sh/chart: {{ include "wa-fileproxy-prod.chart" . }}
app.kubernetes.io/name: {{ include "wa-fileproxy-prod.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Selector labels
*/}}
{{- define "wa-fileproxy-prod.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wa-fileproxy-prod.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{/*
Create the name of the service account to use
*/}}
{{- define "wa-fileproxy-prod.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wa-fileproxy-prod.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Create common master username.
*/}}
{{- define "wa.fileproxy.waUser" -}}
{{- $name := default .Release.Name }}
{{- printf "%s-%s" $name "fileproxy" -}}
{{- end -}}
{{- define "wa.fileproxy.SecretName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "wafileproxy" "secret" -}}
{{- end -}}
