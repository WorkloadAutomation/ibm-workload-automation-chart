{{/*
####################################################################
# Licensed Materials Property of HCL*
# (c) Copyright HCL Technologies Ltd. 2020. All rights reserved.
#
# * Trademark of HCL Technologies Limited
####################################################################
*/}}
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
{{/*
Returns the app name
*/}}
{{- define "wa.appName" -}}
  {{ .appName }}
{{- end -}}
{{/*
Returns the labels 
*/}}
{{- define "wa.server.labels" -}}
app.kubernetes.io/name: {{ include "wa.appName" . | quote}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: {{ .Chart.Name | quote }}
release: {{ .Release.Name | quote }}
{{- range .Values.global.customLabels }}
{{ .name }}: {{ .value | quote }} 
{{- end }}
{{- end -}}
{{/*
Returns the metering information
*/}}
{{- define "wa.pvu.metering" -}}
productName: "IBM Workload Scheduler"
productID: "c81f41563d584e3080bda3c5d7cef583"
productVersion: "10.1"
productMetric: "PROCESSOR_VALUE_UNIT"
productChargedContainers: "All"
{{- end -}}
{{/*
Returns the metering information
*/}}
{{- define "wa.metering" -}}
productName: "IBM Workload Scheduler"
productID: "24c3eb78bdc54b7bbe61dd03bba48fe2"
productVersion: "10.1"
productMetric: "TEN_MONTHLY_JOBS"
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
{{/*
Creates and returns a full name by concatenating the release name and the app name.
Full name is also used as statefulset name and pvc names are built on this value, so in order to generate a
reasonable pvc name length the full name is limited to 63 chars (which is also the maximum supported length for 
Kubernetes labels).
If the obtained full name is longer than 63 chars the release name is truncated to 48 chars and a random 4 chars 
string is appended at the end of the name.
*/}}
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
Creates and returns a volume claim template name by concatenating the prefix passed as a parameter, the release name and the app name.
Volume claim template name is also used to build pvc names, so in order to generate a reasonable pvc name length the volume claim 
template name is limited to 63 chars (which is also the maximum supported length for Kubernetes labels).
If the obtained name is longer than 63 chars the prefix is first truncated to 20 chars and a random 4 chars string is appended 
at the end of the name. Then, if the obtained name is still too long, also the release name is truncated to 27 chars 
*/}}
{{- define "wa.volumeClaimTemplateName" -}}
  {{- $args := . -}}
  {{- $root := first $args -}}
  {{- $paramsPvcName := index $args 1 -}}
  {{- $defaultPvcName := "data" -}}
  {{- $dataPvcName := coalesce $paramsPvcName $defaultPvcName -}}
  {{- $releaseName := $root.Release.Name }} 
  {{- $appName := include "wa.appName" $root | trunc 9}} 
  {{- $maxLength := 63 }} 
  {{- $dataPvcNameMaxLength := 20 }} 
  {{- $releaseNameMaxLength := 27 }} 
  {{- $dataPvcNameLength := len $dataPvcName }} 
  {{- $releaseNameLength := len $releaseName }} 
  {{- $longName := (printf "%s-%s-%s" $dataPvcName $releaseName $appName) -}}
  {{- if (gt (len $longName) $maxLength) -}}
    {{- $rand := randAlphaNum 4 | lower -}}
    {{- if (gt $dataPvcNameLength $dataPvcNameMaxLength) -}}
      {{- $dataPvcName := $dataPvcName | trunc $dataPvcNameMaxLength | trimSuffix "-" -}}
	  {{- $longName := (printf "%s-%s-%s-%s" $dataPvcName $releaseName $appName $rand) -}}
      {{- if (gt (len $longName) $maxLength) -}}
        {{- $releaseName := $releaseName | trunc $releaseNameMaxLength | trimSuffix "-" -}}
	    {{- $longName := (printf "%s-%s-%s-%s" $dataPvcName $releaseName $appName $rand) -}}
	    {{- $longName -}}
      {{- else -}} 
        {{- $longName -}}   
      {{- end -}}
    {{- else -}}
	  {{- $sum := add $releaseNameMaxLength $dataPvcNameMaxLength -}}
	  {{- $releaseNameTruncLength := int (sub $sum $dataPvcNameLength) -}} 
      {{- $releaseName := $releaseName | trunc $releaseNameTruncLength | trimSuffix "-" -}}
	  {{- $longName := (printf "%s-%s-%s-%s" $dataPvcName $releaseName $appName $rand) -}}
	  {{- $longName -}}  
    {{- end -}}
  {{- else -}}
    {{- $longName -}}   
  {{- end -}}
{{- end -}}
	