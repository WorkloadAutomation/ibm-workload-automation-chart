/*
 * *******************************************************************************
 * Licensed Materials - Property of HCL
 * (c) Copyright HCL Technologies Ltd. 2022. All Rights Reserved.
 * 
 * Note to U.S. Government Users Restricted Rights:
 * Use, duplication or disclosure restricted by GSA ADP Schedule
 * *******************************************************************************
 */
{{/*
Expand the name of the chart.
*/}}
{{- define "aida-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aida-exporter.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "aida-exporter" .Values.nameOverride }}
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
{{- define "aida-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Common labels
*/}}
{{- define "aida-exporter.labels" -}}
helm.sh/chart: {{ include "aida-exporter.chart" . }}
{{ include "aida-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Selector labels
*/}}
{{- define "aida-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aida-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{/*
Create the name of the service account to use
*/}}
{{- define "aida-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aida-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default .Values.global.serviceAccountName .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Generate the WA URL
*/}}
{{- define "aida-exporter.waHostName" -}}
{{- if .Values.waHostName }}
{{- .Values.waHostName }}
{{- else }}
{{- include "waMdm.ServiceName" . }}
{{- end }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aida-es.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "aida-es" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
{{/*
Create common master service name.
*/}}
{{- define "waMdm.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waserver" -}}
{{- end -}}
