/*
 * *******************************************************************************
 * Licensed Materials - Property of HCL
 * (c) Copyright HCL Technologies Ltd. 2023. All Rights Reserved.
 * 
 * Note to U.S. Government Users Restricted Rights:
 * Use, duplication or disclosure restricted by GSA ADP Schedule
 * *******************************************************************************
 */
{{/*
Expand the name of the chart.
*/}}
{{- define "aida.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aida.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "aida" .Values.nameOverride }}
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
{{- define "aida.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Common labels
*/}}
{{- define "aida.labels" -}}
helm.sh/chart: {{ include "aida.chart" . }}
{{ include "aida.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Selector labels
*/}}
{{- define "aida.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aida.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{/*
Create the name of the service account to use
*/}}
{{- define "aida.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aida.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default .Values.global.serviceAccountName .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Initialize parameters by merging them with the root context
*/}}
{{- define "wa.init" -}}
  {{- $args := . -}}
  {{- $root := first $args -}}
  {{- $appName := index $args 1 -}}
  {{- $appNameDict := dict "appName" $appName -}}
  {{- $_ := merge $root $appNameDict -}}
{{- end -}}
{{- define "wa.fullName" -}}
  {{- $appName := include "wa.appName" . | trunc 9 }}
  {{- $longName := (printf "%s-%s" .Release.Name $appName) -}}
  {{- if (gt (len $longName) 64) -}}
    {{- $truncReleaseName := .Release.Name | trunc 64 -}}
    {{- $rand := randAlphaNum 4 | lower -}}
    {{- $fullName := (printf "%s-%s-%s" $truncReleaseName $appName $rand) -}}
    {{- $fullName -}}
  {{- else -}} 
    {{- $longName -}}
  {{- end -}}
{{- end -}}
{{/*
Returns the app name
*/}}
{{- define "wa.appName" -}}
  {{ .appName }}
{{- end -}}
{{/*
Returns the node affinity
*/}}
{{- define "wa.nodeaffinity" -}}
nodeAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
      - key: kubernetes.io/arch
        operator: In
        values:
        - amd64
    weight: 3
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: kubernetes.io/arch
        operator: In
        values:
        - amd64
{{- end -}}